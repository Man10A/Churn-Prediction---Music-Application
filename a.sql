### LIMITS

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;


### WHERE Clause fot Non Numeric data
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil'


SELECT standard_amt_usd/standard_qty AS standard_amt_usd_byunit, id, account_id
FROM orders
LIMIT 10

SELECT (poster_amt_usd/poster_qty)*100 AS Poster_revenue_byorder,id, account_id
FROM orders
LIMIT 2

################ AND and BETWEEN ###########################

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0


SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s'


SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty



SELECT *
FROM web_events
WHERE occurred_at BETWEEN '2016-01-01' AND '2016-12-31' AND channel LIKE 'organic' OR channel LIKE 'adwords'
ORDER BY occurred_at


###################### OR ###########################
SELECT id
FROM orders
WHERE (gloss_qty > 4000 OR poster_qty > 4000)

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000)


SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%'

SELECT *
 FROM orders
 JOIN accounts
 ON orders.account_id = accounts.id


 SELECT orders.standard_qty,gloss_qty,poster_qty,
		accounts.website, primary_poc
 FROM orders
 JOIN accounts
 ON orders.account_id = accounts.id


######################## JOIN #########################################################

SELECT a.name, primary_poc, w.occurred_at, channel
FROM accounts as a
JOIN web_events as w
	ON a.id = w.account_id
WHERE name LIKE 'Walmart'


SELECT a.name AS acc_name, s.name AS sr_name, r.name AS loc_name
FROM sales_reps as s
JOIN accounts as a
	ON s.id = a.sales_rep_id
JOIN region as r
	ON r.id = s.region_id
ORDER BY acc_name


SELECT a.name AS acc_name, r.name AS loc_name, o.total_amt_usd/(total + 0.01) AS unit_price
FROM orders AS o
JOIN accounts AS a
	ON a.id = o.account_id
JOIN sales_reps AS s
	ON s.id = a.sales_rep_id
JOIN region AS r
	ON r.id = s.region_id


####################### JOINS and Filters ############################################

  SELECT region.name AS reg_name, sales_reps.name AS sr_name, accounts.name AS account_name
  FROM sales_reps
  JOIN accounts
  	ON sales_reps.id = accounts.sales_rep_id
  JOIN region
  	ON region.id = sales_reps.region_id
  WHERE region.name = 'Midwest'
  ORDER BY account_name


  SELECT region.name AS reg_name, sales_reps.name AS sr_name, accounts.name AS account_name
FROM sales_reps
JOIN accounts
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
WHERE region.name = 'Midwest'AND sales_reps.name LIKE 'S%'
ORDER BY account_name

SELECT region.name AS reg_name, sales_reps.name AS sr_name, accounts.name AS account_name
FROM sales_reps
JOIN accounts
	ON sales_reps.id = accounts.sales_rep_id
JOIN region
	ON region.id = sales_reps.region_id
WHERE region.name = 'Midwest'AND sales_reps.name LIKE '% K%'
ORDER BY account_name

SELECT region.name AS reg, accounts.name AS account_name, orders.total_amt_usd/(total+0.01) AS unit_price
FROM region
JOIN sales_reps
	ON region.id = sales_reps.region_id
JOIn accounts
	ON sales_reps.id = accounts.sales_rep_id
JOIN orders
	ON accounts.id = orders.account_id
    AND standard_qty > 100


    SELECT region.name AS reg, accounts.name AS account_name, orders.total_amt_usd/(total+0.01) AS unit_price
    FROM region
    JOIN sales_reps
    	ON region.id = sales_reps.region_id
    JOIn accounts
    	ON sales_reps.id = accounts.sales_rep_id
    JOIN orders
    	ON accounts.id = orders.account_id
        WHERE (standard_qty > 100 AND poster_qty >50)
    ORDER BY unit_price

    SELECT region.name AS reg, accounts.name AS account_name, orders.total_amt_usd/(total+0.01) AS unit_price
    FROM region
    JOIN sales_reps
    	ON region.id = sales_reps.region_id
    JOIn accounts
    	ON sales_reps.id = accounts.sales_rep_id
    JOIN orders
    	ON accounts.id = orders.account_id
        WHERE (standard_qty > 100 AND poster_qty >50)
    ORDER BY unit_price DESC


SELECT DISTINCT a.name AS account_name, w.channel
FROM web_events AS w
JOIN accounts AS a
	ON a.id = w.account_id
