
/**Q1. What is the most rented movie title?**/

/*SQL QUERY CODE FOR Q1 :*/

SELECT f.title , c.name, f.rental_rate, sum(f.rental_duration) as rental_count
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title, c.name, f.rental_rate, f.rental_duration
ORDER BY sum(f.rental_duration) desc, f.rental_rate desc
LIMIT 10





/*PLOT SCRIPT FOR Q1*/
/** The output of the SQL QUERY CODE FOR Q1 was stored in data_Q1.csv  **/
/***
import pandas as pd
data_read = pd.read_csv('../data/data_Q1.csv')

df= data_read.head(10)
df.plot(x ='title', y='rental_count', kind = 'bar')
***/





/**Q2. Which customer has the highest count for renting the most rented movie **/


/*SQL QUERY CODE FOR Q2: */

WITH most_rented
AS

(SELECT f.film_id,f.title , c.name, f.rental_rate, sum(f.rental_duration) as rental_count
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title, c.name, f.rental_rate, f.rental_duration,f.film_id
ORDER BY (rental_count) desc, f.rental_rate desc
LIMIT 1)

SELECT concat(c.first_name,' ', c.last_name) as customer_name, count(*) as counts
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON f.film_id = i.film_id
JOIN customer c ON c.customer_id = r.customer_id

WHERE i.film_id= (SELECT m.film_id FROM most_rented m)

GROUP BY c.first_name, c.last_name
ORDER BY counts desc
LIMIT 10




/**Q3. Total Amount made for renting the most rented movie **/

/* SQL QUERY CODE FOR Q3: */
WITH most_rented
AS

(SELECT f.film_id,f.title , c.name, f.rental_rate, sum(f.rental_duration) as rental_count
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title, c.name, f.rental_rate, f.rental_duration,f.film_id
ORDER BY (rental_count) desc, f.rental_rate desc
LIMIT 5)

SELECT m.title, sum(p.amount)
FROM rental r
JOIN payment p ON p.rental_id = r.rental_id
JOIN inventory i ON i.inventory_id =r.inventory_id
JOIN most_rented m ON m.film_id = i.film_id

GROUP BY m.title

/** PLOT SCRIPT Q3**/
/** The output of the SQL QUERY CODE FOR Q3 was stored in data_most_rented_movie_amt_made.csv  **/
/**
import pandas as pd
df = pd.read_csv('../data/data_most_rented_movie_amt_made.csv')

df.plot(x ='most_rented_movie', y='total_amount_made', kind = 'bar')

**/




/**Q4. What is the running payment total from the first payment date  **/


/* SQL QUERY CODE FOR Q4: */


SELECT p.payment_id,p.payment_date,concat(c.first_name, ' ' , c.last_name) as customer_name,p.amount,
       SUM(amount) OVER (ORDER BY payment_date) AS running_payment_total
FROM payment p
JOIN customer c ON c.customer_id = p.customer_id
ORDER BY  p.payment_date 

