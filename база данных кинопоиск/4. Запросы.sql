USE kinopoisk;

-- Получаем ТОП-100 фильмов по версии пользователей
SELECT 
	title,
	user_rating AS rating
FROM movies 
ORDER BY user_rating DESC
LIMIT 100;

-- Выводим информацию о фильме (название, рейтинг, год, жанр, актёры и их роли)
SELECT 
	m.title,
	m.user_rating AS rating,
	m.year,
	g.genre,
	CONCAT(c.first_name, ' ', c.last_name) AS name,
	r.`role` 
FROM movies m
JOIN genres g ON g.id = m.genre_id
JOIN movies_celebs mc ON mc.movie_id = m.id
JOIN celebs c ON c.id = mc.celeb_id
JOIN roles r ON r.id = mc.role_id
WHERE m.id = 1;

-- Выводим список фильмов, в которых зведа принимала участие и в каких ролях
SELECT
	m.title,
	r.`role` 
FROM movies m
JOIN movies_celebs mc ON mc.movie_id = m.id
JOIN celebs c ON c.id = mc.celeb_id
JOIN roles r ON r.id = mc.role_id
WHERE c.id = 1;

-- Выводим список жанров и самый высокооценённый фильм в данном жанре
SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

SELECT 
	g.genre,
	m.title,
	m.user_rating AS rating
FROM genres g
JOIN movies m ON m.genre_id = g.id
GROUP BY g.genre
ORDER BY m.user_rating DESC;

-- Сортируем жанры по популярности
SELECT
	g.genre,
	COUNT(*) AS total_movies
FROM movies m
JOIN genres g ON m.genre_id = g.id
GROUP BY g.genre
ORDER BY total_movies DESC;

-- Выведем звёзд, родом из того же города что и пользователь
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS name
FROM celebs c
JOIN celebs_profiles cp ON c.id = cp.celeb_id
JOIN profiles p ON p.city = cp.city AND p.country = cp.country
JOIN users u ON u.id = p.user_id
WHERE u.id = 1;

