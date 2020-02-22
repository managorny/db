-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
USE shop -- (наполнение базы из https://github.com/managorny/db/blob/master/les07/shop.sql)

-- наполнение таблицы

INSERT INTO orders
  (user_id)
VALUES
  (1),
  (1),
  (2),
  (3),
  (3),
  (5),
  (5);

-- выполнение задачи
SELECT id, name
FROM users as u
JOIN (SELECT DISTINCT user_id FROM orders) as o
ON u.id = o.user_id; 

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT products.name, catalogs.name
FROM products
LEFT JOIN catalogs
ON products.catalog_id = catalogs.id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
-- https://docs.google.com/document/d/1lubf-FSbIjTXHtRbp9QoTlKwfyni2AjOqZz9YdfngzQ/edit#

-- создадим и наполним таблицы
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255),
  `to` VARCHAR(255) 
);

INSERT INTO flights
	(`from`, `to`)
VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  `label` VARCHAR(255),
  `name` VARCHAR(255) 
);

INSERT INTO cities
	(`label`, `name`)
VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

-- выполнение задачи
SELECT
	flights.id,
	c_from.name as `from`,
	c_to.name as `to`
FROM flights
LEFT JOIN cities as c_from
ON flights.`from` = c_from.label
LEFT JOIN cities as c_to
ON flights.`to` = c_to.label
ORDER BY id ASC;