WHERE account_id = 1001


SELECT a.name , o.total, total_amt_usd, w.occurred_at
FROM accounts AS a
JOIN orders AS o
	ON a.id = o.account_id
JOIN web_events AS w
	ON a.id = w.account_id


  SELECT a.name , o.total, total_amt_usd, w.occurred_at
  FROM accounts AS a
  JOIN orders AS o
  	ON a.id = o.account_id
  JOIN web_events AS w
  	ON a.id = w.account_id
      WHERE occurred_at >= '2015-01-01' AND occurred_at <= '2016-01-01'

  ######################### SUM agregattor ##################################

SELECT SUM(poster_amt_usd) AS poster_sales_amt
FROM orders

SELECT SUM(poster_qty) AS poster_orders
FROM orders

SELECT SUM(standard_qty) AS standard_orders
FROM orders

SELECT SUM(standard_amt_usd) AS total_standard_amt, 		SUM(gloss_amt_usd) AS total_gloss_amt
FROM orders

#wrong
SELECT SUM(standard_amt_usd/(standard_qty+0.01)) AS unit_standard_amt
FROM orders

#right
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS unit_standard_amt
FROM orders


###################### MIN, MAX, AVG agregattor ####################3
SELECT MIN(occurred_at) AS earliest_order_date
FROM orders

2013-12-04T04:22:44.000Z

SELECT occurred_at AS earliest_order_date
FROM orders
ORDER BY occurred_at
LIMIT 1

2013-12-04T04:22:44.000Z

SELECT MIN(web_events.occurred_at) AS latest_webevent_data
FROM web_events

SELECT web_events.*
FROM web_events
ORDER BY occurred_at
LIMIT 1

SELECT AVG(standard_qty) AS standard_qty_avg,
		AVG(gloss_qty) AS gloss_qty_avg,
        AVG(poster_qty) AS poster_qty_avg,
        AVG(standard_amt_usd) AS standard_amt_usd_avg,
        AVG(gloss_amt_usd) AS gloss_amt_usd_avg,
        AVG(poster_amt_usd) AS poster_amt_usd_avg
FROM orders



###################################### GROUP BY ######################################
SELECT o.occurred_at AS earliest_order, a.name AS account_name
FROM accounts AS a
JOIN orders AS o
	ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1


SELECT a.name AS company_name,
		SUM(o.total) AS total_sales
FROM accounts AS a
JOIN orders AS o
	ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name

SELECT w.channel,occurred_at, a.name AS account_name
FROM web_events as w
JOIN accounts as a
	ON w.account_id = a.id
ORDER BY occurred_at DESC
LIMIT 1

SELECT w.channel, COUNT(channel) AS channel_Usage_count
FROM web_events as w
GROUP BY w.channel

SELECT a.primary_poc
FROM web_events as w
JOIN accounts as a
	ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1


SELECT a.name, MIN(o.total_amt_usd) AS smallest_orders
FROM orders as o
JOIN accounts as a
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY smallest_orders

SELECT r.name AS region_name , COUNT(s.name) AS sales_person_count
FROM sales_reps as s
JOIN region as r
	ON s.region_id = r.id
GROUP BY r.name
ORDER BY sales_person_count


SELECT a.name,
		AVG(o.standard_qty) AS avg_standard,
        AVG(o.gloss_qty) AS avg_gloss,
        AVG(o.poster_qty) AS avg_poster
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY a.name

SELECT a.name,
		AVG(o.standard_amt_usd) AS avg_amt_standard,
        AVG(o.gloss_amt_usd) AS avg_amt_gloss,
        AVG(o.poster_amt_usd) AS avg_amt_poster
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY a.name

SELECT s.name AS sales_rep_name, w.channel, COUNT(w.channel) AS channel_usage_count
FROM accounts as a
JOIN web_events as w
	ON a.id = w.account_id
JOIN sales_reps as s
	ON a.sales_rep_id = s.id
GROUP BY w.channel, s.name
ORDER BY channel_usage_count DESC

SELECT r.name AS region_name, w.channel, COUNT(w.channel) AS channel_usage_count
FROM accounts as a
JOIN web_events as w
	ON a.id = w.account_id
JOIN sales_reps as s
	ON a.sales_rep_id = s.id
JOIN region as r
	ON r.id = s.region_id
GROUP BY w.channel, r.name
ORDER BY channel_usage_count DESC

