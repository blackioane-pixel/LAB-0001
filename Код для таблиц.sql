-- Главная таблица
CREATE TABLE books (
    book_id      SERIAL PRIMARY KEY,          -- автоинкремент
    author_id    INTEGER NOT NULL,
    title        VARCHAR(200) NOT NULL,
    publish_year INTEGER NOT NULL,
    pages        INTEGER NOT NULL,
    publisher    VARCHAR(150) NOT NULL
);

-- Зависимая таблица
CREATE TABLE subscription (
    reader_id    INTEGER NOT NULL,
    book_id      INTEGER NOT NULL REFERENCES books(book_id)
                 ON UPDATE CASCADE ON DELETE CASCADE,
    issue_date   DATE NOT NULL,
    due_date     DATE NOT NULL,
    return_mark  BOOLEAN DEFAULT FALSE NOT NULL,
    PRIMARY KEY (reader_id, book_id, issue_date)
);