-- Написать скрипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
-- Пройдите опрос по ссылке: https://forms.gle/ZPt3xp4KpCX9p7n1A
-- https://docs.google.com/forms/u/0/d/e/1FAIpQLSc7dq1pDJNiy-YMyBfgJoDLtfhAE7MXYthzDBcvqJazZtzZAw/formResponse

USE vk;

DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL PRIMARY KEY,
	`media_id` BIGINT unsigned NOT NULL,
	`name_video` VARCHAR(255),
	`author_video` VARCHAR(255),
	`views` BIGINT UNSIGNED,
	`date_add` DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (media_id) REFERENCES media(id),
	INDEX (id, name_video),
);

DROP TABLE IF EXISTS music;
CREATE TABLE music (
	id SERIAL PRIMARY KEY,
	`media_id` BIGINT unsigned NOT NULL,
	`title_song` VARCHAR(255),
	`singer` VARCHAR(255),
	`album_song` VARCHAR(255),

	FOREIGN KEY (media_id) REFERENCES media(id)
	INDEX (id, title_song, singer),

);

DROP TABLE IF EXISTS favorite_media;
CREATE TABLE favorite_media (
	`user_id` SERIAL,
	`media_id` BIGINT unsigned NOT NULL,

	PRIMARY KEY (id, media_id), -- чтобы не было 2 записей о пользователе и любимой media
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);