SELECT DISTINCT a.id AS acc_Id,  r.id as reg_id, a.name AS acc_name ,r.name AS reg_name
FROM accounts AS a
JOIN sales_reps AS s
	ON a.sales_rep_id = s.id
JOIN region AS r
	ON s.region_id = r.id
ORDER BY acc_id


SELECT DISTINCT s.name AS sales_rep_name, a.id AS account_id
FROM accounts as a
JOIN sales_reps as s
	ON a.sales_rep_id = s.id
ORDER BY sales_rep_name


#################### HAVING ##################################

SELECT s.name as sales_person, COUNT(a.id) as num_accounts
FROM sales_reps AS s
JOIN accounts as a
	ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY num_accounts


SELECT a.id as acc_id, COUNT(o.id) as num_orders
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id
HAVING COUNT(o.id) > 20
ORDER BY acc_id

SELECT a.id as acc_id, a.name AS account_name, COUNT(o.id) as num_orders
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id, a.name
HAVING COUNT(o.id) > 20
ORDER BY num_orders DESC
LIMIT 1

SELECT a.id as acc_id, a.name AS account_name, SUM(o.total_amt_usd) as total_acc_sales
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_acc_sales

SELECT a.id as acc_id, a.name AS account_name, SUM(o.total_amt_usd) as total_acc_sales
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_acc_sales

SELECT a.id as acc_id, a.name AS account_name, SUM(o.total_amt_usd) as total_acc_spendings
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id, a.name
ORDER BY total_acc_spendings DESC
LIMIT 1

SELECT a.id as acc_id, a.name AS account_name, SUM(o.total_amt_usd) as total_acc_spendings
FROM accounts as a
JOIN orders as o
	ON a.id = o.account_id
GROUP BY acc_id, a.name
ORDER BY total_acc_spendings
LIMIT 1


SELECT a.id AS acc_id, a.name AS account_name, w.channel AS channel_name, COUNT(w.channel) AS channel_count
FROM accounts as a
JOIN web_events as w
	ON a.id = w. account_id
GROUP BY acc_id, account_name, channel_name
HAVING w.channel LIKE 'facebook' AND COUNT(w.channel) > 6
ORDER BY channel_count

SELECT a.id AS acc_id, a.name AS account_name, w.channel AS channel_name, COUNT(w.channel) AS channel_count
FROM accounts as a
JOIN web_events as w
	ON a.id = w. account_id
GROUP BY acc_id, account_name, channel_name
HAVING w.channel LIKE 'facebook' AND COUNT(w.channel) > 6
ORDER BY channel_count DESC
LIMIT 1

SELECT w.channel, COUNT(w.channel) AS channel_usage_count
FROM accounts as a
JOIN web_events as w
	ON a.id = w. account_id
GROUP BY w.channel
ORDER BY channel_usage_count DESC
LIMIT 1


###################### DATE FUNCTIONS ####################################

SELECT DATE_TRUNC('year', o.occurred_at) AS year,
		SUM(o.total_amt_usd) AS sales_by_year
FROM orders as o
GROUP BY DATE_TRUNC('year', o.occurred_at)
ORDER BY DATE_TRUNC('year', o.occurred_at)

SELECT DATE_PART('year', o.occurred_at) AS year,
		SUM(o.total_amt_usd) AS sales_by_year
FROM orders as o
GROUP BY 1
ORDER BY 1

SELECT DATE_TRUNC('month', o.occurred_at) AS month,
		SUM(o.total_amt_usd) AS sales_by_month
FROM orders as o
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_PART('year', o.occurred_at) AS year,
		COUNT(o.total) AS sales_by_year
FROM orders as o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_PART('month', o.occurred_at) AS year,
		COUNT(o.total) AS sales_by_month
FROM orders as o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_TRUNC('month', o.occurred_at) AS monthlt_wise, a.name AS account_name,
		SUM(o.gloss_amt_usd) AS gloss_sales_by_month
FROM orders as o
JOIN accounts as a
	ON a.id = o.account_id
GROUP BY 1, 2
HAVING a.name = 'Walmart'
ORDER BY 3 DESC
LIMIT 1


############################################ CASE STATEMENT ############################################

SELECT id, account_id, total_amt_usd, CASE WHEN total_amt_usd >= 3000 THEN 'Large' ELSE 'Small' END AS order_level
FROM orders

