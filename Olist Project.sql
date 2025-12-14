use olist;

SELECT * FROM orders LIMIT 5;

SELECT COUNT(order_id) AS total_orders FROM orders;

-- Quantity of orders by status
SELECT order_status, COUNT(order_id) AS total_orders FROM orders GROUP BY order_status order by total_orders DESC;

-- Quantity of orders by score
SELECT review_score, COUNT(DISTINCT order_id) AS total_orders FROM order_reviews group by review_score order by total_orders DESC;

-- Quantity of orders by product category
SELECT 
		p.product_category_name as category,
        COUNT(DISTINCT o.order_id) as total_orders
FROM order_items o 
JOIN products p ON o.product_id = p.product_id 
group by p.product_category_name 
order by total_orders DESC;

-- Quantity of orders by product category (only high score)
SELECT 
		p.product_category_name as category,
        COUNT(DISTINCT oi.order_id) as total_orders
FROM order_reviews orw 
JOIN order_items oi ON orw.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE orw.review_score = 5.0
group by p.product_category_name 
order by total_orders DESC;

