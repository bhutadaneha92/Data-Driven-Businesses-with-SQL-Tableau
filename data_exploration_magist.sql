use magist;

-- -------------CUSTMORES--------------
SELECT *
FROM customers;

SELECT count(DISTINCT(customer_id))
FROM customers;

SELECT *
FROM geo;

-- -------------SELLERS--------------
SELECT *
FROM sellers;

SELECT count(DISTINCT(seller_id))   -- 3095
FROM sellers;

-- How many are tech sellers

SELECT 					                
    p.product_category_name,
    pn.product_category_name_english,
    round(avg(ot.price),2) AS avg_price, 
    round(sum(ot.price),2) AS sum_price, 
    count(DISTINCT(s.seller_id)) AS Tech_seller
FROM
    order_items AS ot
    JOIN
    sellers AS s ON ot.seller_id = s.seller_id
    JOIN
    products AS p ON ot.product_id = p.product_id
	JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE pn.product_category_name_english IN('air conditioning'
        , 'audio'
        , 'cine_photo'
        , 'computers'
        , 'computers_accessories'
        , 'consoles_games'
        , 'electronics'
        , 'fixed_telephony'
        , 'home_appliances'
        , 'home_appliances_2'
        , 'small_appliances'
        , 'telephony'
        , 'watches_gift')
GROUP BY p.product_category_name
ORDER BY avg_price DESC;

SELECT 					                
    -- pn.product_category_name_english,
    count(DISTINCT(s.seller_id)) AS Tech_seller
FROM
    order_items AS ot
    JOIN
    sellers AS s ON ot.seller_id = s.seller_id
    JOIN
    products AS p ON ot.product_id = p.product_id
	JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE pn.product_category_name_english IN('air conditioning'
        , 'audio'
        , 'cine_photo'
        , 'computers'
        , 'computers_accessories'
        , 'consoles_games'
        , 'electronics'
        , 'fixed_telephony'
        , 'home_appliances'
        , 'home_appliances_2'
        , 'small_appliances'
        , 'telephony'
        , 'watches_gift');
-- GROUP BY p.product_category_name;

-- -------------PRODUCTS--------------
SELECT *
FROM products;

SELECT count(product_id) AS Product_count  -- How many products are there in the products table? Total_products = 32951
FROM products;

SELECT *
FROM product_category_name_translation;

SELECT 					                -- Which are the categories with the most products?
    product_category_name,
    count(DISTINCT(product_id)) AS Product_count
FROM
    products
GROUP BY product_category_name
ORDER BY Product_count DESC;

SELECT 					                
    p.product_category_name,
    pn.product_category_name_english,
    SUM(p.product_photos_qty) AS Total_Qty
FROM
    products AS p
        JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
GROUP BY p.product_category_name
ORDER BY Total_Qty DESC;

-- --Avg price of products
SELECT 					                
    AVG(ot.price)
FROM
    order_items AS ot
        JOIN
    products AS p ON ot.product_id = p.product_id
ORDER BY price DESC;

-- ----------------------------Category by price------------------------
SELECT 					                
    p.product_category_name,
    pn.product_category_name_english,
    round(avg(ot.price),2) AS avg_price
FROM
    order_items AS ot
    JOIN
    products AS p ON ot.product_id = p.product_id
	JOIN
    product_category_name_translation AS pn ON p.product_category_name = pn.product_category_name
WHERE pn.product_category_name_english IN('computers_accessories','electronics')
GROUP BY p.product_category_name
ORDER BY avg_price DESC;

-- -------------ORDER_ITEMS--------------
SELECT *                               -- How many of those products were present in actual transactions?
FROM order_items;

SELECT count(DISTINCT(order_id))		-- 98666
FROM order_items;

SELECT count(DISTINCT(product_id))   -- How many of those products were present in actual transactions? Unique product_id = 32951
FROM order_items;

SELECT min(price) AS Cheapest, max(price) AS Expensive -- What’s the price for the most expensive and cheapest products? 
FROM order_items;

-- -------------ORDERS--------------
SELECT *
FROM orders;

SELECT count(DISTINCT(order_id)) AS Total_orders  -- How many orders are there in the dataset? Total_orders = 99441
FROM orders;

SELECT count(DISTINCT(customer_id)) AS Total_custmores  -- Total_custmores = 99441
FROM orders;

SELECT order_status, count(order_status) AS Order_status_count  -- Are orders actually delivered?
FROM orders
GROUP BY order_status;

SELECT 													--  Is Magist having user growth?
    YEAR(order_purchase_timestamp) AS Order_year,
    MONTH(order_purchase_timestamp) AS Order_month,
    COUNT(customer_id) AS Total_custmores
FROM
    orders
GROUP BY Order_year , Order_month
ORDER BY Order_year DESC , Order_month DESC;

-- -------------ORDER_PAYMENT--------------
SELECT *
FROM order_payments;

SELECT count(DISTINCT(order_id)) AS Total_order -- Total_orders = 99441
FROM order_payments;

