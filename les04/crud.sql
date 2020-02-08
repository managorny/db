-- i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0)
-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
-- v. Написать название темы курсового проекта (в комментарии)

USE vk;

-- i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)

INSERT INTO `users` VALUES 
('1','Julia','Daugherty','rae65@example.org','103485'),
('2','Antonina','King','ray80@example.com','1806864982'),
('3','Ivory','Collier','hailey59@example.net','449'),
('4','Cicero','Anderson','wraynor@example.net','1'),
('5','Yessenia','Swaniawski','lhowe@example.com','0'),
('6','Destiny','Gerhold','kariane.veum@example.net','0'),
('7','Lea','Mante','christiansen.ross@example.net','1'),
('8','Emmanuel','Dickens','oward@example.org','3947863505'),
('9','Ulices','Mitchell','olen.rodriguez@example.org','609958'),
('10','Orland','Kunze','joy.wolf@example.com','1');
('11','Orlando','Kunzes','joy.wolfy@example.com','123213');

INSERT INTO `media_types` VALUES
('1','sed','2017-05-20 22:59:46','2013-05-14 02:07:02'),
('2','delectus','1983-04-11 03:58:46','2005-02-01 12:58:05'),
('3','incidunt','2010-08-24 18:44:19','1987-06-24 22:13:30'),
('4','molestiae','2005-09-14 11:26:58','1990-10-10 15:55:00'),
('5','repellat','2018-01-15 13:53:50','1973-03-04 18:33:42'),
('6','sit','2011-01-29 03:21:11','1987-08-07 00:39:45'),
('7','perspiciatis','1994-08-05 14:26:17','1982-11-01 17:08:51'),
('8','cupiditate','1983-07-20 06:40:39','1981-10-12 02:44:42'),
('9','quia','1981-02-16 00:35:33','1993-06-22 03:58:22'),
('10','qui','1984-02-04 17:41:43','1972-04-02 10:19:50');

INSERT INTO `media` VALUES
('1','1','1','Similique in in vitae nihil. Officiis error ut fugiat sint optio delectus. Iure in et et sit officia. Rerum quia et veritatis at neque.','nihil','71131',NULL,'1978-09-03 20:29:38','1971-01-02 12:37:50'),
('2','2','2','Numquam aperiam vitae possimus culpa quisquam nisi et. Esse recusandae consequuntur qui sit et quod. Dolor voluptas quia rem placeat. Vel aut similique aut assumenda magni qui repudiandae dignissimos.','sapiente','7893857',NULL,'2006-05-07 21:44:20','2001-06-02 11:06:23'),
('3','3','3','Veritatis adipisci sapiente laudantium a pariatur perferendis nulla. Sit non est accusamus. Qui aperiam molestias iste nam distinctio in. Ea voluptatem consequatur atque eveniet inventore veritatis.','soluta','0',NULL,'1978-08-14 11:17:41','2000-06-07 14:32:03'),
('4','4','4','Et sed aut voluptas hic non at facere. Vero eum sapiente modi. Ut debitis eligendi omnis cupiditate id tempore. Inventore natus ab aut cupiditate fugiat.','commodi','140431185',NULL,'2008-04-10 23:53:43','1982-04-25 21:17:10'),
('5','5','5','Qui similique sint nisi rerum ut. Sunt non fugiat est sed modi magnam fuga saepe. Illo facere ad tempora libero et.','nihil','2331233',NULL,'1983-12-09 19:06:47','1988-10-05 20:36:38'),
('6','6','6','Ipsum consequuntur eius nostrum quis. Et ea ratione ut quia error.','nemo','0',NULL,'2010-04-12 16:47:03','2020-01-22 00:20:01'),
('7','7','7','Labore a reiciendis aut accusantium et aliquam. Qui quia dolorum placeat ea ut laboriosam sit. At labore laborum architecto.','quae','8548115',NULL,'2003-09-23 19:27:48','1992-10-14 17:56:37'),
('8','8','8','Tenetur veritatis ut culpa assumenda enim. Omnis non labore aut quidem omnis. Nam voluptatem ab mollitia ut et. Facere iusto id error rerum quia.','velit','12152749',NULL,'2019-07-09 10:13:10','1975-06-16 12:11:18'),
('9','9','9','Tempora repellat suscipit qui voluptatem repellendus necessitatibus quos deserunt. Cumque aut in vel et ut perspiciatis similique. Praesentium et eius quod est distinctio perspiciatis. Ea et labore rerum velit.','autem','3',NULL,'1983-12-26 03:36:21','1995-12-20 17:05:12'),
('10','10','10','Ipsam vel repellat aliquid et. Vero sunt ut quis consequatur et optio hic. Aut et molestiae earum omnis error. Officia debitis magnam optio recusandae voluptatem.','enim','20',NULL,'2012-11-30 10:41:39','2019-10-12 10:45:11'); 

INSERT INTO `photo_albums` VALUES
('1','aliquam','1'),
('2','aut','2'),
('3','perferendis','3'),
('4','saepe','4'),
('5','in','5'),
('6','ab','6'),
('7','repellendus','7'),
('8','soluta','8'),
('9','similique','9'),
('10','laborum','10');

INSERT INTO `photos` VALUES
('1','1','1'),
('2','2','2'),
('3','3','3'),
('4','4','4'),
('5','5','5'),
('6','6','6'),
('7','7','7'),
('8','8','8'),
('9','9','9'),
('10','10','10');

