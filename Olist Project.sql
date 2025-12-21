use olist;

SELECT * FROM orders LIMIT 5;

SELECT COUNT(order_id) AS total_orders FROM orders;

SELECT COUNT(order_id) AS total_orders FROM order_reviews;

SELECT 
	COUNT(DISTINCT orw.order_id) AS total_orders,
    ROUND(
		COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT o.order_id) FROM orders o)
    , 2) as percentage
FROM order_reviews orw
JOIN orders o ON orw.order_id = o.order_id;

-- Quantity of orders by status
SELECT order_status, COUNT(order_id) AS total_orders FROM orders GROUP BY order_status order by total_orders DESC;

-- Quantity of orders by score
SELECT review_score, COUNT(DISTINCT order_id) AS total_orders FROM order_reviews group by review_score order by total_orders DESC;

-- Percentage of orders by score
SELECT 
	orw.review_score,
    round(
		COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT orw.order_id) FROM order_reviews orw)
    , 2) AS orders_percentage
FROM order_reviews orw
GROUP BY orw.review_score
ORDER BY orders_percentage DESC;

-- Percentage of orders by score (grouped in "bad" and "good")
SELECT 
	CASE 
		WHEN orw.review_score > 3 THEN "Good" 
        ELSE "Bad" 
	END AS score_group,
    round(
		COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT orw.order_id) FROM order_reviews orw)
    , 2) AS orders_percentage
FROM order_reviews orw
GROUP BY score_group
ORDER BY orders_percentage DESC;


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
WHERE orw.review_score < 4.0
group by p.product_category_name 
order by total_orders DESC;

-- Percentage of low score orders by product category (only low score)
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

-- Low score percentage and representativeness by product category
SELECT 
    p.product_category_name AS categoria,
    COUNT(DISTINCT orw.order_id) AS total_pedidos_categoria,
    ROUND(
        COUNT(DISTINCT orw.order_id) * 100.0 /
        (SELECT COUNT(DISTINCT order_id) FROM order_reviews)
    , 2) AS perc_pedidos_categoria,
    ROUND(
        COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN orw.order_id END) * 100.0 /
        COUNT(DISTINCT orw.order_id)
    , 2) AS low_score_percentage
FROM order_reviews orw
JOIN order_items oi ON orw.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY low_score_percentage DESC;


-- Representativeness of critical categories (low score > 20%)
WITH categoria_stats AS (
    SELECT 
        p.product_category_name AS categoria,
        COUNT(DISTINCT oi.order_id) AS total_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT orw.order_id) * 100.0 /
            (SELECT COUNT(DISTINCT order_id) FROM order_reviews)
        , 2) AS perc_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN oi.order_id END) * 100.0 /
            COUNT(DISTINCT orw.order_id)
        , 2) AS low_score_percentage
    FROM order_reviews orw
    JOIN order_items oi ON orw.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT 
    SUM(perc_pedidos_categoria) AS perc_total_categorias_criticas
FROM categoria_stats
WHERE low_score_percentage >= 20;


-- Most representative product categories (low score >= 20% and orders percentage >= 5%)
WITH categoria_stats AS (
    SELECT 
        p.product_category_name AS categoria,
        COUNT(DISTINCT oi.order_id) AS total_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT orw.order_id) * 100.0 /
            (SELECT COUNT(DISTINCT order_id) FROM order_reviews)
        , 2) AS perc_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN oi.order_id END) * 100.0 /
            COUNT(DISTINCT orw.order_id)
        , 2) AS low_score_percentage
    FROM order_reviews orw
    JOIN order_items oi ON orw.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT 
    *
FROM categoria_stats
WHERE low_score_percentage >= 20 AND perc_pedidos_categoria >= 5.0;


-- Total low score orders by category
WITH categoria_stats AS (
    SELECT 
        p.product_category_name AS categoria,
        COUNT(DISTINCT oi.order_id) AS total_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT orw.order_id) * 100.0 /
            (SELECT COUNT(DISTINCT order_id) FROM order_reviews)
        , 2) AS perc_pedidos_categoria,
        ROUND(
            COUNT(DISTINCT CASE WHEN orw.review_score < 4 THEN oi.order_id END) * 100.0 /
            COUNT(DISTINCT orw.order_id)
        , 2) AS low_score_percentage
    FROM order_reviews orw
    JOIN order_items oi ON orw.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
)
SELECT
	categoria,
	total_pedidos_categoria,
    perc_pedidos_categoria,
    low_score_percentage,
    round((low_score_percentage * total_pedidos_categoria / 100.0), 0) total_low_score_orders
FROM categoria_stats
WHERE low_score_percentage >= 20 AND perc_pedidos_categoria >= 5.0;



-- Manual reading of low score order reviews
SELECT DISTINCT
	orw.order_id as ID,
	p.product_category_name as category,
    orw.review_comment_title as title,
    orw.review_comment_message as comment_message,
    orw.review_score as score
FROM order_reviews orw
JOIN order_items oi ON orw.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE p.product_category_name IN (
	"cama_mesa_banho",
    "beleza_saude",
    "informatica_acessorios",
    "moveis_decoracao",
    "relogios_presentes",
    "utilidades_domesticas"
) AND orw.review_score < 4.0;




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

    
    
-- Product categories ranked by late delivery percentage
SELECT 
    p.product_category_name AS categoria,
    COUNT(*) AS total_pedidos,
    SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, oi.shipping_limit_date) > 0 THEN 1 ELSE 0 END) AS total_atrasos,
    ROUND(
        SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, oi.shipping_limit_date) > 0 THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
    2) AS perc_atrasos
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
AND p.product_category_name IN (
"beleza_saude", "cama_mesa_banho", "informatica_acessorios", "relogios_presentes", "utilidades_domesticas"
)
GROUP BY p.product_category_name
ORDER BY perc_atrasos DESC;


-- Customer state ranked by late delivery percentage and order percentage
SELECT 
    c.customer_state AS categoria,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) 
         FROM customers c2
         JOIN orders o2 ON c2.customer_id = o2.customer_id
         JOIN order_items oi2 ON o2.order_id = oi2.order_id
         JOIN products p2 ON oi2.product_id = p2.product_id
         WHERE o2.order_delivered_customer_date IS NOT NULL
         AND p2.product_category_name IN (
             "beleza_saude", "cama_mesa_banho", "informatica_acessorios", "relogios_presentes", "utilidades_domesticas"
         )
        ), 2
    ) AS perc_pedidos_estado,
    SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, oi.shipping_limit_date) > 0 THEN 1 ELSE 0 END) AS total_atrasos,
    ROUND(
        SUM(CASE WHEN DATEDIFF(o.order_delivered_customer_date, oi.shipping_limit_date) > 0 THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
    2) AS perc_atrasos
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
AND p.product_category_name IN (
    "beleza_saude", "cama_mesa_banho", "informatica_acessorios", "relogios_presentes", "utilidades_domesticas"
)
GROUP BY c.customer_state
ORDER BY perc_atrasos DESC;



    

