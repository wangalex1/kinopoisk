CREATE DATABASE kinopoisk;

USE kinopoisk;

-- 1. Создаём таблицу пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  phone VARCHAR(120) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- 2. Создаём таблицу профилей
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL,
  gender CHAR(1) NOT NULL,
  birthday DATE,
  city VARCHAR(100),
  country VARCHAR(100),
  photo_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- 3. Создаём таблицу ролей
DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role VARCHAR(100) UNIQUE,
  created_at DATETIME DEFAULT NOW()
);

-- 4. Создаём таблицу жанров
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  genre VARCHAR(100) UNIQUE,
  created_at DATETIME DEFAULT NOW()
);

-- 5. Создаём таблицу фильмов
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100),
  genre_id INT UNSIGNED,
  year DATE,
  media_files INT UNSIGNED,
  user_rating FLOAT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- 6. Создаём таблицу знаменитостей
DROP TABLE IF EXISTS celebs;
CREATE TABLE celebs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()  
);

-- 7. Создаём таблицу профилей знаменитостей
DROP TABLE IF EXISTS celebs_profiles;
CREATE TABLE celebs_profiles (
  celeb_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  gender CHAR(1) NOT NULL,
  birthday DATE,
  city VARCHAR(100),
  country VARCHAR(100),
  bio TEXT NOT NULL,
  photo_id INT UNSIGNED
);

-- 8. Создаём таблицу связей актёров, фильмов и ролей
DROP TABLE IF EXISTS movies_celebs;
CREATE TABLE movies_celebs (
  movie_id INT UNSIGNED NOT NULL,
  celeb_id INT UNSIGNED NOT NULL,
  role_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (movie_id, celeb_id, role_id)
);

-- 9. Создаём таблицу оценок
DROP TABLE IF EXISTS rating;
CREATE TABLE rating (
  movie_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  rating INT NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (movie_id, user_id)
);

-- 10. Создаём таблицу типов медиафалов
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT NOW()
);

-- 11. Создаём таблицу медиафайлов
DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  media_type_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED,
  celeb_id INT UNSIGNED,
  filename VARCHAR(255) NOT NULL UNIQUE,
  size INT NOT NULL,
  metadata JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 12. Создаём таблицу с датами релизов   
DROP TABLE IF EXISTS releases;
CREATE TABLE releases (
  movie_id INT UNSIGNED NOT NULL PRIMARY KEY,
  DVD_rel BOOLEAN,
  DVD_rel_date DATE,
  BD_rel BOOLEAN,
  DB_rel_date DATE,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT NOW()
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()
);


