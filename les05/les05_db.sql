-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

-- Создадим базу для урока и таблицу для заданий 1 и 2.
DROP DATABASE IF EXISTS `les05`;
CREATE DATABASE `les05`;
USE `les05`;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	id SERIAL PRIMARY KEY,
	`firstname` VARCHAR(50),
	`lastname` VARCHAR(50),
	`email` VARCHAR(120) UNIQUE,
	`phone` BIGINT,
    `created_at` VARCHAR(255) DEFAULT NULL,
    `updated_at` VARCHAR(255) DEFAULT NULL,
    INDEX users_phone_idx(phone),
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

INSERT INTO `users` VALUES ('1','Mariah','Lindgren','lizzie82@example.net','1834031121',NULL, NULL),
('2','Thomas','Rempel','mkessler@example.org','35',NULL, NULL),
('3','Johanna','Collins','eloisa.schimmel@example.com','565', NULL, NULL),
('4','Bertram','Hirthe','ngraham@example.com','0','2017-03-30 13:18:55','2002-04-17 11:17:04'),
('5','Arlie','Emmerich','boehm.greta@example.org','97','1975-09-01 21:32:15','1999-05-09 20:48:32'),
('6','Magnolia','Barton','desiree06@example.com','5','1998-12-05 05:07:57','2019-06-08 05:30:12'),
('7','Marlene','Mraz','jeramie93@example.com','607559','2004-09-11 14:35:15','2015-09-17 19:00:21'),
('8','Sheridan','Roob','windler.kaelyn@example.net','0','1982-10-07 22:06:22','2008-06-01 10:37:56'),
('9','Justina','Konopelski','thad.king@example.com','560843','1974-04-24 13:50:51','1977-11-27 15:17:22'),
('10','Roma','Parker','fdenesik@example.com','143','1981-04-07 17:37:25','2017-05-03 01:15:40'); 

UPDATE `users`
	SET
		`created_at` = NOW(),
		`updated_at` = NOW()
	WHERE `created_at` IS NULL AND `updated_at` IS NULL
;

-- 2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
ALTER TABLE `users` MODIFY `created_at` DATETIME;
ALTER TABLE `users` MODIFY `updated_at` DATETIME;

-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
-- Создадим таблицу для задания 3

DROP TABLE IF EXISTS `storehouses_products`;
CREATE TABLE `storehouses_products` (
	id SERIAL PRIMARY KEY,
	`product_name` VARCHAR(255),
	`value` INT DEFAULT 0
);

INSERT INTO `storehouses_products` VALUES
	(1, 'product1', 0),
	(2, 'product2', 2500),
	(3, 'product3', 0),
	(4, 'product4', 30),
	(5, 'product5', 500),
	(6, 'product6', 1)
;

SELECT `value` FROM `storehouses_products` ORDER BY `value` = 0, `value`;


-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
-- Для наглядности можно использовать таблицу vk - https://github.com/managorny/db/blob/master/les03/vk_db_creation.sql и ее наполнение - https://github.com/managorny/db/blob/master/les04/crud.sql. Вместо таблицы users указать таблицу profiles.
-- USE vk; -- для наглядности
ALTER TABLE `users` -- для наглядности указать profiles вместо users
ADD `mounth_of_birth` enum('january', 'ferbruary', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december');

UPDATE `users`
	SET `mounth_of_birth` = 'may'
	WHERE id = 1;

UPDATE `users`
	SET `mounth_of_birth` = 'june'
	WHERE id = 2;

UPDATE `users`
	SET `mounth_of_birth` = 'december'
	WHERE id = 3;

UPDATE `users`
	SET `mounth_of_birth` = 'november'
	WHERE id = 4;

UPDATE `users`
	SET `mounth_of_birth` = 'january'
	WHERE id = 5;

UPDATE `users`
	SET `mounth_of_birth` = 'august'
	WHERE id = 6;
UPDATE `users`
	SET `mounth_of_birth` = 'july'
	WHERE id = 7;
UPDATE `users`
	SET `mounth_of_birth` = 'may'
	WHERE id = 8;

UPDATE `users`
	SET `mounth_of_birth` = 'ferbruary'
	WHERE id = 9;

UPDATE `users`
	SET `mounth_of_birth` = 'august'
	WHERE id = 10;

SELECT * FROM `users`
WHERE `mounth_of_birth` IN ('may', 'august');

-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
USE `les05`;
DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE `catalogs` (
	id SERIAL PRIMARY KEY,
	`products_name` VARCHAR(255),
	`product_type` VARCHAR(255),
);

INSERT INTO `catalogs` VALUES
(1, 'apple', 'fruits'),
(2, 'orange', 'fruits'),
(3, 'cucumber', 'vegetables'),
(4, 'watermelon','fruits'),
(5, 'carrot', 'vegetables')
;

SELECT * FROM `catalogs`
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);


-- Практическое задание теме “Агрегация данных”

-- 1. Подсчитайте средний возраст пользователей в таблице users
-- Предполагаем, что поле birthday в формате DATE
SELECT AVG(YEAR(NOW()) - YEAR(`birthday`)) FROM `users`; 
-- для наглядности можно использовать в базе vk таблицу profiles.
-- USE vk;
-- SELECT AVG(YEAR(NOW()) - YEAR(`birthday`)) FROM `profiles`;

-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
-- для наглядности можно использовать в базе vk таблицу profiles - https://github.com/managorny/db/blob/master/les03/vk_db_creation.sql и для наполнения https://github.com/managorny/db/blob/master/les04/crud.sql.
USE vk;

SELECT COUNT(*),
	DATE_FORMAT(DATE_FORMAT(`birthday`, '2020-%m-%d'), '%W') AS `weekday_name`
FROM 
	`profiles`
GROUP BY 
	`weekday_name`
ORDER BY 
	`weekday_name`;
-- с сортировкой пока не удалось найти правильное решение, чтобы с пн по вс и лаконично по коду. 


-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы
-- Упрощенная версия. Без учета улучшения если в ячейках отрицательные, дробные числа или 0.
-- Логарифм произведения равен сумме логарифмов, функцию экспоненты (exp) является обратной к натуральному логарифму (Ln), т.е. в нашем случае обычное умножение, как нам и нужно. 

-- можно для наглядности создать базу для проверки.
USE les05;
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test` (
	id SERIAL PRIMARY KEY,
	`value` INT
);

INSERT INTO `test` VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

SELECT exp(SUM(log(value))) FROM `test`;