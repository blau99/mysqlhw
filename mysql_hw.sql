USE sakila;

SELECT*FROM actor;

SELECT CONCAT(actor.first_name,' ', actor.last_name) AS 'Actor Name'
FROM actor;

SELECT actor_id,first_name,last_name FROM actor
WHERE first_name="JOE";

SELECT*FROM actor
WHERE last_name LIKE '%GEN%';

SELECT*FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor
ADD middle_name VARCHAR(50) AFTER first_name;

ALTER TABLE actor
MODIFY middle_name BLOB;

ALTER TABLE actor
DROP COLUMN middle_name;

SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*)>=2;

UPDATE actor
SET first_name = 'HARPO'
WHERE last_name = 'WILLIAMS' AND first_name = 'GROUCHO';

UPDATE actor
SET first_name = 'GROUCHO'
WHERE last_name = 'WILLIAMS' AND first_name = 'HARPO';

SHOW CREATE TABLE address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

SELECT first_name,last_name,address FROM staff
JOIN address ON address.address_id=staff.address_id;

SELECT*FROM payment;
SELECT*FROM staff;

SELECT first_name, last_name,SUM(amount) FROM staff
JOIN payment ON staff.staff_id=payment.staff_id
GROUP BY staff.staff_id;

SELECT title, COUNT(*) FROM film_actor
INNER JOIN film ON film_actor.film_id=film.film_id
GROUP BY title;


SELECT title, COUNT(*) FROM film
JOIN inventory ON film.film_id=inventory.film_id
WHERE title='HUNCHBACK IMPOSSIBLE'
GROUP BY title;

SELECT first_name, last_name, SUM(amount) FROM customer
JOIN payment ON customer.customer_id=payment.customer_id
GROUP BY last_name, first_name
ORDER BY last_name;

SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%' 
AND language_id=(SELECT language_id FROM language WHERE name='English');

SELECT first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor 
WHERE film_id=(SELECT film_id FROM film WHERE title ='ALONE TRIP'));

SELECT first_name, last_name, email FROM customer
JOIN address ON customer.address_id=address.address_id
JOIN city ON city.city_id=address.city_id
JOIN country ON city.country_id=country.country_id
WHERE country.country_id=(SELECT country_id FROM country WHERE country='Canada');

SELECT title FROM film
JOIN film_category ON film.film_id=film_category.film_id
JOIN category ON film_category.category_id=category.category_id 
WHERE category.category_id=(SELECT category_id FROM category WHERE name='Family');

SELECT title, COUNT(*) FROM film
JOIN inventory ON film.film_id=inventory.film_id
JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY title
ORDER BY COUNT(*) DESC;

SELECT store.store_id, SUM(amount) FROM payment
JOIN rental ON payment.rental_id=rental.rental_id
JOIN inventory ON inventory.inventory_id=rental.inventory_id
JOIN store ON store.store_id=inventory.store_id
GROUP BY store.store_id;

SELECT store_id, city, country FROM store
JOIN address ON store.address_id=address.address_id
JOIN city ON city.city_id=address.city_id
JOIN country ON country.country_id=city.country_id;

SELECT name, SUM(amount) FROM category
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON inventory.film_id=film_category.film_id
JOIN rental ON rental.inventory_id=inventory.inventory_id
JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC;

USE sakila;
CREATE VIEW top_five_genres AS SELECT name, SUM(amount) FROM category
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON inventory.film_id=film_category.film_id
JOIN rental ON rental.inventory_id=inventory.inventory_id
JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC;

SELECT*FROM top_five_genres;

DROP VIEW top_five_genres;