from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse
from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional
from database import get_db_cursor

app = FastAPI(
    title="Справочник: фильмы и режиссеры"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class DirectorCreate(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=200)
    birth_date: str
    movies_count: int = Field(default=0, ge=0)


class MovieCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=300)
    director_id: int = Field(..., gt=0)
    release_date: str
    duration_minutes: int = Field(..., gt=0)
    rating: float = Field(..., ge=0.0, le=10.0)
    description: Optional[str] = Field(default="", max_length=1000)


def format_date_iso(date_value):
    if date_value:
        if isinstance(date_value, str): return date_value
        return date_value.strftime('%Y-%m-%d')
    return None


@app.get("/", response_class=HTMLResponse)
async def root():
    try:
        with open("index.html", "r", encoding="utf-8") as f:
            return f.read()
    except FileNotFoundError:
        return "<h1>Файл index.html не найден</h1>"


# --- РЕЖИССЁРЫ ---

@app.get("/api/directors")
async def get_directors():
    try:
        cur, conn = get_db_cursor()
        cur.execute("""
            SELECT id, full_name, birth_date, movies_count 
            FROM directors WHERE is_deleted = FALSE ORDER BY full_name
        """)
        data = cur.fetchall()
        for d in data: d['birth_date'] = format_date_iso(d['birth_date'])
        cur.close()
        conn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/directors")
async def create_director(d: DirectorCreate):
    try:
        cur, conn = get_db_cursor()
        cur.execute("""INSERT INTO directors (full_name, birth_date, movies_count, is_deleted)
                       VALUES (%s, %s, %s, FALSE) RETURNING id""",
                    (d.full_name, d.birth_date, d.movies_count))
        new_id = cur.fetchone()['id']
        conn.commit()
        cur.close()
        conn.close()
        return {"id": new_id, "message": "Добавлен"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.put("/api/directors/{id}")
async def update_director(id: int, d: DirectorCreate):
    try:
        cur, conn = get_db_cursor()
        cur.execute("""UPDATE directors SET full_name=%s, birth_date=%s, movies_count=%s WHERE id=%s""",
                    (d.full_name, d.birth_date, d.movies_count, id))
        conn.commit()
        cur.close()
        conn.close()
        return {"message": "Обновлён"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/directors/{id}")
async def delete_director(id: int):
    try:
        cur, conn = get_db_cursor()
        cur.execute("UPDATE directors SET is_deleted=TRUE, deleted_at=%s WHERE id=%s", (datetime.now(), id))
        conn.commit()
        cur.close()
        conn.close()
        return {"message": "Удалён"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# --- ФИЛЬМЫ ---

@app.get("/api/movies")
async def get_movies():
    try:
        cur, conn = get_db_cursor()
        cur.execute("""
            SELECT m.id, m.title, d.full_name as director_name, 
                   m.release_date, m.duration_minutes, m.rating, m.description
            FROM movies m
            LEFT JOIN directors d ON m.director_id = d.id
            WHERE m.is_deleted = FALSE ORDER BY m.title
        """)
        data = cur.fetchall()
        for m in data:
            m['release_date'] = format_date_iso(m['release_date'])
            if m['rating']: m['rating'] = float(m['rating'])
        cur.close()
        conn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/movies")
async def create_movie(m: MovieCreate):
    try:
        cur, conn = get_db_cursor()
        cur.execute("""
            INSERT INTO movies (title, director_id, release_date, duration_minutes, rating, description, is_deleted)
            VALUES (%s, %s, %s, %s, %s, %s, FALSE) RETURNING id
        """, (m.title, m.director_id, m.release_date, m.duration_minutes, m.rating, m.description or ""))
        new_id = cur.fetchone()['id']
        conn.commit()
        cur.close()
        conn.close()
        return {"id": new_id, "message": "Добавлен"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.put("/api/movies/{id}")
async def update_movie(id: int, m: MovieCreate):
    try:
        cur, conn = get_db_cursor()
        cur.execute("""UPDATE movies SET title=%s, director_id=%s, release_date=%s, 
                       duration_minutes=%s, rating=%s, description=%s WHERE id=%s""",
                    (m.title, m.director_id, m.release_date, m.duration_minutes, m.rating, m.description or "", id))
        conn.commit()
        cur.close()
        conn.close()
        return {"message": "Обновлён"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/api/movies/{id}")
async def delete_movie(id: int):
    try:
        cur, conn = get_db_cursor()
        cur.execute("UPDATE movies SET is_deleted=TRUE, deleted_at=%s WHERE id=%s", (datetime.now(), id))
        conn.commit()
        cur.close()
        conn.close()
        return {"message": "Удалён"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/dropdown/directors")
async def get_directors_dropdown():
    try:
        cur, conn = get_db_cursor()
        cur.execute("SELECT id, full_name FROM directors WHERE is_deleted = FALSE ORDER BY full_name")
        data = cur.fetchall()
        cur.close()
        conn.close()
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)