-- Создадим процедуру для обновления рейтинга фильмов
DROP PROCEDURE IF EXISTS kinopoisk.rate_update;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `imdb`.`rate_update`()
BEGIN
DECLARE vttl_rate FLOAT;
DECLARE vmovie_id INT;
DECLARE done INT DEFAULT 0;
DECLARE MovieCursor CURSOR FOR SELECT movie_id, AVG(rating) FROM rating GROUP BY movie_id;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;
OPEN MovieCursor;
WHILE done = 0 DO
  FETCH MovieCursor INTO vmovie_id, vttl_rate;
  UPDATE movies SET user_rating = vttl_rate WHERE movies.id = vmovie_id;
END WHILE;
CLOSE MovieCursor;
END
$$
DELIMITER ;
