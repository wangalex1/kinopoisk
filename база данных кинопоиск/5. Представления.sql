-- Новинки за последний год
DROP VIEW IF EXISTS view_new_movies;

CREATE VIEW view_new_movies AS 
  (SELECT m.title, g.genre, m.`year` FROM movies m 
		JOIN genres g ON (g.id = m.genre_id)
	WHERE TO_DAYS(NOW()) - TO_DAYS(m.`year`) <= 365	
	GROUP by m.id
	ORDER BY m.`year` DESC
   );
SELECT * FROM view_new_movies;

-- ТОП-100 фильмов
DROP VIEW IF EXISTS top_100_movies;

CREATE VIEW top_100_movies AS 
  (SELECT 
	title,
	user_rating AS rating
FROM movies 
ORDER BY user_rating DESC
LIMIT 100);
SELECT * FROM top_100_movies;
