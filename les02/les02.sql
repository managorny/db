/*
1. Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.

ФАЙЛ СОЗДАН. НАХОДИТСЯ В РЕПОЗИТОРИИю

*/


/*
2. Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/

DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
);

/* 

3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.

СКРИНШОТЫ ВЫПОЛНЕНИЯ BASH В РЕПОЗИТОРИИ.

*/

DROP DATABASE IF EXISTS sample;
CREATE DATABASE sample;

/*

-- Выполнять строки по очереди

#! /bin/bash

mysqldump example > dump_example.sql
mysql sample < dump_example.sql

*/


/*

4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.

mysqldump mysql help_keyword --where='help_keyword_id<100' > dump_help_keyword.sql

*/