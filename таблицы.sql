-- Режиссёры
CREATE TABLE IF NOT EXISTS directors (
    id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    birth_date DATE NOT NULL,
    movies_count INTEGER DEFAULT 0,
	
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP
);

-- Фильмы
CREATE TABLE IF NOT EXISTS movies (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    director_id INTEGER NOT NULL,
    release_date DATE,
    duration_minutes INTEGER CHECK (duration_minutes > 0),
    rating DECIMAL(3,2) CHECK (rating >= 0 AND rating <= 10),
    
	is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP,
    
	CONSTRAINT fk_movies_director
        FOREIGN KEY (director_id)
        REFERENCES directors(id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

INSERT INTO directors (full_name, birth_date, movies_count, is_deleted, deleted_at) VALUES
('Кристофер Нолан', '1970-07-30', 17, FALSE, NULL),
('Джеймс Кэмерон', '1954-08-16', 29, FALSE, NULL),
('Стивен Спилберг', '1946-12-18', 60, FALSE, NULL);

INSERT INTO movies (title, director_id, release_date, duration_minutes, rating, is_deleted, deleted_at) VALUES
('Начало', 1, '2010-07-08', 148, 8.70, FALSE, NULL),
('Интерстеллар', 1, '2014-10-26', 169, 8.70, FALSE, NULL),
('Титаник', 2, '1997-11-01', 194, 8.40, FALSE, NULL),
('Аватар', 2, '2009-12-10', 162, 8.00, FALSE, NULL),
('Терминал', 3, '2004-06-09', 124, 8.10, FALSE, NULL),
('Список Шиндлера', 3, '1993-11-30', 195, 8.90, FALSE, NULL);