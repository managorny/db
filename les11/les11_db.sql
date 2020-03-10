-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

-- создадим и наполним таблицы
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

-- выполнение задачи
-- создадим таблицу logs

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	tablename VARCHAR(255),
	entry_id INT,
	name VARCHAR (255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=Archive;

-- создадим триггеры на таблицы users, catalogs, products
DELIMITER //
CREATE TRIGGER logs_from_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (tablename, entry_id, name) VALUES ('users', NEW.id, NEW.name);
END//

CREATE TRIGGER logs_from_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (tablename, entry_id, name) VALUES ('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER logs_from_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (tablename, entry_id, name) VALUES ('products', NEW.id, NEW.name);
END//

-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.



-- Практическое задание по теме “NoSQL”
-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
-- скриншот - https://github.com/managorny/db/blob/master/les11/les11_db_redis.jpeg
-- HSET ips '127.0.0.1' 1
-- HINCRBY ips '127.0.0.1' 1
-- HSET ips '127.0.0.2' 1
-- HINCRBY ips '127.0.0.2' 1
-- HINCRBY ips '127.0.0.2' 1
-- HGETALL ips
-- 1) "127.0.0.1"
-- 2) "2"
-- 3) "127.0.0.2"
-- 4) "3"

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
-- скриншот - https://github.com/managorny/db/blob/master/les11/les11_db_redis2.jpeg
-- HSET users 'sergey@mail.ru' sergey
-- HSET users 'petr@mail.ru' petr
-- HGET users 'petr@mail.ru'
-- "petr"
-- HGET users 'sergey@mail.ru'
-- "sergey"

-- HSET emails 'sergey' sergey@mail.ru
-- HSET emails 'petr' petr@mail.ru
-- HGET emails 'petr'
-- "petr@mail.ru"
-- HGET emails 'sergey'
-- "sergey@mail.ru"

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
-- команды работы с MongoDB через консоль

-- use shop
-- db.createCollection('catalogs')
-- db.createCollection('products')

-- db.catalogs.insert({name: 'Процессоры'})
-- db.catalogs.insert({name: 'Материнские платы'})
-- db.catalogs.insert({name: 'Видеокарты'})
-- db.catalogs.insert({name: 'Жесткие диски'})
-- db.catalogs.insert({name: 'Оперативная память'})

-- db.products.insert({
--		name: 'Intel Core i3-8100', 
--		description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 
--		price: '7890.00', 
--		catalog_id: ObjectId("507f1f77bcf86cd799439011")})

-- db.products.insert({
--		name: 'Intel Core i5-7400', 
--		description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 
--		price: '12700.00', 
--		catalog_id: ObjectId("507f1f77bcf86cd799439011")})

-- db.products.insert({
--		name: 'AMD FX-8320E', 
--		description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', 
--		price: '4780.00', 
--		catalog_id: ObjectId("507f1f77bcf86cd799439011")})

-- db.products.insert({
--		name: 'AMD FX-8320', 
--		description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', 
--		price: '7120.00', 
--		catalog_id: ObjectId("507f1f77bcf86cd799439011")})

-- db.products.insert({
--		name: 'ASUS ROG MAXIMUS X HERO', 
--		description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 
--		price: '19310.00', 
--		catalog_id: ObjectId("5349b4ddd2781d08c09890f3")})

-- db.products.insert({
--		name: 'Gigabyte H310M S2H', 
--		description: 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 
--		price: '4790.00', 
--		catalog_id: ObjectId("5349b4ddd2781d08c09890f3")})

-- db.products.insert({
--		name: 'MSI B250M GAMING PRO', 
--		description: 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 
--		price: '5060.00', 
--		catalog_id: ObjectId("5349b4ddd2781d08c09890f3")})