SELECT
		CASE WHEN total > 2000 THEN  'At Least 2000'
         	WHEN total >1000 AND total <= 2000 THEN 'Between 1000 and 2000'
            ELSE 'Less than 1000' END AS total_orders_category, COUNT(*) AS orders_count
FROM orders
GROUP BY 1


SELECT a.name AS account_name, SUM(total_amt_usd) as total_sales_all_orders,
		CASE WHEN total_amt_usd > 200000 THEN  'top'
         	WHEN total_amt_usd > 100000 AND total_amt_usd <= 200000 THEN 'middle'
            ELSE 'low' END AS level
FROM orders as o
JOIN accounts as a
	ON a.id = o.account_id
GROUP BY 1,3
ORDER BY 2 DESC

SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC;

SELECT a.name AS account_name, SUM(total_amt_usd) as total_sales_all_orders,
		CASE WHEN SUM(total_amt_usd) > 200000 THEN  'top'
         	WHEN SUM(total_amt_usd) > 100000 AND SUM(total_amt_usd) <= 200000 THEN 'middle'
            ELSE 'low' END AS level
FROM orders as o
JOIN accounts as a
	ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_PART('year',o.occurred_at) AS year, a.name AS account_name, SUM(total_amt_usd) as total_sales_all_orders,
		CASE WHEN SUM(total_amt_usd) > 200000 THEN  'top'
         	WHEN SUM(total_amt_usd) > 100000 AND SUM(total_amt_usd) <= 200000 THEN 'middle'
            ELSE 'low' END AS level
FROM orders as o
JOIN accounts as a
	ON a.id = o.account_id
WHERE DATE_PART('year',o.occurred_at) = '2016' OR DATE_PART('year',o.occurred_at) = '2017'
GROUP BY 1,2
ORDER BY 3 DESC

SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;


SELECT s.name AS sales_person,
		COUNT(*) AS orders_count,
        CASE WHEN COUNT(*) >200 THEN 'top'
        ELSE 'low' END AS level
 FROM sales_reps as s
 JOIN accounts as a
 	ON s.id = a.sales_rep_id
 JOIN orders as o
 	ON o.account_id = a.id
 GROUP BY 1
 ORDER BY 2 DESC

 SELECT s.name AS sales_person,
		COUNT(*) AS orders_count, SUM(total_amt_usd) AS total_sales,
        CASE WHEN COUNT(*) >200 OR SUM(total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' END AS level
 FROM sales_reps as s
 JOIN accounts as a
 	ON s.id = a.sales_rep_id
 JOIN orders as o
 	ON o.account_id = a.id
 GROUP BY 1
 ORDER BY 3 DESC


#################################### SUB QUERIES ###############################################33

 SELECT AVG(standard_qty) AS avg_stand_qty,
		AVG(poster_qty) AS avg_poster_qty,
        AVG(gloss_qty) AS avg_glossy_qty,
        SUM(total_amt_usd) as total_amt_spent
FROM (SELECT *
      FROM orders
      WHERE DATE_TRUNC('month', occurred_at) =
      (SELECT DATE_TRUNC('month', MIN(occurred_at))
      FROM orders)) sub


############ RIGHT answer###############################################################3
SELECT AVG(standard_qty) AS avg_stand_qty,
       AVG(poster_qty) AS avg_poster_qty,
       AVG(gloss_qty) AS avg_glossy_qty,
       SUM(total_amt_usd) as total_amt_spent
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
     (SELECT DATE_TRUNC('month', MIN(occurred_at))
     FROM orders)




SELECT s.name AS sales_person,
		r.name AS reg_name,
       SUM(o.total_amt_usd) AS largest_sale
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC


SELECT sales_person, reg_name, MAX(largest_sale) as max_sales_by_person
FROM (SELECT s.name AS sales_person,
              r.name AS reg_name,
              SUM(o.total_amt_usd) AS largest_sale
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2) sub
GROUP BY 1,2
ORDER BY 3 DESC


SELECT reg_name, MAX(largest_sale) as max_sales
FROM (SELECT s.name AS sales_person,
              r.name AS reg_name,
              SUM(o.total_amt_usd) AS largest_sale
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2) t1
GROUP BY 1



SELECT t1.sales_person, t3.reg_name, t3.max_amt AS largest_sale
FROM (
  SELECT s.name AS sales_person,
  		r.name AS reg_name,
         SUM(o.total_amt_usd) AS total_amt
  FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1,2
  ORDER BY 3 DESC) t1
JOIN (
  SELECT reg_name, MAX(total_amt) AS max_amt
  FROM(SELECT s.name AS sales_person,
              r.name AS reg_name,
             SUM(o.total_amt_usd) AS total_amt
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 3 DESC) t2
  GROUP BY 1
  ORDER BY 2 DESC)t3
ON t1.reg_name = t3.reg_name AND t1.total_amt = t3.max_amt


\\\\\\\\\\\\\\\\\\\\\ 2.\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


SELECT r.name, COUNT(0.total) total_orders
    FROM region r
    JOIN sales_reps s
    ON r.id = s.region_id
    JOIN accounts a
    ON s.id = a.sales_rep_id
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1
HAVING SUM(o.total_amt_usd) =
(SELECT MAX(total_amt) AS max_amt
FROM (SELECT r.name AS reg_name,
           SUM(o.total_amt_usd) AS total_amt
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1) )sub )


