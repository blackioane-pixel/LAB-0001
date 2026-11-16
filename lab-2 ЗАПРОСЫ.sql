-- ============================================================
-- Лабораторная работа №2. Вариант 2
-- База данных: library_db
-- ============================================================

-- ------------------------------------------------------------
-- 1. Выбрать все книги, у которых прошел срок возврата.
-- ------------------------------------------------------------
SELECT s.reader_id, s.book_id, b.title, s.due_date
FROM subscription s
JOIN books b ON b.book_id = s.book_id
WHERE s.due_date < CURRENT_DATE
  AND s.return_mark = FALSE;

-- ------------------------------------------------------------
-- 2. Выбрать все книги, выпущенные издательствами, в название
--    которых входит слово «Москва».
-- ------------------------------------------------------------
SELECT book_id, title, publish_year, publisher
FROM books
WHERE publisher ILIKE '%Москва%';

-- ------------------------------------------------------------
-- 3. Создать таблицу, содержащую данные 1 запроса с указанием
--    года издания.
-- ------------------------------------------------------------
CREATE TABLE overdue_books AS
SELECT s.reader_id,
       s.book_id,
       b.title,
       b.publish_year,
       s.due_date
FROM subscription s
JOIN books b ON b.book_id = s.book_id
WHERE s.due_date < CURRENT_DATE
  AND s.return_mark = FALSE;

-- ------------------------------------------------------------
-- 4. Добавить в созданную таблицу книги, у которых до конца
--    срока возврата остался ещё месяц.
-- ------------------------------------------------------------
INSERT INTO overdue_books (reader_id, book_id, title, publish_year, due_date)
SELECT s.reader_id, s.book_id, b.title, b.publish_year, s.due_date
FROM subscription s
JOIN books b ON b.book_id = s.book_id
WHERE s.due_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 month'
  AND s.return_mark = FALSE;

-- ------------------------------------------------------------
-- 5. В созданной таблице для всех книг, выпущенных до 1990 года,
--    продлить срок возврата на 2 года.
-- ------------------------------------------------------------
UPDATE overdue_books
SET due_date = due_date + INTERVAL '2 years'
WHERE publish_year < 1990;

-- ------------------------------------------------------------
-- 6. Удалить из созданной таблицы записи для всех книг,
--    названия которых начинаются и заканчиваются на одну букву.
-- ------------------------------------------------------------
DELETE FROM overdue_books
WHERE LOWER(LEFT(title, 1)) = LOWER(RIGHT(title, 1));

-- ------------------------------------------------------------
-- 7. Посчитать сколько раз была выдана каждая из книг,
--    хранящихся в библиотеке.
-- ------------------------------------------------------------
SELECT b.book_id,
       b.title,
       COUNT(s.book_id) AS issue_count
FROM books b
LEFT JOIN subscription s ON s.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY issue_count DESC;