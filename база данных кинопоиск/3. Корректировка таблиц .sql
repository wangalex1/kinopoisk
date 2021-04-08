-- Корректируем базу данных после filldb

USE kinopoisk;
-- Корректируем таблицу users
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Корректируем таблицу profiles
CREATE TEMPORARY TABLE gender2 (gender CHAR(1));
INSERT INTO gender2 VALUES ('m'), ('f');
UPDATE profiles SET gender = ( SELECT gender FROM gender2 ORDER BY RAND() LIMIT 1);
UPDATE profiles SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Корректируем таблицу celebs
UPDATE celebs SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Корректируем таблицу celebs_profiles
-- создать стобцы created_at и updated_at
ALTER TABLE celebs_profiles ADD COLUMN created_at DATETIME;
ALTER TABLE celebs_profiles ADD COLUMN updated_at DATETIME;
UPDATE celebs_profiles SET created_at = DATE_ADD('2010-01-01',INTERVAL ceiling(rand() * (datediff('2021-03-04','2010-01-01')+1)) -1 day);
UPDATE celebs_profiles SET updated_at = DATE_ADD('2010-01-01', INTERVAL ceiling(rand() * (datediff('2020-03-04','2010-01-01') + 1)) - 1 day);
UPDATE celebs_profiles SET gender = ( SELECT gender FROM gender2 ORDER BY RAND() LIMIT 1);

-- Корректируем таблицу media
-- В процессе редактирования таблицы понял что необходим столбец movie_id
ALTER TABLE media ADD COLUMN movie_id INT UNSIGNED;
UPDATE media SET movie_id = FLOOR (1 + (RAND() * 300)) WHERE 200 < id AND id <= 500;
-- Из-за не очень корректной генерации данной таблицы через filldb делаю следующие допущения для простоты: id 1...100 - файлы с биографией звёзд,
-- id 101...200 - файлы с фотографиями звёзд, id 201...500 - медиафайлы к фильмам, id 501...600 - файлы с фотографиями пользователей (аватары)
UPDATE media SET media_type_id = FLOOR (1 + (RAND() * 4));
UPDATE media SET celeb_id = FLOOR (1 + (RAND() * 100));
UPDATE media SET media_type_id = 3 WHERE id <=100;
UPDATE media SET media_type_id = 1 WHERE id > 500;
UPDATE media SET media_type_id = 1 WHERE 100 < id AND id <= 200;
UPDATE media SET user_id = NULL WHERE id <= 500;
UPDATE media SET celeb_id = NULL WHERE id > 200;
UPDATE media SET celeb_id=@num:=@num+1 WHERE 0 IN(SELECT @num:=0) AND id <= 100;
UPDATE media SET celeb_id=@num:=@num+1 WHERE 0 IN(SELECT @num:=0) AND 100 < id AND id <= 200;
UPDATE media SET user_id=@num:=@num+1 WHERE 0 IN(SELECT @num:=0) AND id > 500;
UPDATE media SET filename = CONCAT ('https://dropbox.com/imdb/file_', filename);
UPDATE media SET filename = CONCAT (filename , '.jpg') WHERE media_type_id = 1;
UPDATE media SET filename = CONCAT (filename , '.mp4') WHERE media_type_id = 2;
UPDATE media SET filename = CONCAT (filename , '.txt') WHERE media_type_id = 3;
UPDATE media SET filename = CONCAT (filename , '.txt') WHERE media_type_id = 4;
ALTER TABLE media MODIFY COLUMN metadata JSON;
UPDATE media SET metadata = CONCAT ('{"owner":"',
	(SELECT CONCAT (first_name,' ', last_name) FROM users WHERE id = user_id),
	'"}');
UPDATE media SET metadata = CONCAT ('{"owner":"',
	(SELECT CONCAT (first_name,' ', last_name) FROM celebs WHERE id = celeb_id),
	'"}');

-- Корректируем таблицу movies
UPDATE movies SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Корректируем таблицу rating
UPDATE rating SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

-- Создаём ключи
-- Filldb не хотела генерировать данные с заранее заданными ключами, приходится вносить их вручную после
-- Таблица celebs_profiles
ALTER TABLE celebs_profiles
  ADD CONSTRAINT celebs_profiles_celeb_id_fk 
    FOREIGN KEY (celeb_id) REFERENCES celebs(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT celebs_profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
  ADD CONSTRAINT celebs_profiles_bio_fk
    FOREIGN KEY (bio) REFERENCES media(id)
      ON DELETE SET NULL;

-- ключи для таблицы media
ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_celeb_id_fk 
    FOREIGN KEY (celeb_id) REFERENCES celebs(id);
   
-- ключи для таблицы movies
ALTER TABLE movies
  ADD CONSTRAINT movies_genre_id_fk 
    FOREIGN KEY (genre_id) REFERENCES genres(id),
  ADD CONSTRAINT movies_media_files_fk
    FOREIGN KEY (media_files) REFERENCES media(id)
      ON DELETE SET NULL;
     
-- ключи для таблицы movies_celebs
ALTER TABLE movies_celebs
  ADD CONSTRAINT movies_celebs_movie_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id),
  ADD CONSTRAINT movies_celebs_celeb_id_fk 
    FOREIGN KEY (celeb_id) REFERENCES celebs(id),
  ADD CONSTRAINT movies_celebs_role_id_fk 
    FOREIGN KEY (role_id) REFERENCES roles(id);

-- ключи для таблицы profiles
-- ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
     
-- ключи для таблицы rating
ALTER TABLE rating
  ADD CONSTRAINT rating_movie_id_fk 
    FOREIGN KEY (movie_id) REFERENCES movies(id),
  ADD CONSTRAINT rating_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);
      