|||||||||||||||||||||||||||||||||||||3||||||||||||||||||||||||||||||||

SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

???????????????????????????????4??????????????????????????????????????

SELECT t1.customer, t2.channel, t2.event_count
FROM(
  SELECT a.name as customer , SUM(o.total_amt_usd) as total_spend
  FROM accounts as a
  JOIN orders as o
  ON a.id = o.account_id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1 ) t1
JOIN(
  SELECT a.name AS customer, w.channel, COUNT(*) AS event_count
  FROM accounts as a
  JOIN web_events as w
  ON a.id = w.account_id
  GROUP BY 1,2) t2
ON  t1.customer = t2.customer
ORDER BY event_count DESC

___________________----- 5 ________________________________

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o


  SELECT AVG(total_amt_spent)
  FROM (
    SELECT a.name AS account_name, SUM(o.total_amt_usd) AS total_amt_spent
    FROM accounts as a
    JOIN orders as o
    ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10 ) t2

########################6$################################

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o  ######## result

SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
FROm orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
FROM orders o) temp;



WITH  t1 AS (
                        SELECT s.name AS sales_person,
                        r.name AS reg_name,
                        SUM(o.total_amt_usd) AS total_sum
                        FROM region as r
                        JOIN sales_reps as s
                        ON r.id = s.region_id
                        JOIN accounts as a
                        ON s.id = a.sales_rep_id
                        JOIN orders as o
                        ON a.id = o.account_id
                        GROUP BY 1,2),
    t2 AS (
                        SELECT reg_name, MAX(total_sum) AS largest_sum
                        FROM t1
                        GROUP BY 1)

SELECT t1.sales_person, t1.reg_name, t2.largest_sum
FROM t1
JOIN t2
ON t1.reg_name = t2.reg_name AND t1.total_sum = t2.largest_sum


WITH t1 AS (
    SELECT r.name AS region_name, SUM(o.total_amt_usd) AS total_sales_sum
    FROM region AS r
    JOIN sales_reps AS s
    ON r.id = s.region_id
    JOIN accounts AS a
    ON s.id = a.sales_rep_id
    JOIN orders AS o
    ON a.id = o.account_id
    GROUP BY 1
  	ORDER BY 2 DESC
  	LIMIT 1
    ),

    t2 AS (
      SELECT region_name
      FROM t1
    )

  SELECT r.name, COUNT(o.total) AS total_orders
  FROM region AS r
  JOIN sales_reps AS s
  ON r.id = s.region_id
  JOIN accounts AS a
  ON s.id = a.sales_rep_id
  JOIN orders AS o
  ON a.id = o.account_id
  GROUP BY 1
  HAVING r.name = (SELECT * FROM t2)

  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$4


  WITH t1 AS (SELECT a.name AS Company, SUM(o.standard_qty) AS total_std_qty, SUM(o.total) AS total
              FROM accounts AS a
              JOIN orders AS o
              ON a.id = o.account_id
              GROUP BY 1
              ORDER BY 2 DESC
              LIMIT 1
            ),
      t2 AS (
        SELECT a.name
        FROM accounts AS a
        JOIN orders AS o
        ON a.id = o.account_id
        GROUP BY 1
        HAVING SUM(o.total) > (SELECT total_std_qty FROM t1)
      )
SELECT COUNT(*)
FROM t2


3######$$$$$$$$$$$$$$$$$$$$$$$$$$$^&%U&*IO(P){_%$%^&*()_+)(*&^%$#@#$%^&*()_)}


