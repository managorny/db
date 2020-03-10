-- Проект по итогам курса "Базы данных"
-- 1. Общее текстовое описание БД и решаемых ею задач.
-- Интернет-площадка по агрегации товаров и цен на них с разных магазинов. Собирает цены о товаре с разных магазинов и представляет в одном месте.
-- Есть информация о магазине, разделяет товары по категориям, дает возможность сохранять товары в избранное. 
-- Также позволяет складывать товары в корзину, для дальнейшей оплаты, при этом в корзине товары будут храниться определенное время.
-- Также при наличии скидок и акций у магазинов в сервисе будет показываться их наличие рядом с товаром на который действует скидка или акция, для просмотра всех акций и скидок продавца можно перейти в карточку магазина. 
-- Помимо того сервис позволяет просматривать наиболее популярные товары (на основе отзывов и покупок), а также смотреть и выкладывать статьи о различных товарах. Каждый товар имеет свои характеристики, оценку пользователей и их отзывы.

-- 2. Всего таблиц в базе - 14
-- users - пользователи
-- shops - магазины
-- categories - категории товаров
-- brands - производители товаров
-- products_groups - группы одинаковых товаров. Автоматически или полуавтоматически выделяются на основе собранных товаров. Создается общая информация о товаре с разных магазинов (характеристики, описание и пр.)
-- products - весь список товаров
-- sales - акции и скидки
-- shopping_cart - корзина, хранится неоплаченной 3 суток
-- favorites - избранные товары (только для зарегестрированных пользователей)
-- customer_reviews - отзывы покупателей о товаре
-- articles - статьи о товарах и рынке
-- media_types - типы медии, чтобы в разных вкладках отображать на сайте. Фото, видео, док. файлы (pdf, docx, xlsx, pptx)
-- media - вся media для товаров, логотипов и т.п.
-- logs - логи действий с базой

-- 3. Создаем структуру БД
CREATE DATABASE market;
USE market;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	login VARCHAR(50) UNIQUE NOT NULL,
	firstname VARCHAR(255),
	lastname VARCHAR(255),
	email VARCHAR(100),
	phone VARCHAR(30),
	city VARCHAR(128),
	`password` VARCHAR(32),
	salt VARCHAR(6),
	created_at DATETIME DEFAULT NOW(),
	last_enter DATETIME,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	INDEX users_phone_idx(phone),
	INDEX users_firstname_lastname_idx(firstname, lastname),
	INDEX users_login_idx(login),
	INDEX users_city_idx(city)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	media_type_id BIGINT UNSIGNED NOT NULL,
	filename VARCHAR(255),
	size INT,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),

	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS shops;
CREATE TABLE shops (
	id SERIAL PRIMARY KEY,
	personal_shop_code BIGINT UNSIGNED UNIQUE NOT NULL, -- чтобы не вставить один и тот же магазин
	name VARCHAR(255) NOT NULL,
	adress VARCHAR(300),
	phone VARCHAR(30),
	email VARCHAR(100),
	status ENUM('reliable', 'unreliable'),
	logo BIGINT UNSIGNED,
	photos BIGINT UNSIGNED,
	videos BIGINT UNSIGNED,
	website VARCHAR(50),
	description TEXT,
	
	INDEX shops_personal_shop_code_idx(personal_shop_code),
	INDEX shops_name_idx(name),
	INDEX shops_adress_idx(adress),
	INDEX shops_phone_idx(phone),
	FOREIGN KEY (logo) REFERENCES media(id),
	FOREIGN KEY (photos) REFERENCES media(id),
	FOREIGN KEY (videos) REFERENCES media(id)
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	UNIQUE unique_name(name(10)) 
);

DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	UNIQUE unique_name(name(10)),
	logo BIGINT UNSIGNED,
	photos BIGINT UNSIGNED,
	videos BIGINT UNSIGNED,
	website VARCHAR(50),
	description TEXT,
	
	INDEX brands_name_idx(name),
	INDEX brands_website_idx(website),
	FOREIGN KEY (logo) REFERENCES media(id),
	FOREIGN KEY (photos) REFERENCES media(id),
	FOREIGN KEY (videos) REFERENCES media(id)

);