SELECT payment_type, count(DISTINCT(order_id))
FROM order_payments
GROUP BY payment_type;

SELECT 
	MAX(payment_value) as highest,
    MIN(payment_value) as lowest
FROM
	order_payments;
    
-- Maximum someone has paid for an order:
SELECT
    SUM(payment_value) AS highest_order
FROM
    order_payments
GROUP BY
    order_id
ORDER BY
    highest_order DESC
LIMIT
    1;
-- -------------ORDER_REVIEWS--------------
SELECT *
FROM orders;
SELECT *
FROM order_reviews;

SELECT count(review_score), review_score
FROM order_reviews
GROUP BY review_score;

SELECT count(review_score), review_score
FROM order_reviews
GROUP BY review_score;

SELECT DATEDIFF( review_answer_timestamp, review_creation_date)
FROM order_reviews;

select *, review_score, TIMESTAMPDIFF(hour, review_creation_date, review_answer_timestamp) AS duration-- no. of Hours
from order_reviews;

select review_score, AVG(TIMESTAMPDIFF(hour, review_creation_date, review_answer_timestamp)) AS duration -- Avg time
from order_reviews
group by review_score
order by review_score;

SELECT AVG(review_score) AS average_rating   -- average rating
FROM order_reviews;

SELECT count(o.order_id) AS total_orders, count(ordr.order_id) AS Review_orders, ordr.review_score AS rating    
FROM orders AS o
LEFT JOIN order_reviews AS ordr ON o.order_id = ordr.order_id
GROUP BY ordr.review_score;

SELECT AVG(review_score) AS average_rating, count(order_id)
FROM order_reviews 
JOIN orders USING(order_id)
JOIN order_items  USING(order_id)
JOIN products AS p USING(product_id)
JOIN product_category_name_translation USING(product_category_name)
WHERE product_category_name_translation.product_category_name_english IN ('air conditioning'
        , 'audio'
        , 'cine_photo'
        , 'computers'
        , 'computers_accessories'
        , 'consoles_games'
        , 'electronics'
        , 'fixed_telephony'
        , 'home_appliances'
        , 'home_appliances_2'
        , 'small_appliances'
        , 'telephony'
        , 'watches_gift'); 


SELECT count(o.order_id)  -- Are orders actually delivered?
FROM orders AS o
JOIN order_items AS ot ON o.order_id = ot.order_id
-- JOIN products AS p ON ot.product_id = p.product_id
WHERE o.order_status = 'delivered';


-- ---------------------------------------------------------------
SELECT *
FROM orders;

SELECT AVG(TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date)) AS estimated_delivered,
		AVG(TIMESTAMPDIFF(DAY,orders.order_approved_at, orders.order_estimated_delivery_date)) AS approved_estimated,
		AVG(TIMESTAMPDIFF(DAY,orders.order_approved_at, orders.order_delivered_customer_date)) AS approved_delivered,
		AVG(TIMESTAMPDIFF(DAY,orders.order_approved_at, orders.order_delivered_carrier_date)) AS delivered_carrier,
		 AVG(TIMESTAMPDIFF(DAY,orders.order_delivered_carrier_date, orders.order_delivered_customer_date)) AS  carrier_customer,
         AVG(TIMESTAMPDIFF(DAY,orders.order_purchase_timestamp, orders.order_delivered_customer_date)) AS  Total_avg_time,
        product_category_name_translation.product_category_name_english
FROM orders
JOIN order_items USING (order_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING(product_category_name)
WHERE product_category_name_translation.product_category_name_english IN ('air conditioning'
        , 'audio'
        , 'cine_photo'
        , 'computers'
        , 'computers_accessories'
        , 'consoles_games'
        , 'electronics'
        , 'fixed_telephony'
        , 'home_appliances'
        , 'home_appliances_2'
        , 'small_appliances'
        , 'telephony'
        , 'watches_gift')
GROUP BY product_category_name_translation.product_category_name_english;

-- orders deliver on time
SELECT TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date) AS estimated_delivered
FROM orders;

SELECT 
    COUNT(order_id) AS on_time_delivery,
    TIMESTAMPDIFF(DAY,
        orders.order_delivered_customer_date,
        orders.order_estimated_delivery_date) AS estimated_delivered
FROM
    orders
HAVING
    estimated_delivered > 0;
    
    
-- 
SELECT TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date) AS delay,
CASE 
	WHEN delay < 0 THEN delay
    WHEN delay >= 0 THEN not_delay
FROM orders
JOIN order_items USING (order_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING(product_category_name)
WHERE product_category_name_translation.product_category_name_english in ("electronics","computers","telephony","watches_gifts","computers_accesories" )
		AND TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date) < 0;
GROUP BY delay
ORDER BY delay DESC;


SELECT count(order_id), TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date) AS delay
FROM orders
WHERE TIMESTAMPDIFF(DAY,orders.order_delivered_customer_date, orders.order_estimated_delivery_date) < 0;