INSERT INTO `profiles` VALUES ('1',NULL,'1987-02-06','1','1974-02-18 09:51:59',NULL),
('2','m','1996-08-02','2','1989-11-03 08:49:22','NYC'),
('3','f','1976-12-11','3','1993-09-14 15:47:04','LA'),
('4','m','2015-02-23','4','1971-11-09 23:27:52','Moscow'),
('5','m','2002-06-10','5','2005-08-26 21:44:33','Riga'),
('6','f','1981-04-06','6','2003-09-26 00:57:17','Berlin'),
('7','m','1987-10-18','7','2012-07-03 20:47:58','Praha'),
('8','f','2003-08-19','8','2018-05-19 00:23:23','Brno'),
('9','m','1986-10-15','9','1993-08-31 16:08:02','leipzig'),
('10','f','2007-05-27','10','2011-12-09 00:32:00','Vladivostok'); 

INSERT INTO `messages` VALUES 
('1','1','1','Quo itaque recusandae ut aut pariatur. Aut numquam non repellendus doloribus ea ipsa. Est est autem quae quis accusamus.','1977-12-03 20:10:30'),
('2','2','2','Et excepturi modi assumenda molestiae. Nobis reiciendis rerum aliquam ea. Aperiam nihil nulla molestiae saepe non.','1989-09-25 23:36:40'),
('3','3','3','Atque velit eaque atque aut optio voluptatibus non. Quia id occaecati harum totam nihil eaque. Iure non rerum aut qui dolor. Ullam voluptatibus corrupti quo ea quod quia.','1992-02-20 00:45:44'),
('4','4','4','Natus est eligendi accusamus vero enim. Nihil dicta vel et eaque aut id totam. Perspiciatis et labore placeat qui molestiae doloremque laboriosam.','1984-09-29 16:15:54'),
('5','5','5','Fuga aut excepturi dolorem exercitationem sint ducimus. Est ullam rem quae sequi vel omnis. Illum voluptate est est temporibus reiciendis et eaque.','1979-02-21 04:15:20'),
('6','6','6','Aut alias in totam qui quod. Maiores et corrupti earum officia amet culpa ab. Suscipit sit fuga eum consequatur.','2002-03-20 07:09:34'),
('7','7','7','Eos distinctio maxime voluptate modi vero ut maiores. Excepturi vero at voluptatem quos. Odio ducimus quasi qui. Deleniti et nobis debitis omnis placeat fugit sunt voluptas.','1977-10-04 21:51:03'),
('8','8','8','Qui eos expedita inventore earum accusantium ab. Repellat est perferendis cum mollitia est. Possimus laboriosam labore possimus vel vel sint. Assumenda numquam quisquam voluptatem fugiat expedita. Odit quo nihil ipsum consequatur quisquam nam.','2003-02-28 16:02:57'),
('9','9','9','Culpa maxime praesentium facilis id et aut sed assumenda. Est veniam aut exercitationem aliquam et. Qui odit est hic quia deserunt provident dolorem pariatur. Id doloribus accusantium assumenda deleniti consequatur similique qui.','2011-11-12 17:04:59'),
('10','10','10','Reiciendis eos nostrum illum sed rem. Sed qui minus voluptatibus quo corporis. Exercitationem sint omnis unde iste qui sit harum. Debitis sapiente consequatur omnis quaerat.','1974-05-07 12:40:46');

INSERT INTO `friend_requests` VALUES
('1','2','requested','1982-10-12 16:38:14','1994-02-05 20:39:05'),
('2','3','approved','1987-01-22 21:52:41','1991-03-30 14:58:26'),
('3','4','requested','1994-03-07 22:38:15','2010-12-03 05:51:45'),
('4','5','requested','1976-12-10 07:24:23','2014-11-03 22:27:09'),
('5','6','requested','2010-01-14 04:29:56','1990-02-18 05:26:18'),
('6','7','requested','1998-10-10 15:39:09','1990-08-17 19:43:38'),
('7','8','requested','1977-07-16 18:08:01','2012-10-11 12:34:14'),
('8','9','requested','1997-06-25 16:43:00','1973-03-01 09:49:23'),
('9','10','requested','1987-07-18 18:37:49','1973-06-23 08:44:56'),
('10','11','requested','1990-11-15 10:25:32','1998-03-01 12:23:14'); 

INSERT INTO `communities` VALUES
('4','dolorem'),
('5','ducimus'),
('1','ea'),
('6','illo'),
('10','non'),
('2','officia'),
('7','omnis'),
('9','possimus'),
('3','veritatis'),
('8','veritatis'); 

INSERT INTO `users_communities` VALUES
('1','1'),
('2','3'),
('3','3'),
('4','2'),
('5','6'),
('6','1'),
('7','2'),
('8','9'),
('9','3'),
('10','10');

INSERT INTO `likes` VALUES
('1','1','1','1988-02-26 01:30:38'),
('2','2','2','2002-08-27 19:52:50'),
('3','3','3','1980-03-19 11:37:06'),
('4','4','4','1972-05-26 11:37:51'),
('5','5','5','1974-08-18 19:06:56'),
('6','6','6','1991-08-03 04:10:07'),
('7','7','7','1988-12-27 05:59:14'),
('8','8','8','2007-06-23 12:39:39'),
('9','9','9','1998-07-02 12:08:00'),
('10','10','10','2002-11-17 14:36:52');

-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

SELECT DISTINCT `firstname`
FROM `users`
ORDER BY `firstname` ASC;

-- iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0)
ALTER TABLE `profiles`
ADD `is_active` enum('true','false') DEFAULT 'false';

UPDATE `profiles` 
	SET `is_active` = 'true'
	WHERE YEAR(NOW()) - YEAR(`birthday`) >= 18;

-- iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
DELETE FROM `messages`
WHERE `created_at` > now()

-- v. Написать название темы курсового проекта (в комментарии)
-- Сайт-агрегатор электроники (товары с разных магазинов)