DROP TABLE IF EXISTS products_groups;
CREATE TABLE products_groups (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	specifications JSON,
	`min_price` INT UNSIGNED,
	files VARCHAR(255),
-- categories_id BIGINT UNSIGNED, -- закомментировано, т.к. на первый взгляд кажется идет дублирование из таблицы products, но при обращении к списку групп товаров конкретной категории (при фильтрации на сайте) необходимо делать JOIN. На данный момент проведенных исследований недостаточно, чтобы утверждать, что лучше дублирование, чем JOINы.
-- brand_id BIGINT UNSIGNED, -- закомментировано, т.к. смотри строчку выше

	INDEX products_groups_name_idx(name) -- , -- закомментировано, т.к. смотри выше
-- FOREIGN KEY (brand_id) REFERENCES brands(id), -- закомментировано, т.к. смотри выше
-- FOREIGN KEY (categories_id) REFERENCES categories(id) -- закомментировано, т.к. смотри выше
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description VARCHAR(512),
	shop_id BIGINT UNSIGNED,
	price INT,
	products_groups_id BIGINT UNSIGNED,
	brand_id BIGINT UNSIGNED,
	categories_id BIGINT UNSIGNED,

	INDEX products_idx(name),
	FOREIGN KEY (shop_id) REFERENCES shops(id),
	FOREIGN KEY (products_groups_id) REFERENCES products_groups(id),
	FOREIGN KEY (brand_id) REFERENCES brands(id),
	FOREIGN KEY (categories_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS customer_reviews;
CREATE TABLE customer_reviews (
	id SERIAL PRIMARY KEY,
	rating ENUM('1','2','3','4','5'),
	body TEXT,
	user_id BIGINT UNSIGNED,
	products_groups BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (products_groups) REFERENCES products_groups(id)
);

DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	article_title TEXT NOT NULL,
	article_media BIGINT UNSIGNED,
	article_text MEDIUMTEXT,
	product_id BIGINT UNSIGNED,

	INDEX articles_user_id_idx (user_id),
	FOREIGN KEY (article_media) REFERENCES media(id),
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	shop_id BIGINT UNSIGNED,
	product_id BIGINT UNSIGNED,
	value INT NOT NULL,

	PRIMARY KEY (shop_id, product_id),
	FOREIGN KEY (shop_id) REFERENCES shops(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE

);

DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED,
	product_id BIGINT UNSIGNED,
	product_price INT,
	special_sale VARCHAR(120), -- спец. предложения от площадки или магазина
	shop_id BIGINT UNSIGNED,
	status ENUM('purchase', 'non_purchase'),
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (user_id) REFERENCES users(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (shop_id) REFERENCES shops(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS favorites;
CREATE TABLE favorites (
	user_id BIGINT UNSIGNED,
	product_id BIGINT UNSIGNED,

	PRIMARY KEY (user_id, product_id),
	FOREIGN KEY (user_id) REFERENCES users(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES products(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	tablename VARCHAR(255),
	entry_id INT,
	name VARCHAR (255),
	price INT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=Archive;

-- 4. ERDiagram для БД
-- //ссылка//

-- 5. Наполнение БД (фековыми данными, для наглядного примера работы базы)

INSERT INTO users (login, firstname, lastname, email, phone, city, `password`, salt, created_at, updated_at) VALUES
('o.prishtina', 'Оксана', 'Приштина', 'prishtina@mail.ru', '79883323322', 'Москва', 'reg324Fsdf', 'fsddsd', '2010-04-13 15:06:20', '2010-06-13 15:06:20'),
('s.ivanov', 'Сергей', 'Иванов', 's.ivanov@mail.ru', '79245233232', 'Москва', 'rwerg32DD', '89jjll', '2012-12-12 10:06:20', '2013-02-13 20:22:20'),
('petrov234', 'Олег', 'Петров', 'petrov234@mail.ru', '79258829944', 'Серов', 'erssqqw2', 'gh78ff', '2014-01-10 15:00:10', '2019-03-29 19:06:20'),
('rudenkog', 'Георгий', 'Руденко', 'rudenkog@mail.ru', '79123455431', 'Екатеринбург', 'kjhjh8ggg', '8llmjh', '2014-12-10 13:38:47', '2018-06-13 15:06:20'),
('p.krasilov', 'Петр', 'Красилов', 'p.krasilov@mail.ru', '79451233422', 'Самара', 'ffdds443sss', 'kljmmm', '2019-09-19 14:27:57', '2020-01-14 14:18:52'),
('m.lepekhina', 'Мария', 'Лепехина', 'm.lepekhina@mail.ru', '79675678765', 'Саратов', 'fdsfsd322', 'vkvkcx', '2011-02-18 02:25:45', '2018-05-09 05:25:19'),
('moonlight', 'Светлана', 'Прелунная', 'moonlight@mail.ru', '79297865432', 'Пенза', 'djjxnask', 'dasd22', '2012-04-13 15:06:20', '2014-06-13 15:06:20'),
('lizar', 'Елизавета', 'Варина', 'lizar@mail.ru', '79778665521', 'Казань', 'kvkvooc', 'jdjkdk', '2016-04-16 03:12:17', '2019-09-22 04:53:36'),
('fedorst', 'Станислав', 'Федоров', 'fedorst@mail.ru', '79324332145', 'Владивосток', 'mcmc33asd', 'kk3311', '2013-04-13 15:06:20', '2019-06-13 15:06:20'),
('sedov.m', 'Михаил', 'Седов', 'sedov.m@mail.ru', '79876543348', 'Пермь', 'kdjfjjfvzzz', '928kwk', '2017-10-18 09:05:32', '2019-04-16 07:25:58'),
('v.kuznetsov', 'Валерий', 'Кузнецов', 'v.kuznetsov@mail.ru', '79126541231', 'Хабаровск', 'kxkkzcxz', 'skdl22', '2012-02-27 06:30:11', '2018-05-14 03:22:07'),
('anna.ryab', 'Анна', 'Рябкина', 'anna.ryab@mail.ru', '79123451231', 'Москва', 'kdkiiei', 'ldld33', '2010-07-31 12:12:27', '2016-06-03 08:07:29'),
('hromelen', 'Елена', 'Хромова', 'hromelen@mail.ru', '79903455643', 'Санкт-Петербург', 'vmmlalal', 'kdkdk3', '2018-12-23 11:55:53', '2019-06-14 11:53:59'),
('sergkir', 'Кирилл', 'Сергеев', 'sergkir@mail.ru', '79897751231', 'Москва', '93k2lsdl', 'kvkkvd', '2019-04-13 15:06:20', '2020-01-23 15:06:20'),
('aprskp', 'Антон', 'Проскопьев', 'aprskp@mail.ru', '79123455461', 'Новосибирск', 'mvmvmdd', 'ppaasd', '2020-01-19 15:06:20', '2020-02-13 11:56:32'),
('krulmar', 'Мария', 'Крулина', 'krulmar@mail.ru', '79123456755', 'Нягань', 'mzzkxsa', 'ododdd', '2019-04-13 05:23:44', '2020-02-23 15:06:20'),
('radin.sergey', 'Сергей', 'Радин', 'radin.sergey@mail.ru', '79663457831', 'Курск', 'ASD12kks', 'vblwll', '2017-02-18 10:06:20', '2019-06-28 19:16:21'),
('aleksey.pronin', 'Алексей', 'Пронин', 'aleksey.pronin@mail.ru', '79190345123', 'Калинингад', 'gHvcxsA', 'mdss33', '2020-01-20 15:06:20', '2020-02-09 22:42:09'),
('mihail.verstak', 'Михаил', 'Верстаков', 'mihail.verstak@mail.ru', '79623451267', 'Архангельск', 'QW212WWfv', 'VFiifd', '2019-12-30 20:16:08', '2020-01-08 19:06:20'),
('s.krupina', 'Софья', 'Крупина', 's.krupina@mail.ru', '79173451239', 'Омск', '828289191', 'DFSD33', '2012-04-13 15:06:20', '2013-06-13 04:26:11'),
('ekaterina.pimenova', 'Екатерина', 'Пименова', 'ekaterina.pimenova@mail.ru', '79323451235', 'Коломна', 'cdsfsdV43a', 'SASDkk', '2014-04-13 12:21:22', '2017-06-10 21:22:56'),
('anat.kadrat', 'Анатолий', 'Кандратов', 'anat.kadrat@mail.ru', '79128451241', 'Сергиев-Посад', 'kdkfsVVd', 'VCds32', '2011-02-11 11:16:20', '2012-06-13 13:12:45');

INSERT INTO media_types (name) VALUES
('photo'),
('video'),
('doc'),
('other');

INSERT INTO media VALUES
('1','1','neque.jpg','2434528',NULL,'2019-04-30 06:12:10'),
('2','2','architecto.avi','683596',NULL,'2015-06-07 11:19:48'),
('3','3','error.pdf','6189300',NULL,'2016-10-18 21:56:06'),
('4','4','nisi.zip','65951681',NULL,'2009-09-14 04:16:21'),
('5','1','dolor.jpg','64615981',NULL,'1979-03-08 12:30:38'),
('6','2','et.avi','633',NULL,'1973-06-20 18:27:56'),
('7','3','provident.pdf','69320038',NULL,'1992-05-14 16:49:53'),
('8','4','rerum','8',NULL,'1998-08-27 19:50:12'),
('9','1','tempora.jpg','133',NULL,'2001-09-20 19:20:44'),
('10','2','voluptatem.avi','63819518',NULL,'1987-01-22 15:58:27'),
('11','3','eos.pdf','344',NULL,'1994-07-03 17:07:31'),
('12','4','itaque','2159',NULL,'1982-09-27 21:26:39'),
('13','1','deserunt.jpg','919713793',NULL,'2009-10-09 14:18:03'),
('14','2','dolore.avi','4230',NULL,'2020-01-31 01:55:19'),
('15','3','distinctio.pdf','6444',NULL,'1977-05-26 15:23:08'),
('16','4','ut','84166125',NULL,'1974-04-26 01:53:21'),
('17','1','magnam.jpg','114',NULL,'1996-12-05 01:31:55'),
('18','2','ad.avi','9',NULL,'2018-02-05 16:16:19'),
('19','3','consequuntur.pdf','3',NULL,'2006-10-23 20:41:14'),
('20','4','omnis','706771',NULL,'2015-02-21 12:22:22'),
('21','1','sapiente.jpg','897',NULL,'1980-03-03 06:38:48'),
('22','2','alias.avi','93843250',NULL,'2008-10-24 21:23:45'),
('23','3','officiis.pdf','17844',NULL,'2005-04-15 12:58:43'),
('24','4','ea','624764',NULL,'1992-08-18 15:02:04'),
('25','1','consequatur.jpg','2829',NULL,'2019-03-10 19:05:00'),
('26','2','qui.avi','558929837',NULL,'1972-01-02 23:06:30'),
('27','3','qui.pdf','211',NULL,'2011-10-11 09:48:08'),
('28','4','explicabo','1836050',NULL,'2019-10-01 07:02:18'),
('29','1','atque.jpg','11672184',NULL,'1973-08-30 03:11:13'),
('30','2','quisquam.avi','337',NULL,'1995-02-23 19:37:15'),
('31','3','aut.pdf','0',NULL,'2012-01-01 11:26:08'),
('32','4','dolor','1626',NULL,'1971-04-14 17:09:34'),
('33','1','quis.jpg','85790687',NULL,'1996-08-08 05:58:54'),
('34','2','quia.avi','9510920',NULL,'1985-02-07 09:40:58'),
('35','3','consequatur.docx','3',NULL,'2000-09-17 20:20:37'),
('36','4','voluptas','555760',NULL,'2013-12-03 08:33:15'),
('37','1','veniam.jpg','306914',NULL,'1994-07-20 20:53:22'),
('38','2','ab.avi','72617',NULL,'1978-09-04 23:28:59'),
('39','3','tempore.docx','1789',NULL,'1989-05-04 12:43:46'),
('40','4','culpa','0',NULL,'2017-06-30 07:22:07'),
('41','1','incidunt.jpg','95262',NULL,'1996-11-12 22:14:22'),
('42','2','ab.avi','1708',NULL,'1979-06-13 06:59:07'),
('43','3','qui.docx','2547',NULL,'2015-06-22 10:16:18'),
('44','4','quia','1710204',NULL,'2015-03-31 14:51:31'),
('45','1','non.jpg','727',NULL,'1989-04-28 23:01:05'),
('46','2','ea.avi','635',NULL,'1971-07-12 09:41:28'),
('47','3','laboriosam.docx','52',NULL,'1991-04-28 19:57:36'),
('48','4','in','594483202',NULL,'2002-06-28 05:17:13'),
('49','1','delectus.jpg','727',NULL,'2017-10-30 14:07:33'),
('50','2','qui.avi','316986',NULL,'1985-11-08 03:31:29'),
('51','3','aliquam.docx','172',NULL,'2000-02-26 15:54:07'),
('52','4','possimus','4888',NULL,'1973-12-03 23:10:01'),
('53','1','deleniti.jpg','37',NULL,'1999-04-29 20:28:31'),
('54','2','voluptas.avi','0',NULL,'1987-04-17 10:52:49'),
('55','3','dignissimos.docx','320',NULL,'1982-03-10 20:59:49'),
('56','4','similique','5421',NULL,'1974-04-21 02:48:44'),
('57','1','expedita.jpg','232230',NULL,'1999-08-09 05:19:43'),
('58','2','dolorum.avi','169157',NULL,'2005-05-16 13:11:55'),
('59','3','accusamus.docx','74155',NULL,'2009-06-02 20:16:36'),
('60','4','et','1628354',NULL,'1991-02-24 15:54:13'),
('61','1','quia.jpg','5580281',NULL,'1982-05-14 11:52:43'),
('62','2','porro.avi','4671849',NULL,'1970-11-27 23:08:14'),
('63','3','vel.docx','58246',NULL,'2003-09-11 11:15:51'),
('64','4','similique','8551654',NULL,'2013-06-27 16:26:18'),
('65','1','quasi.jpg','5018344',NULL,'2016-02-06 02:34:55'),
('66','2','ut.mp4','1',NULL,'2015-03-29 13:01:12'),
('67','3','quo.docx','6',NULL,'2020-02-03 10:40:17'),
('68','4','voluptatem','0',NULL,'1986-02-16 16:18:48'),
('69','1','at.jpg','367450670',NULL,'1970-04-08 11:39:20'),
('70','2','officia.mp4','6',NULL,'1987-12-29 19:54:16'),
('71','3','dolor.docx','93',NULL,'1988-05-21 20:15:15'),
('72','4','rerum','0',NULL,'1978-06-13 02:34:14'),
('73','1','ut.jpg','37',NULL,'1997-01-29 21:50:49'),
('74','2','eius.mp4','327572880',NULL,'2009-09-30 15:18:15'),
('75','3','expedita.docx','44',NULL,'1977-02-23 03:16:23'),
('76','4','enim','8',NULL,'2003-02-06 06:00:58'),
('77','1','voluptatum.jpg','377825333',NULL,'1985-08-09 00:24:21'),
('78','2','quasi.mp4','21',NULL,'2003-11-21 12:40:48'),
('79','3','velit.xlsx','32736',NULL,'2017-11-22 22:28:52'),
('80','4','minus','19463407',NULL,'1971-02-14 16:02:04'),
('81','1','doloremque.jpg','8906',NULL,'2016-04-14 01:47:41'),
('82','2','adipisci.mp4','540660',NULL,'2014-12-30 13:52:36'),
('83','3','et.xlsx','742',NULL,'1988-06-22 00:17:05'),
('84','4','repellendus','439524633',NULL,'1975-11-02 06:04:58'),
('85','1','et.png','28',NULL,'1980-08-27 06:44:19'),
('86','2','voluptas.mp4','895',NULL,'1970-08-13 18:55:12'),
('87','3','velit.xlsx','45934112',NULL,'2011-09-08 21:11:55'),
('88','4','hic','0',NULL,'1989-02-05 05:26:00'),
('89','1','sint.png','2',NULL,'2013-10-14 13:07:40'),
('90','2','esse.mp4','37192403',NULL,'2020-01-16 05:42:53'),
('91','3','rerum.xlsx','0',NULL,'1986-09-07 09:15:48'),
('92','4','quidem','54',NULL,'1984-05-25 08:46:48'),
('93','1','ut.png','0',NULL,'2011-07-09 01:36:57'),
('94','2','placeat.mp4','21900',NULL,'2011-09-23 23:58:46'),
('95','3','cum.xlsx','709634',NULL,'2012-12-14 19:48:27'),
('96','4','vero','3950687',NULL,'2000-02-16 20:16:41'),
('97','1','ipsum.png','0',NULL,'1978-04-12 14:40:02'),
('98','2','ea.mp4','575419',NULL,'2005-11-27 20:08:54'),
('99','3','amet.xlsx','0',NULL,'2005-10-23 04:13:51'),
('100','4','iure','21',NULL,'1979-12-28 23:49:34'); 

INSERT INTO shops VALUES 
('1','94','Ростелеком','57849 David Ridges\nWest Ivory, IA 67601-0142','171-475-2350x9696','mante.marjorie@example.net','reliable',NULL,NULL,NULL,'http://gorczany.com/','Illo praesentium iusto et laborum at porro. Est aut consectetur odio voluptas. Architecto aut sequi dolorum. Repellat molestias minus minima molestiae.'),
('2','9409557','At.store.ru','1165 Emmet Forges Apt. 445\nNorth Fredrick, WI 15447','364.654.7105x8602','griffin.ruecker@example.net','unreliable',NULL,NULL,NULL,'http://trantow.com/','Cum dolore voluptatibus ea pariatur. Aperiam neque veniam pariatur et. In aspernatur eaque eos eos reiciendis beatae perferendis. Corporis unde alias in dicta cupiditate quos ducimus.'),
('3','25028','e2e4','28768 Schoen Ways Suite 477\nNorth Mollybury, AR 65731','054.630.1020x71307','loraine36@example.com','unreliable',NULL,NULL,NULL,'http://www.olsonerdman.com/','Quaerat qui culpa saepe eligendi. Qui non eum veritatis maxime temporibus et. Vero velit amet repudiandae et quos. Sit nostrum labore dicta qui neque esse.'),
('4','378849','Мегафон','783 Spinka Corners\nSouth Renee, VT 27809','692-563-5088x82957','ledner.lyda@example.com','reliable',NULL,NULL,NULL,'http://reichert.com/','Ullam officia earum error autem modi ipsam. Et distinctio nostrum quo pariatur hic. Officiis possimus ullam qui quae. Quia sunt a earum beatae.'),
('5','47974','Ekabas.ru','247 Cyril Isle Apt. 797\nWalkerport, UT 27279','(473)456-5778','delpha00@example.com','reliable',NULL,NULL,NULL,'http://adams.biz/','Accusamus quia nihil aliquam sunt consectetur quia facilis nostrum. Cumque quis qui ea sed ipsam in ullam quaerat. Delectus occaecati similique expedita nihil reprehenderit assumenda laudantium.'),
('6','6','Ситилинк','466 Gusikowski Trail Apt. 494\nHayleemouth, MN 51344','1-017-729-1209','iwyman@example.org','reliable',NULL,NULL,NULL,'http://rohanhalvorson.info/','Qui accusamus optio repudiandae deleniti quod voluptatum. Veritatis quasi animi et minus. Officiis facilis voluptas maiores tempora. Maiores atque et sequi. Necessitatibus veritatis qui ex.'),
('7','439576','KNS','59865 Demarco Land Suite 464\nUllrichshire, IA 56171-4028','243-422-6766','nturner@example.net','reliable',NULL,NULL,NULL,'http://www.bayer.com/','Quisquam consequatur tenetur beatae. Enim est nostrum cumque at optio ipsa ipsum.'),
('8','16777215','Связной','80532 Windler Rapids\nNew Estelleborough, CA 30640','491-061-0573','zsimonis@example.com','reliable',NULL,NULL,NULL,'http://www.mraz.com/','Quis quas quas doloremque sit et. Praesentium molestiae omnis assumenda voluptatibus voluptate reiciendis atque asperiores. Error facilis sint modi dolorum dolore natus exercitationem reprehenderit. Qui adipisci aut saepe quo accusantium aut est.'),
('9','4','RBT.ru','72195 Brady Forges\nLuraberg, WA 84848','06367974593','amani39@example.com','unreliable',NULL,NULL,NULL,'http://www.macejkovic.info/','Ex exercitationem voluptatum sunt adipisci enim veniam rerum. Quibusdam tempora laboriosam ex a. Quaerat rerum enim dolorem alias consectetur.'),
('10','58','ИНТЕЛЛЕКТ','77390 Erin Villages Apt. 341\nSouth Peteville, LA 02346-1344','261.161.5040x5125','spinka.irving@example.org','reliable',NULL,NULL,NULL,'http://www.friesen.info/','Sed repellendus sunt debitis animi. Sequi ex sed nulla numquam et aperiam. Omnis quod inventore est animi voluptatem.'),
('11','802','Корпорация центр','7666 Zackary Key Apt. 105\nLake Ameliastad, NH 73797','141-031-4288x217','dino28@example.net','unreliable',NULL,NULL,NULL,'http://weber.com/','Et excepturi ut saepe maxime. Quia in quos reprehenderit aperiam. Quis ad quo et quam. Consectetur officiis non id ut exercitationem ex quis temporibus.'),
('12','62','Фотосклад.ру','16333 Rempel View Apt. 306\nGreenmouth, ID 46627','07563028459','milford.koelpin@example.com','unreliable',NULL,NULL,NULL,'http://www.hintz.com/','Nisi beatae in rerum veritatis. Eius et laboriosam sed nostrum fuga temporibus. Sint nihil et officiis vel id.'),
('13','5','Клавторг','199 Anderson Knolls Apt. 090\nAlyshamouth, AL 84756-2218','+79(5)8104110109','lturcotte@example.org','unreliable',NULL,NULL,NULL,'http://www.streich.com/','Dignissimos repellendus sed in nihil. Facilis facilis tempora minus voluptatibus laborum autem assumenda ut. Accusamus eos nisi ea fuga.'),
('14','10682531','Oldi','69241 Conroy Summit\nHodkiewiczberg, MN 61171-8930','706-173-1844','rohan.ulices@example.org','unreliable',NULL,NULL,NULL,'http://www.kihn.com/','Voluptates autem maiores molestias et molestiae ut. Aut sed velit dolores autem nam pariatur. Voluptas autem ea quam optio repellat accusamus nostrum. Rerum distinctio voluptate reiciendis necessitatibus laborum temporibus quia.'),
('15','2485578','Нейман','860 Jarod Haven Suite 210\nAmirside, CA 48838','698.111.6845','irwin86@example.com','unreliable',NULL,NULL,NULL,'http://abbott.com/','Officia explicabo ducimus voluptatum quis sit placeat. Perferendis ipsa minus at ut et eius eaque. Ex quis autem dolores voluptatem sunt enim nisi.'),
('16','3765125','Вольта','72564 Mervin Union\nSouth Amytown, OR 84091','1-855-924-6381x57221','alf84@example.org','unreliable',NULL,NULL,NULL,'http://www.heller.com/','Fugit est molestiae minima in. Ratione ut quo nostrum expedita soluta. Et impedit omnis sunt eligendi.'),
('17','89448','AllCables.ru','30618 Darwin Underpass Apt. 624\nPort Lionelberg, AZ 90768-4966','1-933-196-6320x290','joseph86@example.com','unreliable',NULL,NULL,NULL,'http://gaylord.net/','Ratione quae vel pariatur nihil nesciunt sed est. Aut magnam ipsum et consequatur voluptas voluptatibus. Aut molestiae dignissimos non odit et. Est at exercitationem velit quis sit eum beatae.'),
('18','504','Apteka.RU','0394 Stamm Forge\nLake Samsonbury, RI 52080-2554','1-874-567-9766x76101','tritchie@example.com','unreliable',NULL,NULL,NULL,'http://gusikowski.org/','Non consequuntur in laudantium. Assumenda consectetur cum ea quia occaecati. Illo in voluptas omnis et.'),
('19','22299921','Дочки и Сыночки ЕКБ','768 Lenora Junctions\nLake Tyrese, PA 25664','(537)805-3426x444','miller.rosetta@example.com','unreliable',NULL,NULL,NULL,'http://moen.net/','Quibusdam voluptate autem dolore commodi non laudantium. Temporibus enim quas ut eum ut autem. Et omnis architecto enim ea incidunt impedit.'),
('20','535333','ОНЛАЙН ТРЕЙД.РУ','01362 Collier Wells\nWest Clifford, WV 20924-0322','060-335-6199x8548','arianna.roob@example.com','unreliable',NULL,NULL,NULL,'http://www.legros.com/','Amet laboriosam omnis doloremque deserunt accusamus. Sunt cum facilis molestias cupiditate dolorem laborum. Eaque provident nobis rerum recusandae voluptatum odio distinctio.'),
('21','9212','Shop-device','3563 Kaley Plaza Apt. 388\nMontanaview, HI 14003','1-821-252-7568x10664','hirthe.jedidiah@example.com','unreliable',NULL,NULL,NULL,'http://dickinsonking.com/','Ab et et ea sunt perferendis. Fuga ut modi sequi optio at reiciendis quia. Magni inventore alias non dolore laudantium quisquam. Incidunt sit consectetur officia veritatis eaque.'),
('22','50','Nils.ru','7720 Koss Roads Apt. 337\nWisozkbury, NJ 34106','1-209-616-2542x6237','xgoyette@example.org','unreliable',NULL,NULL,NULL,'http://www.sanford.org/','Praesentium odit nobis natus et. Voluptatem est similique cum repudiandae error consequatur deleniti qui. Tempora ea alias iure.'),
('23','18','quibusdam','30457 Pfeffer Wells\nWest Lindsay, CO 62492-2282','+64(0)5565324444','gusikowski.adriana@example.net','unreliable',NULL,NULL,NULL,'http://rempelkonopelski.biz/','Libero consectetur sed iste iure dolor ut quasi. Dignissimos possimus totam laboriosam. Quis beatae doloribus esse et eum.'),
('24','218','natus','67995 Schuster Harbors Apt. 591\nNorth Brandyn, MD 12076','544-954-2340','west.ulices@example.net','unreliable',NULL,NULL,NULL,'http://www.blickokon.com/','Sequi esse odio et voluptatem dolores. Reiciendis eos corrupti et et. Voluptatem earum rerum soluta ipsam consectetur repellendus.'),
('25','6460','voluptas','843 Hansen Wall Apt. 677\nLake Joshmouth, NM 27019','08476583390','daniella.dare@example.org','unreliable',NULL,NULL,NULL,'http://www.green.com/','Nesciunt quia similique sunt omnis consequuntur. Rerum laborum id optio quasi eaque. Non sit fuga nihil doloremque facere sit repellendus. Consequatur iste eos numquam illo quia fugit illo.'),
('26','6468','suscipit','67344 Laury Burg\nLake Creola, SD 75403-8579','1-173-421-3809x7924','xpfannerstill@example.com','unreliable',NULL,NULL,NULL,'http://russel.com/','Quis saepe excepturi reiciendis tempore animi quia et. Modi vel voluptate et eligendi. Quidem voluptatibus aliquid tenetur tempore odit.'),
('27','492','cumque','84170 Tillman Highway Apt. 264\nWunschside, OH 27353-2669','+33(1)6745782567','kane67@example.org','unreliable',NULL,NULL,NULL,'http://www.stoltenbergrosenbaum.com/','Voluptas blanditiis velit dolores at consequuntur. Sint nostrum vel velit sint enim. Nam reprehenderit eius quae optio vel nesciunt.'),
('28','5417026','dolorem','1922 Domenick Plain\nCleoview, IN 08826','1-682-932-7865x2275','stehr.braden@example.org','unreliable',NULL,NULL,NULL,'http://www.kovacekauer.biz/','Ullam nesciunt facilis sunt impedit. Eius sunt consequuntur soluta.'),
('29','7','aut','348 Adaline Run\nFayton, RI 21199','891.212.0715x334','heloise24@example.net','unreliable',NULL,NULL,NULL,'http://www.crist.com/','At laboriosam inventore occaecati sunt perspiciatis mollitia. Qui fuga quis qui laudantium beatae sed ipsam. Qui explicabo sapiente reiciendis perferendis nostrum itaque dignissimos et.'),
('30','2407464','dolorem','811 Buckridge Springs Suite 684\nWardstad, VA 81675-5288','(134)476-2413x615','feeney.horacio@example.org','unreliable',NULL,NULL,NULL,'http://www.zieme.com/','Corporis optio amet quia est fugiat. Magni quisquam enim minima dolorum ipsa aut sunt. Earum omnis dolorem quis esse qui quia architecto sunt.'),
('31','76356','sint','643 Stokes Rest Apt. 613\nPamelachester, OR 82636','(683)805-1834x8495','ludwig.heidenreich@example.com','unreliable',NULL,NULL,NULL,'http://boganankunding.com/','Fugiat non quia et et soluta quia. Corrupti adipisci quibusdam sunt id tenetur. Est iusto consequatur doloremque in iure iusto. Ab repellat omnis nulla soluta saepe rerum est. Ut magnam voluptate consequatur ipsam eius dolor.'),
('32','290641','autem','5808 Eula Cape\nNew Meganeport, UT 01073','1-635-804-9177x409','greg.herzog@example.org','reliable',NULL,NULL,NULL,'http://grant.org/','Dolores officia accusantium aspernatur repellendus ab officiis provident illo. Fugit voluptatum voluptate veritatis eos magni et. Molestiae nemo ipsa velit iste quae rerum aspernatur similique.'),
('33','8','nemo','759 Waldo Village Apt. 664\nEast Leolaview, OK 31841','915.508.6070x732','giuseppe.funk@example.com','reliable',NULL,NULL,NULL,'http://marquardtziemann.com/','Consequuntur est temporibus consequuntur. Cumque at ex eum. Distinctio sint et qui dolores quo sunt ullam. Repudiandae quia impedit aliquam libero velit blanditiis.'),
('34','937316','eum','295 Idell Greens\nNorth Jacquesfurt, ME 44316','1-147-255-0403x12013','bweimann@example.com','reliable',NULL,NULL,NULL,'http://www.strosincummerata.net/','Maiores cupiditate magni quaerat ipsa sit qui a rerum. Quam eum ea repellat sit sit architecto error. Quia consequatur consectetur amet veniam non iste expedita.'),
('35','345','ut','1647 Charles Well Suite 739\nNew Marian, ND 47368','(112)689-7731x0582','jackeline56@example.net','reliable',NULL,NULL,NULL,'http://keebler.biz/','Vel itaque qui ratione omnis amet quasi. Consequatur non quisquam voluptas qui voluptatum. Fugiat consequatur veritatis et harum sit. Tenetur repellat aut ducimus numquam.'),
('36','5064230','vel','43307 Rosamond Locks Suite 541\nNew Rudy, VT 99502-1572','(304)140-4586x694','kelton.dickens@example.net','unreliable',NULL,NULL,NULL,'http://mosciski.com/','Et dolores ipsa vitae culpa sint facilis. Nemo perferendis dolor et voluptatem dolorem nemo est omnis. Nemo et illum facilis fugit iusto. Nulla dolorem quia quidem.'),
('37','9','sed','680 Gulgowski Hill Suite 268\nRogahnchester, TX 61255','1-057-236-5369x2700','ykuvalis@example.org','unreliable',NULL,NULL,NULL,'http://westschuppe.com/','Harum aspernatur ut veritatis nobis nostrum occaecati qui tenetur. Officia sit quidem dolor autem tempore. Ut autem quam velit sit architecto labore. Hic dolores qui aliquid et officia dolor.'),
('38','22','in','717 Stroman Mews Apt. 538\nPort Emmett, SD 50867-3338','1-961-723-4913','jstracke@example.net','unreliable',NULL,NULL,NULL,'http://goyetteskiles.org/','Voluptatem veritatis architecto consequatur. Dolorum pariatur sed eligendi omnis magnam id sed. Qui et nesciunt et. Itaque tempore dolor necessitatibus soluta culpa officiis quia.'),
('39','6690','recusandae','93498 Kovacek Lodge Apt. 498\nKiarastad, WY 63301-2915','368-486-7041','muller.theresia@example.com','unreliable',NULL,NULL,NULL,'http://www.wyman.com/','Laboriosam et sint facilis veritatis. Voluptatum sit excepturi porro aut ut et vel. Sunt blanditiis eum quisquam vel eos repudiandae.'),
('40','5700','quos','9587 Quentin Burg\nDaytonside, NM 74568-9481','1-296-458-8779','maurine.smitham@example.org','unreliable',NULL,NULL,NULL,'http://www.welch.com/','Cumque nam nam repellat est rerum nemo sapiente aliquid. Sed ut maiores voluptates iure dignissimos rem.'),
('41','2742439','in','0406 Jaida Roads\nLake Lon, WY 24658-9595','(927)354-6012x682','dare.colleen@example.com','unreliable',NULL,NULL,NULL,'http://boyle.com/','Libero hic fugiat quasi voluptatem quia praesentium nobis. Consequatur expedita enim ipsa voluptatibus est magnam cum. Eum et at provident id.'),
('42','1266929','repudiandae','9171 Erika Ridges Suite 686\nWest Adeline, WY 75718-1131','1-619-476-7946','dino.littel@example.org','unreliable',NULL,NULL,NULL,'http://www.white.org/','Sit unde ea placeat aut similique repellat. Quisquam adipisci voluptatem dolorum asperiores laborum. Quaerat sed et sed assumenda enim qui.'),
('43','24908','et','798 Alberto Corners Suite 812\nPort Candice, NM 54128','869.988.8316','toy.champlin@example.com','unreliable',NULL,NULL,NULL,'http://kemmermcclure.biz/','Quos nihil ducimus qui perspiciatis repudiandae eum. Sint unde quia quibusdam pariatur molestiae. Consequatur facilis et quibusdam adipisci.'),
('44','1','alias','4805 Jeanne Ranch\nWest Corrine, CO 99777-1169','05093371364','dsmith@example.net','unreliable',NULL,NULL,NULL,'http://www.gutkowski.com/','Animi non dolor rerum fugit et nihil ea. Illum nulla eos animi nobis nulla dolorum. Minima occaecati porro suscipit et voluptas explicabo tempora.'),
('45','580','perferendis','930 Cummings Passage\nEleanoraside, MS 76226','225.765.2620','cdaugherty@example.net','unreliable',NULL,NULL,NULL,'http://www.feilemmerich.info/','Perferendis assumenda quo sequi. Laboriosam dolorem voluptas qui aut culpa sit iste. Voluptate ipsa veritatis expedita saepe sed maiores. Qui assumenda occaecati consequatur eum in.'),
('46','29','minima','6107 Beahan Hill Apt. 184\nNew Minerva, MI 19823-3763','892.391.0070x5502','bprosacco@example.org','unreliable',NULL,NULL,NULL,'http://www.runolfsson.com/','Praesentium rerum eos sint non. Quis ut nulla laborum cum impedit error laudantium. Et magnam necessitatibus iure quis natus est.'),
('47','1827','consectetur','7344 Joshuah Pines\nWest Mariamstad, NY 12411','+13(0)4036427196','geovanny.williamson@example.net','unreliable',NULL,NULL,NULL,'http://kub.com/','Ullam molestias ea fugiat quisquam eos voluptatem. Architecto illo tempore sed.'),
('48','78','sint','658 Paucek Valleys\nEast Mary, MT 81927','(533)609-3577','gglover@example.com','reliable',NULL,NULL,NULL,'http://mcglynn.info/','Quasi saepe quo et officiis voluptates et. Atque debitis illo aut nostrum perspiciatis quo. Animi necessitatibus est est temporibus quidem.');

INSERT INTO categories (name) VALUES
('Электроника'),
('Бытовая техника'),
('Компьютеры'),
('Ремонт'),
('Детям'),
('Авто'),
('Дом'),
('Спорт'),
('Красота'),
('Здоровье');

INSERT INTO brands VALUES
('1','Samsung',NULL,NULL,NULL,'http://www.torpdaugherty.com/','Omnis exercitationem maxime blanditiis alias nobis similique. Expedita fuga repellendus sit quod reiciendis sapiente quisquam eos. Dolore quisquam laudantium facere et molestias.'),
('2','Apple',NULL,NULL,NULL,'http://www.wiegand.com/','Sunt ut qui maxime eaque. Eaque ipsa consequatur vel dolor labore sunt. Distinctio ullam est cum perspiciatis explicabo dicta.'),
('3','Xiaomi',NULL,NULL,NULL,'http://www.hillshuels.com/','Quo praesentium voluptatem provident sequi non. Laborum esse facere ipsum temporibus consequatur. Excepturi voluptate doloremque nam et.'),
('4','Kabrita',NULL,NULL,NULL,'http://www.lowekuvalis.net/','Aut vero soluta velit quasi rerum eum. Magnam quos quia sint qui aut repellendus. Necessitatibus eum autem atque hic est a et.'),
('5','C-Russia',NULL,NULL,NULL,'http://www.pagacokuneva.info/','Ut vero fuga officia minima. Autem qui voluptas odit molestiae. Ut in ullam enim. Molestias praesentium aut rerum numquam mollitia eos.'),
('6','C.M.A.',NULL,NULL,NULL,'http://www.goodwinkoelpin.com/','Sint quod dicta ut quae placeat. Omnis pariatur et qui occaecati placeat perferendis. Eligendi dolor quo fuga quas. Est labore molestias minima sint eos.'),
('7','D&G',NULL,NULL,NULL,'http://west.com/','Quod sunt aut quis est dignissimos. Sapiente est perferendis voluptatem ab quaerat harum. Nihil culpa omnis velit eos et dolor. Eum qui id quia quis.'),
('8','e-Best',NULL,NULL,NULL,'http://larkin.org/','Vero explicabo molestiae veritatis facere. Dolorum dolore dolores et perspiciatis dolor sint. Sequi a accusantium atque ut distinctio amet illo. Voluptate qui officia ut possimus voluptatem.'),
('9','F-ONE',NULL,NULL,NULL,'http://beier.com/','Temporibus fuga vel totam. Cum enim quos expedita neque. Ea sapiente qui qui sit. Ex aut odit consequatur eaque iste.'),
('10','F.O.X',NULL,NULL,NULL,'http://www.hauck.com/','Et maiores reiciendis velit exercitationem expedita temporibus. Animi nostrum similique minima at commodi.'),
('11','H&M',NULL,NULL,NULL,'http://www.lehnercarter.biz/','Hic qui et in quia. Deleniti distinctio autem repellendus occaecati culpa nemo. Perspiciatis et aspernatur sit repellat ut.'),
('12','H.I.S.',NULL,NULL,NULL,'http://schaefer.com/','Sunt dolorum asperiores consectetur consequatur provident quisquam fugiat. Adipisci commodi aut veritatis sapiente sapiente. At eos nesciunt quia.'),
('13','H.W.S',NULL,NULL,NULL,'http://www.lebsack.com/','Ut ipsa deserunt rerum veniam at mollitia sed. Aut ea et rerum rerum. Sunt sint molestias quia fugiat sunt rerum.'),
('14','H2O',NULL,NULL,NULL,'http://www.okeefe.com/','Consequuntur vero molestias delectus sit quia quam quia. Culpa corrupti qui odit fugit eaque neque perferendis. Ut sed quibusdam eum atque atque aut. Sint maiores adipisci voluptatum doloremque unde non. Occaecati soluta porro laboriosam dicta qui tenetur.'),
('15','I Spirit',NULL,NULL,NULL,'http://mcclure.biz/','Voluptate enim qui non qui. Dignissimos veritatis et sed impedit aut dolores eum. Consequatur animi dignissimos repudiandae delectus esse quo voluptatem. Dolor voluptates consequatur dolor error.'),
('16','K-Flex',NULL,NULL,NULL,'http://hammes.com/','Ipsam ullam eos ex et rerum. Sint id sint et aspernatur. Voluptatibus laboriosam et autem rem quod explicabo laboriosam.'),
('17','M CITY',NULL,NULL,NULL,'http://bernier.com/','Necessitatibus mollitia perspiciatis id quia. Corporis recusandae voluptatum ad. Commodi sapiente ipsam pariatur accusamus numquam.'),
('18','N-Light',NULL,NULL,NULL,'http://erdmankunze.com/','Quae quasi mollitia quasi doloribus sunt. Inventore inventore sapiente cupiditate. Accusantium explicabo velit voluptas suscipit ea cupiditate.'),
('19','O\'Herbal',NULL,NULL,NULL,'http://reichel.com/','Delectus fuga adipisci saepe repellendus. Sed adipisci aut accusantium placeat laudantium non rem. Culpa ducimus omnis quibusdam sequi est ut.'),
('20','P-group',NULL,NULL,NULL,'http://www.johnston.com/','Incidunt necessitatibus est ullam laborum magnam reprehenderit. Suscipit et rerum molestias consequatur. Facilis sequi deserunt quia nam ut.'),
('21','QASMI',NULL,NULL,NULL,'http://www.framirolfson.net/','Est dolorem facere distinctio ullam aut error ea. Praesentium quia sunt sunt quisquam. Consequatur et sed reiciendis rerum.'),
('22','S-Model',NULL,NULL,NULL,'http://monahan.net/','Sunt reiciendis enim necessitatibus ipsam iusto voluptatem natus. Voluptatem voluptate rerum est repellendus mollitia. Reprehenderit molestiae optio aut voluptatem cupiditate sunt. Dolorem voluptas ad maxime sit ab odio molestiae.'),
('23','U&G',NULL,NULL,NULL,'http://prohaskaortiz.com/','Iste eum maiores nihil dolores magnam sed tenetur. Rerum asperiores impedit doloremque aliquam sed distinctio fugit. Necessitatibus fugit eius ab accusamus corporis expedita alias rerum.'),
('24','W&D',NULL,NULL,NULL,'http://walterbrakus.com/','Et et voluptates id praesentium. Consequatur error quaerat placeat ex aut. Pariatur repellendus aut cum cumque. Recusandae voluptatum modi consectetur exercitationem.'),
('25','Wadia',NULL,NULL,NULL,'http://kingadams.com/','Omnis porro provident et maiores deserunt maiores. Eaque voluptate quo voluptatem alias sunt dolor. Quibusdam et fugit qui corporis voluptates sit. Sunt rem illo enim aut atque voluptatem sunt. Consequatur totam voluptatibus enim tempora quos.'),
('26','X FACTOR',NULL,NULL,NULL,'http://emard.com/','Numquam corrupti quia alias et ea voluptatem enim. Nihil commodi sapiente ut asperiores ducimus perspiciatis. Ratione eligendi odit ut. At labore eum et ipsum fuga voluptatem itaque ratione.'),
('27','Y-MAXI',NULL,NULL,NULL,'http://conroydare.com/','Molestiae perspiciatis tempore suscipit quia excepturi. Ex et officia ipsa nulla sapiente minima natus. Veniam qui in neque corrupti id.'),
('28','Zabiaka',NULL,NULL,NULL,'http://hilpert.com/','Magni laboriosam temporibus cum eveniet maxime. Debitis odit omnis tempore qui. Perspiciatis et et tenetur quis qui. Accusantium ipsam explicabo blanditiis pariatur nihil.'),
('29','Баган',NULL,NULL,NULL,'http://lednerquitzon.com/','Id aut quibusdam non nulla dolores. Non expedita et quos enim sunt sed non ipsa. Dolor consectetur autem fugit optio accusamus. Rerum quibusdam ex quasi corrupti placeat perspiciatis non. Aliquam eos eos itaque aut voluptates ut qui.'),
('30','ГазонCity',NULL,NULL,NULL,'http://www.volkman.net/','Voluptatem similique molestiae et fugit natus nostrum. Eum ex minus nesciunt id consequuntur.'); 

-- наполним основными характеристиками, чтобы не усложнять чтение файла при вставке полных характеристик (максимальный набор характеристик вмещается по размеру в ячейку с типом JSON), также при вставке характеристик можно использовать JSON_OBJECT()
INSERT INTO products_groups (name, description, specifications, files) VALUES
('Смартфон Samsung Galaxy A50 64GB', NULL, 
'[{
	"Основные характеристики": {
		"Тип": "смартфон", 
		"Операционная система": "Android", 
		"Версия ОС на начало продаж": "Android 9.0", 
		"Тип корпуса": "классический", 
		"Количество SIM-карт": "2", 
		"Тип SIM-карты": "nano SIM", 
		"Режим работы нескольких SIM-карт": "попеременный", 
		"Бесконтактная оплата": "есть", 
		"Вес": "166 г",  
		"Размеры (ШxВxТ)": "74.7x158.5x7.7 мм"
	}}]', '34,35'),
('Планшет Apple iPad (2019) 32Gb Wi-Fi', 'Новый iPad имеет современную 64‑битную архитектуру, четыре ядра, более 3.3 млн транзисторов. Скорость гаджета поражает, поэтому он отлично подходит для работы с видео 4K, игр со сложной графикой и новейших приложений с дополненной реальностью.', 
'[{
	"Основные характеристики": {
		"Операционная система": "iOS", 
		"Процессор": "Apple A10", 
		"Количество ядер": "4", 
		"Вычислительное ядро": "ARM8", 
		"Техпроцесс": "16 нм", 
		"Встроенная память": "32 ГБ", 
		"Слот для карт памяти": "нет"
	}}]', '12,25'),
('Телевизор Xiaomi Mi TV 4S 43 T2 42.5" (2019)', 'ОЗУ - 2 ГБ', 
'[{
	"Основные характеристики": {
		"Тип": "ЖК-телевизор", 
		"Диагональ": "42.5\' (108 см)", 
		"Формат экрана": "16:9", 
		"Разрешение": "3840x2160", 
		"Разрешение HD": "4K UHD, HDR", 
		"Светодиодная (LED) подсветка": "есть", 
		"Стереозвук": "есть", 
		"Частота обновления экрана": "60 Гц", 
		"Smart TV": "есть", 
		"Платформа Smart TV": "Android", 
		"Год создания модели": "2019"
	}}]', '23,9'),
('Кабель Cablexpert HDMI - HDMI (CC-HDMI4)', NULL, 
'[{
	"Основные характеристики": {
		"Тип": "кабель", 
		"Назначение": "видео HDMI", 
		"Разъемы кабеля": "HDMI (M) - HDMI (M)", 
		"Версия HDMI": "1.4", 
		"Позолоченные разъемы": "есть", 
		"Дополнительная информация": "поддержка 3D, 4K (4096 x 2160), Ethernet"
	}}]', '43,8'),
('Смесь Kabrita 1 GOLD (0-6 месяцев) 800 г', 'Адаптированная смесь Kabrita 1 GOLD — прекрасная альтернатива грудному молоку. Смесь изготовлена из высококачественного козьего молока, которое легко и быстро усваивается организмом малыша.\nВ состав смеси включены современные функциональные ингредиенты. Подбор ингредиентов обеспечивает максимально сбалансированный рацион в период активного развития и роста. Комплекс DigestX копирует жировой профиль грудного молока, что обеспечивает лучшее пищеварение и снижает риск запоров, а также способствует усвоению кальция и повышению энергообмена. Пребиотики ГОС и ФОС, а также пробиотики (живые бактерии Bifidobacterium BB-12) предназначены для естественного укрепления иммунной системы. Нуклеотиды необходимы для лучшего иммунного ответа, а омега-3 (DHA) и омега-6 (ARA) — для развития мозга и зрения.\nГлавное преимущество продукта — полное отсутствие коровьего белка, на который у многих детей может возникать аллергия. В состав входит козье молоко — значительно более питательное и богатое витаминами, микроэлементами и полезными веществами для роста и укрепления иммунитета.', 
'[{
	"Основные характеристики": {
		"Тип": "сухая молочная смесь", 
		"Рекомендуемый возраст": "от 0 до 6 месяцев (1 ступень)", 
		"В состав входит": "бифидобактерии, пребиотики, пробиотики, козье молоко", 
		"В состав не входит": "сахар, консерванты", 
		"Упаковка": "банка", 
		"Вес": "800 г"
	}, 
	"Состав": {
		"Состав": "лактоза, растительные жиры (комплекс жиров DigestX (1,3-диолеол 2-пальмитиол триглицерид), рапсовое, пальмовое, подсолнечное масла), концентрат сывороточных белков козьего молока, обезжиренное сухое козье молоко, гидролизованный кукурузный крахмал, цельное сухое козье молоко, фруктоолигосахариды, галактоолигосахариды, минеральные вещества, рыбий жир (источник DHA), арахидоновая кислота, витамины, таурин, холина хлорид, холина битартрат, нуклеотиды (цитидин-5-монофосфат динатриум, уридин-5-монофосфат динатриум, аденозин-5-монофосфат динатриум, инозин-5-монофосфат динатриум, гуанозин-5-монофосфат динатриум), бифидобактерии (bifidobacterium, BB-12), мезоинозитол"
	}, 
	"Дополнительно": {	
		"Срок годности": "547 дн., от 0 до 25 гр. и не более 75% влажности"
	}}]', '1,2');

INSERT INTO products (name, description, shop_id, price, products_groups_id, categories_id, brand_id) VALUES 
('Смартфон Samsung Galaxy A50 SM-A505F/DS 64GB blue', 'Оплата наличными или банковской картой.\nГарантия производителя. Производство: Китай.', '1', '15990', '1', '1', '1'),
('Смартфон Samsung Galaxy A50 64GB черный', 'Гарантия производителя 1 год.', '2', '14330', '1', '1', '1'),
('Смартфон Samsung Galaxy A50 SM-A505F 6.4", 2340x1080 Super AMOLED, Exynos 9610, 4Gb RAM, 64Gb, 3G/LTE, NFC, WiFi, BT, 2x Cam, 2-Sim, 4000mAh, Android 9.0, белый (SM-A505FZWUSER)', 'Артикул: 684478', '3', '17000', '1', '1', '1'),
('Смартфон Samsung Galaxy A50 64GB Черный', '2G, 3G, 4G, Wi-Fi; ОС Android; Дисплей сенсорный емкостный 16,7 млн цв. 6.4"; Камера 25 Mpix, AF; Разъем для карт памяти; MP3, BEIDOU / GPS / ГЛОНАСС; Вес 166 г.', '4', '17990', '1', '1', '1'),
('Смартфон Samsung Galaxy A50 64GB white (белый)', 'смартфон с Android 9.0 поддержка двух SIM-карт экран 6.4" три камеры 25 МП/8 МП/5 МП, автофокус память 64 Гб, слот для карты памяти 3G, 4G LTE, LTE-A, Wi-Fi, Bluetooth, NFC, GPS, ГЛОНАСС объем оперативной памяти 4 Гб аккумулятор 4000 мА⋅ч вес 166 г, ШxВxТ 74.70x158.50x7.70 мм', '5', '14400', '1', '1', '1'),
('Планшет APPLE iPad 2019 32Gb Wi-Fi MW752RU/A, 2GB, 32GB, iOS серебристый', 'сенсорный экран 10.2" (25.9 см), разрешение: 2160 x 1620, Multitouch, Wi-Fi, Bluetooth, основная камера: 8Мп, фронтальная камера: 1.2Мп, fingerprint, встроенная память: 32Гб, операционная система: iOS', '6', '24990', '2', '1', '2'),
('Планшет Apple iPad (2019) 32Gb Wi-Fi silver', NULL, '10', '22899', '2', '1', '2'),
('Планшет Apple ipad wi-fi 32gb серебрянный 2019 (mw752ru/a)', 'Больше дисплей. Больше пространства для многозадачности. Дисплей Retina 10,2 дюйма Обложка превращается в полноразмерную клавиатуру. Клавиатура Smart Keyboard Запишите и зарисуйте любую идею. С точностью до пикселя. Apple Pencil Высокая производительность. Мгновенный отклик. Процессор A10 Fusion Звоните по FaceTime. Снимайте в HD. Играйте в AR. Встроенные камеры Возьмите творчество в дорогу. Быстрый Wi-Fi и LTE. Весь чуть больше 500 грамм. Целый день без подзарядки.', '9', '27990', '2', '1', '2'),
('Планшет Apple iPad 10.2 Wi-Fi 32Gb 2019 (10.2"/2160x1620/WIFI/iPad OS)', 'КАК компьютер. Но совсем другое дело Новый iPad - это возможности мощного компьютера в сочетании с простотой и универсальностью портативного устройства. Теперь он оснащен увеличенным дисплеем Retina 10,2 дюйма, поддерживает полноразмерную клавиатуру Smart Keyboard и потрясающие новые функции iPadOS. Столько удовольствия - только с iPad. Решает серьезные вопросы С iPad все рабочие задачи решаются элементарно. Вы можете редактировать текст, сидеть в интернете и одновременно звонить коллегам по FaceTime.', '8', '24990', '2', '1', '2'),
('Планшет Apple iPad 2019 10.2 32Gb Space Grey Wi-Fi MW742RU-A', 'Apple iPad 2019 10.2 32Gb Space Grey Wi-Fi MW742RU-A: A10 Fusion, 10.2" 2160x1620, iOS, 32 Гб, основная камера 8MP, фронтальная камера 1.2MP, Wi-Fi, Bluetooth, 483 г, серый, MW742RU/A', '7', '30466', '2', '1', '2'),
('Телевизор Xiaomi 43\'\' Mi TV 4S 43', 'Телевизор Xiaomi 43'' Mi TV 4S 43 – ваш проводник в мир современных домашних развлечений! Смотреть фильмы и шоу на большом экране в 42,5 дюйма (108 см) – одно наслаждение! Благодаря высокому разрешению 4K UHD изображение будет максимально четким, и вы рассмотрите все до мельчайшей детали. С Smart TV вы в любое время сможете посмотреть все, что пожелаете. Инновационная система PatchWall подберет контент для просмотра на основе ваших интересов.', '11', '20990', '3', '1', '3'),
('Телевизор Xiaomi Mi TV 4S, 43" T2 1/8Gb', 'Телевизор LED Xiaomi Mi TV 4S 43 с диагональю экрана 43" (108 см) поддерживает встроенные тюнеры, что позволяет не подключать внешнюю приставку, чтобы смотреть цифровые телеканалы.', '12', '23490', '3', '1', '3'),
('HDMI кабель Cablexpert CC-HDMI4-10M', 'Кабель HDMI Cablexpert CC-HDMI4-10M, 10м, v2,0, 19M/19M, черный, позол.разъемы, экран, пакет', '13', '640', '4', '1', '4'),
('Кабель HDMI Gembird/Cablexpert, 1м, v2,0, 19M/19M, черный, позол.разъемы, экран, пакет CC-HDMI4-1M', 'HDMI-кабель является важным связующим звеном между источником сигнала (ПК, ноутбуком, игровой консолью, ТВ-ресивером и так далее) и вашим телевизором, монитором или же проектором. Компания Gembird, будучи давно представленной на рынке, успела зарекомендовать себя с наилучшей стороны. Покупая продукцию данной фирмы, вы можете быть на 100 процентов уверены в высоком качестве исполнения. Во-первых, кабель изготовлен из прочных материалов, гарантирующих долгие годы службы.', '14', '317', '4', '1', NULL),
('Удлинитель кабеля HDMI Cablexpert CC-HDMI4X-10, 3.0м, v2.0, 19M/19F, черный, позол.разъемы, экран, пакет', NULL, '15', '259', '4', '1', NULL),
('HDMI кабель Cablexpert HDMI>HDMI 10м, v2.0 black', 'Стандартный кабель HDMI "папа-папа"; Длина 10 метров; HDMI версии 2.0', '16', '610', '4', '1', NULL),
('Кабель HDMI - HDMI Cablexpert CC-HDMI4F-1M 1.0m', 'Кабель HDMI Cablexpert, 1м, v2.0, 19M/19M, плоский кабель, черный, позол.разъ', '17', '119', '4', '1', NULL),
('Kabrita 1 gold смесь сухая на козьем молоке 800,0', 'Адаптированная смесь kabrita®1 gold на основе козьего молока 100% не содержит коровьего молока. В ее состав входят питательные вещества, необходимые ребенку для правильного физического и умственного развития и укрепления иммунитета. Козье молоко отличается высокой степенью усвояемости. Смеси kabrita® 1 gold на основе козьего молока обогащены ингредиентами, которые крайне важны для гармоничного развития и роста вашего малыша. Содержащиеся в составе смесей kabrita® 1 gold арахидновая', '18', '2125', '5', '1', '4'),
('Молочная смесь Kabrita Gold 1 0-6 месяцев, 800 г', 'Молочная смесь Karbita Gold 1 для новорожденных, 800 гр. подходит для здоровых детей и малышей с непереносимостью к белкам коровьего молока. Адаптированное сухое питание рекомендуется для детей с рождения до 6 месяцев и изготовлено на основе козьего молока. В состав детской смеси входят пребиотики и пробиотики, которые способствуют нормализации пищеварения ребенка и укреплению иммунитета. Сухая смесь содержит пальмовое масло и производится в Голландии.', '19', '2679', '5', '5', '4'),
('Молочная смесь KABRITA Gold (Кабрита Голд) 1 для комфортного пищеварения, с 0 до 6 мес., 800 г.', NULL, '20', '2250', '5', '5', '4'),
('Смесь Kabrita 1 GOLD (0-6 месяцев) 800 г', 'Молочная смесь Kabrita 1 Gold с рождения 800 гр.', '21', '1950', '5', '5', '4'),
('Заменитель на основе козьего молока 1 Gold 0-6 мес 800 г Kabrita', 'Заменитель на основе козьего молока 1 Gold 800 г 0-6 мес. марки Kabrita. Kabrita 1 Gold – прекрасная альтернатива грудному молоку в случае невозможности продолжать грудное вскармливание. Смесь изготовлена из высококачественного козьего молока, которое легко и быстро усваивается организмом малыша. В состав смеси включены современные функциональные ингредиенты: комплекс DigestX – копирует жировой профиль грудного молока, что обеспечивает лучшее пищеварение и снижает риск запоров, а также способствует усвоению', '22', '2435', '5', '5', '4');

INSERT INTO customer_reviews (rating, body, user_id, products_groups) VALUES
('2', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. ', '2', '3'),
('4', 'Все не плохо. В целом хорошо. Могло быть лучше', '1', '2'),
('5', 'Идеально просто. Качество телефона отменное', '4', '1'),
('3', 'Ну так. Средне', '1', '4'),
('4', 'Все не плохо. Ребенку понравилось', '6', '5'),
('4', 'Все не плохо. В целом хорошо. Могло быть лучше', '8', '2');

INSERT INTO articles (user_id, article_title, article_text, article_media) VALUES 
('2', 'So, this about new iphone', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.', '88'),
('1', 'Ohhh, I buy this bad thing', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.', '68');

INSERT INTO sales VALUES 
('2', '2', '-23'),
('22', '22', '-23'),
('6', '5', '-2'),
('7', '10', '-9');

INSERT INTO shopping_cart (user_id, product_id, product_price, shop_id, status) VALUES 
('1', '2', '14330', '2', 'purchase'),
('2', '7', '22899', '10', 'non_purchase'),
('3', '15', '259', '15', 'non_purchase'),
('4', '20', '2250', '20', 'purchase'),
('2', '2', '14330', '2', 'purchase'),
('1', '11', '20990', '2', 'purchase');

INSERT INTO favorites VALUES 
('2', '12'), 
('1', '3'), 
('1', '12'), 
('3', '4'), 
('5', '1'), 
('3', '2'), 
('1', '10'), 
('6', '9'), 
('5', '2'), 
('1', '7');

-- 6. Скрипты характерных выборок

-- список товаров одной группы
SELECT * FROM products WHERE products_groups_id=2;

-- список групп товаров одной категории
SELECT products_groups.name
FROM products_groups
LEFT JOIN products
ON products_groups.id = products.products_groups_id
WHERE categories_id=1
GROUP BY products_groups.name;

-- список пользователей купивших один и тот же товар
SELECT users.firstname, users.lastname 
FROM users 
JOIN shopping_cart 
ON users.id = shopping_cart.user_id
WHERE shopping_cart.product_id=2 AND shopping_cart.status='purchase';

-- количество покупок конкретного пользователя
SELECT count(*),
	users.firstname, users.lastname
FROM shopping_cart
JOIN users
ON shopping_cart.user_id = users.id
WHERE user_id = 3 AND status='purchase'
GROUP BY user_id;

-- список покупок конкретного пользователя
SELECT users.firstname, users.lastname, products.name, products.price
FROM shopping_cart
LEFT JOIN users
ON shopping_cart.user_id = users.id
LEFT JOIN products
ON shopping_cart.product_id = products.id
WHERE user_id = 2 AND status='purchase';

-- количество продаж каждой группы товаров
SELECT count(*),
	products_groups.name,
	products_groups.min_price,
	products_groups.categories_id
FROM shopping_cart
JOIN products_groups
ON shopping_cart.product_id=products_groups.id,
WHERE status='purchase'
GROUP BY product_id;

-- кол-во продаж товара каждого магазина
SELECT count(*),
shops.name
FROM shopping_cart
JOIN shops
ON shopping_cart.shop_id=shops.id
WHERE status='purchase'
GROUP BY shop_id;

-- 7. Представления

-- список имен пользователей
CREATE OR REPLACE VIEW list_users (Фамилия, Имя)
AS SELECT lastname, firstname FROM users;

-- список групп товаров одной категории
CREATE OR REPLACE VIEW list_products_cat AS
SELECT products_groups.name
FROM products_groups
LEFT JOIN products
ON products_groups.id = products.products_groups_id
WHERE categories_id=1
GROUP BY products_groups.name
WITH CHECK OPTION;

-- список покупок пользователей
CREATE OR REPLACE VIEW list_purchases AS
SELECT users.firstname, users.lastname, products.name, products.price
FROM shopping_cart
LEFT JOIN users
ON shopping_cart.user_id = users.id
LEFT JOIN products
ON shopping_cart.product_id = products.id
WHERE status='purchase';

-- 8. Хранимые процедуры и триггеры

-- Хранимая процедура на удаление записей из корзины у пользователей. Проверять время добавления в корзину и удалять из нее через 3 суток. Т.е. сравнивать с текущим.
DELIMITER //
CREATE PROCEDURE cart_expired()
BEGIN
	DELETE FROM shopping_cart WHERE status='non_purchase' AND TO_DAYS(NOW()) - TO_DAYS(created_at) >= 3;
END//
DELIMITER ;

-- вычисление минимальной цены среди товаров группы и запись в поле min_price таблицы products_groups;
DELIMITER //
CREATE PROCEDURE find_min_prices(INOUT set_products_groups_id BIGINT)
BEGIN
	DECLARE find_min_price INT UNSIGNED;
	SELECT price INTO find_min_price FROM products WHERE products_groups_id=set_products_groups_id ORDER BY price ASC LIMIT 1;
	UPDATE products_groups
		SET `min_price`=find_min_price
		WHERE id=set_products_groups_id;
END//
DELIMITER ;
-- SET @set_products_groups_id=1; -- назначение переменной для работы процедуры (подставляем нужный id из products_groups)
-- CALL find_min_prices(@set_products_groups_id) -- вызов процедуры


-- Шифруем пароль
DELIMITER //
CREATE TRIGGER hash_password BEFORE INSERT TO users
FOR EACH ROW
BEGIN
	SELECT users.password AS pswd;
	SELECT users.salt AS salt;
	SET NEW.password = MD5(CONCAT(pswd, salt);
END//
DELIMITER ;

-- триггеры на логирование (добавление товара, обновление цены товара)
DELIMITER //
CREATE TRIGGER logs_add_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (tablename, entry_id, name) VALUES ('products', NEW.id, NEW.name);
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER logs_price_product_update AFTER UPDATE ON products.price -- можно так или без .price?
FOR EACH ROW
BEGIN
	INSERT INTO logs (tablename, entry_id, name, price) VALUES ('products', OLD.id, OLD.name, NEW.price);
END//
DELIMITER ;



