use olist;

SELECT * FROM orders LIMIT 5;

SELECT COUNT(order_id) AS total_orders FROM orders;

-- Quantity of orders by status
SELECT order_status, COUNT(order_id) AS total_orders FROM orders GROUP BY order_status order by total_orders DESC;

-- Quantity of orders by score
SELECT review_score, COUNT(DISTINCT order_id) AS total_orders FROM order_reviews group by review_score order by total_orders DESC;

-- Percentage of orders by product score
SELECT 
	orw.review_score,
    round(
		COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT orw.order_id) FROM order_reviews orw)
    , 2) AS orders_percentage
FROM order_reviews orw
GROUP BY orw.review_score
ORDER BY orders_percentage DESC;



SELECT 
    orw.review_score,
    COUNT(DISTINCT orw.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT order_id) FROM order_reviews),
        2
    ) AS percentage_orders
FROM order_reviews orw
GROUP BY orw.review_score
ORDER BY orw.review_score;

-- Quantity of orders by product category
SELECT 
		p.product_category_name as category,
        COUNT(DISTINCT o.order_id) as total_orders
FROM order_items o 
JOIN products p ON o.product_id = p.product_id 
group by p.product_category_name 
order by total_orders DESC;


-- Quantity of orders by product category (only low score)
SELECT 
		p.product_category_name as category,
        COUNT(DISTINCT oi.order_id) as total_orders
FROM order_reviews orw 
JOIN order_items oi ON orw.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE orw.review_score < 5.0
group by p.product_category_name 
order by total_orders DESC;

-- Percentage of low score orders by product category
SELECT 
		p.product_category_name as category,
        ROUND(
			COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN oi.order_id END) * 100.0 /
            COUNT(DISTINCT oi.order_id)
        , 2) AS low_score_percentage
FROM order_reviews orw 
JOIN order_items oi ON orw.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
group by p.product_category_name 
order by low_score_percentage DESC;


-- categories with 100% low score
WITH orders_percentage AS (
	SELECT p.product_category_name as category,
		ROUND (
			COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN oi.order_id END) * 100.0
			/ COUNT(DISTINCT oi.order_id), 2
		) as low_score_percentage
	FROM products p 
	JOIN order_items oi 
	ON p.product_id = oi.product_id
	JOIN order_reviews orw
	ON orw.order_id = oi.order_id
	GROUP BY p.product_category_name
	ORDER BY low_score_percentage DESC
)
SELECT * 
FROM orders_percentage
WHERE low_score_percentage = 100.0;


-- Orders by 'diff_delivery_time' -> difference between the shipping limit date and the date the product was delivered
-- diff_delivery_time > 0 => the product was delivered on time
-- diff_delivery_time = 0 => the product was delivered on time, but exactly on the limit date
-- diff_delivery_time < 0 => the product was delivered late
SELECT 
	o.order_id,
	oi.shipping_limit_date,
	o.order_delivered_customer_date,
	datediff(oi.shipping_limit_date, o.order_delivered_customer_date) as diff_delivery_time
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
ORDER BY diff_delivery_time ASC;

-- average of 'diff_delivery_time' grouped by the product category
SELECT
	p.product_category_name,
	round(avg(datediff(oi.shipping_limit_date, o.order_delivered_customer_date)), 1) as avg_delivery_time
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
order by avg_delivery_time ASC;

-- average of 'diff_delivery_time' grouped by the product category, but showing only the categories with 100% low score
SELECT
	p.product_category_name,
	round(avg(datediff(oi.shipping_limit_date, o.order_delivered_customer_date)), 1) as avg_delivery_time
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_category_name IN ('alimentos_bebidas', 'artes', 'livros_tecnicos', 'malas_acessorios')
GROUP BY p.product_category_name
order by avg_delivery_time ASC;

-- Product categories ranked by late delivery percentage
SELECT 
    p.product_category_name AS categoria,
    COUNT(*) AS total_atrasos,
	round(
		count(*) * 100.0 /
		(SELECT COUNT(*)
			FROM orders o2 
			JOIN order_items oi2 ON o2.order_id = oi2.order_id
			WHERE datediff(o2.order_delivered_customer_date, oi2.shipping_limit_date) > 0
		)
    , 2) as late_percentage
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
    ORDER BY total_atrasos DESC;
    
-- low score categories ranked by late delivery percentage
WITH late_delivery_perc AS (
	SELECT 
	p.product_category_name AS categoria,
	COUNT(*) AS total_atrasos,
	round(
		count(*) * 100.0 /
		(SELECT COUNT(*)
			FROM orders o2 
			JOIN order_items oi2 ON o2.order_id = oi2.order_id
			WHERE datediff(o2.order_delivered_customer_date, oi2.shipping_limit_date) > 0
		)
	, 2) as late_percentage
	FROM orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	GROUP BY p.product_category_name
	ORDER BY total_atrasos DESC
	)
SELECT *
FROM late_delivery_perc
WHERE categoria IN ('alimentos_bebidas', 'artes', 'livros_tecnicos', 'malas_acessorios');