WITH t1 AS (SELECT a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
            FROM accounts As a
            JOIN web_events AS w
            ON a.id = w.account_id
            JOIN orders AS o
            ON a.id = o.account_id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1),
     t2 AS (SELECT w.channel AS channel, a.name AS customer, COUNT(w.channel) as count_channel
             FROM accounts As a
             JOIN web_events AS w
             ON a.id = w.account_id
             JOIN orders AS o
             ON a.id = o.account_id
             GROUP BY 1,2
             ORDER BY 2)
SELECT channel, customer, count_channel
FROM t2
HAVING customer = (SELECT account_name FROM t1)



WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM web_events as w
JOIN accounts a
ON a.id = w.account_id AND a.id = (SELECT id FROM t1)
GROUP BY 1,2
ORDER BY 3 DESC


WITH t1 AS (SELECT o.account_id, a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 10)

SELECT o.id, a.name AS account_name, AVG(o.total_amt_usd)
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1,2
HAVING a.name = (SELECT account_name FROM t1)

####################################
SQL Data Cleaning
###########################################

WITH t1 AS (SELECT website, RIGHT(website, 4) AS extensions
FROM accounts)
SELECT extensions, COUNT(*)
FROM t1
GROUP BY 1

SELECT RIGHT(website, 4) AS extensions, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC


SELECT LEFT(name,1) AS first_letter, COUNT(*) AS letter_count
FROM accounts
GROUP BY 1
ORDER BY 1

SELECT name_starts_with, COUNT(*) AS _count
FROM
(SELECT name,
		CASE WHEN LEFT(name,1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 'number' ELSE 'letter' END AS name_starts_with
FROM accounts
ORDER BY 1) sub
GROUP BY 1

SELECT name_starts_with, COUNT(*) AS _count
FROM
(SELECT name,
		CASE WHEN LEFT(LOWER(name),1) IN ('a','e','i','o','u') THEN 'Vowel' ELSE 'Not vowel' END AS name_starts_with
FROM accounts
ORDER BY 1) sub
GROUP BY 1


SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1) AS FIRST_NAME,
		RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS LAST_name
FROM accounts

SELECT LEFT(name, POSITION(' ' IN name)-1) AS first_name,
       RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM sales_reps


SELECT LEFT(name, STRPOS(name,' ')-1) AS first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name , ' ')) AS last_name
FROM sales_reps



)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

SELECT name, primary_poc, CONCAT(first_name, '.',last_name,'@',REPLACE(c_name,'.', ''),'.com')
FROM (SELECT name, primary_poc, LEFT(primary_poc,STRPOS(LOWER(primary_poc), ' ')-1) AS first_name, RIGHT(primary_poc, LENGTH(primary_poc) -STRPOS(LOWER(primary_poc), ' ')) AS last_name, REPLACE(name,' ', '') AS c_name
From Accounts) AS sub


SELECT name, primary_poc, LOWER(LEFT(first_name,1))||LOWER(RIGHT(first_name,1)) ||LOWER(LEFT(last_name,1))||LOWER(RIGHT(last_name,1))||LENGTH(first_name)||LENGTH(last_name)||c_name AS password
FROM (SELECT name, primary_poc, LEFT(primary_poc,STRPOS(primary_poc, ' ')-1) AS first_name, RIGHT(primary_poc, LENGTH(primary_poc) -STRPOS(primary_poc, ' ')) AS last_name, REPLACE(UPPER(name), ' ','') AS c_name
FROM accounts) t1


SELECT org_date, new_date::DATE AS cast_date
FROM(SELECT date AS org_date, SUBSTR(date,7,4)||'-'||LEFT(date,2)||'-'||SUBSTR(date,4,2) new_date
FROM sf_crime_data) t1

SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty,0) AS std_qty, COALESCE(o.gloss_qty,0) AS gls_qty, COALESCE(o.poster_qty,0) AS pos_qty, COALESCE(o.total,0) AS total, COALESCE(o.standard_amt_usd,0) AS std_amt, COALESCE(o.gloss_amt_usd,0) AS gls_amt, COALESCE(o.poster_amt_usd,0) AS pos_amt, COALESCE(o.total_amt_usd,0) AS total_amt
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id

WITH double_accounts AS (SELECT *
FROM accounts a1

UNION ALL

SELECT *
FROM accounts a2 )

SELECT name, COUNT(*)
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC
