-- 1. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
USE vk;

SELECT from_user_id, firstname, lastname,
count(*)
FROM messages
JOIN users ON users.id = messages.from_user_id
WHERE ((from_user_id in (
	SELECT initiator_user_id from friend_requests WHERE target_user_id = 1 and status = 'approved'
		UNION
	SELECT target_user_id from friend_requests 	WHERE initiator_user_id = 1 and status = 'approved'
)) and to_user_id = 1)
GROUP BY from_user_id
ORDER BY count(*) DESC
LIMIT 1;


-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..

select count(*)
FROM likes
WHERE media_id in (
	SELECT id FROM media WHERE user_id in (
		SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10)
)
GROUP BY media_id


-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT gender,
count(*)
FROM (
	SELECT user_id as `user`, 
		(SELECT gender FROM profiles WHERE (user_id = user)) as `gender`
	FROM likes
	) as `table`
GROUP BY gender
ORDER BY count(*) DESC;