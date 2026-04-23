# Справочник фильмы-режиссеры
#### Выполнила Рогачевская Анастасия
#### 3 курс 2 группа
#### СУБД - PostgreSQL

## 1. Схема базы данных

База данных состоит из **двух таблиц**.

### 1.1 Таблица `directors` (Режиссёры)

| Поле | Тип данных | Описание | Ограничения |
|------|-----------|----------|-------------|
| `id` | SERIAL | Уникальный идентификатор | PRIMARY KEY, AUTO INCREMENT |
| `full_name` | TEXT | ФИО режиссёра | NOT NULL |
| `birth_date` | DATE | Дата рождения | NOT NULL |
| `movies_count` | INTEGER | Количество фильмов | DEFAULT 0 |
| `is_deleted` | BOOLEAN | Флаг мягкого удаления | DEFAULT FALSE |
| `deleted_at` | TIMESTAMP | Дата удаления | NULL по умолчанию |

### 1.2 Таблица `movies` (Фильмы)

| Поле | Тип данных | Описание | Ограничения |
|------|-----------|----------|-------------|
| `id` | SERIAL | Уникальный идентификатор | PRIMARY KEY, AUTO INCREMENT |
| `title` | TEXT | Название фильма | NOT NULL |
| `director_id` | INTEGER | Ссылка на режиссёра | FOREIGN KEY → directors.id |
| `release_date` | DATE | Дата премьеры | — |
| `duration_minutes` | INTEGER | Длительность (мин) | CHECK > 0 |
| `rating` | NUMERIC(3,2) | Рейтинг (0–10) | CHECK 0–10 |
| `is_deleted` | BOOLEAN | Флаг мягкого удаления | DEFAULT FALSE |
| `deleted_at` | TIMESTAMP | Дата удаления | NULL по умолчанию |

---

### 2. Тип связи
**Один-ко-многим (1:N)** — один режиссёр может снять несколько фильмов.

### 3. Внешний ключ
```sql
CONSTRAINT fk_movies_director
    FOREIGN KEY (director_id)
    REFERENCES directors(id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
