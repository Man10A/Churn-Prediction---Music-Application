SELECT standard_amt_usd, 
		SUM(standard_amt_usd) OVER ( ORDER BY occurred_at) AS running_total
FROM orders


^^^^^^^^^^^^^^^^^^^^Partition By ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
SELECT standard_amt_usd, DATE_TRUNC('year', occurred_at) AS year,
		SUM(standard_amt_usd) OVER ( PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at)
AS running_total
FROM orders

SELECT id, account_id,total,
	ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY id DESC) AS total_rank
FROM orders

SELECT id, account_id,total,
	RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders


select id, accoutn_id, standard_qty,
		DATE_TRUNC('month',occurred_at) AS month,
    DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank
    SUM(standard_qty) OVER ()



    SELECT id,
         account_id,
         standard_qty,
         DATE_TRUNC('month', occurred_at) AS month,
         DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
         SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
         COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
         AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
         MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
         MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
  FROM orders



  SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))


SELECT total_amt_usd, occurred_at,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
       LAG(total_amt_usd) OVER (ORDER BY occurred_at) AS lag,
       total_amt_usd - LAG(total_amt_usd) OVER (ORDER BY occurred_at) AS lag_difference
FROM (
  SELECT total_amt_usd, occurred_at
    FROM orders
 ) sub


 SELECT account_id,
 		standard_qty,occurred_at,
         NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
 FROM orders
 ORDER BY account_id, standard_qty DESC

 SELECT account_id,
		occurred_at,gloss_qty,
        NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY  account_id DESC



SELECT a.name as accounnt_name, a.primary_poc, s.name as sales_person
FROM accounts a
LEFT JOIN sales_reps s
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name


SELECT e1.id AS e1_id,
       e1.account_id AS e1_account_id,
       e1.occurred_at AS e1_occurred_at,
			 e1.channel AS e1_channel,
       e2.id AS e2_id,
       e2.account_id AS e2_account_id,
       e2.occurred_at AS e2_occurred_at,
			 e2.channel AS e2_channel
  FROM web_events e1
 LEFT JOIN web_events e2
   ON e1.account_id = e2.account_id
  AND e2.occurred_at > e1.occurred_at
  AND e2.occurred_at <= e1.occurred_at + INTERVAL '1 day'
ORDER BY e1.account_id, e1.occurred_at
