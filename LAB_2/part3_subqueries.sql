/*1. Для каждой категории найти товары, цена которых выше средней цены всех товаров этой категории.

Вывести:
- название категории;
- название товара;
- цену товара;
- среднюю цену товаров соответствующей категории.
Отсортировать результаты по названию категории и цене товара в порядке убывания.*/

SELECT cat.category_name,
       p.product_name,
       p.price,
       ROUND(a.avg_price, 2) AS category_avg_price
FROM products p
JOIN productCategory pc ON pc.product_id  = p.product_id
JOIN categories cat     ON cat.category_id = pc.category_id
JOIN (
    SELECT pc2.category_id, AVG(p2.price) AS avg_price
    FROM productCategory pc2
    JOIN products p2 ON p2.product_id = pc2.product_id
    GROUP BY pc2.category_id
) a ON a.category_id = pc.category_id
WHERE p.price > a.avg_price
ORDER BY cat.category_name, p.price DESC;

/*2. Найти покупателей, которые оставили хотя бы один отзыв с оценкой не выше 2 баллов.

Вывести идентификатор покупателя, его ФИО и адрес электронной почты.*/

SELECT c.customer_id,
    CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END as customer,
    c.email
    FROM customers c
    WHERE EXISTS(
        SELECT 1
        FROM reviews r
        WHERE r.customer_id = c.customer_id AND r.rating <= 2
    );

/*3. Найти покупателей и товары из выполненных заказов, на которые покупатели ещё не оставили отзывы.

Вывести:
- идентификатор покупателя;
- ФИО покупателя;
- название товара.
Исключить товары, на которые уже существует отзыв от соответствующего покупателя. Убрать повторяющиеся строки.*/

SELECT DISTINCT c.customer_id,
       CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END as customer,
    p.product_name
    FROM orders o 
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN orderItem oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_status = 'Выполнен' AND NOT EXISTS(
        SELECT 1
        FROM reviews r 
        WHERE r.customer_id = c.customer_id AND r.product_id = p.product_id
    )
    ORDER BY customer_id, p.product_name;

/*4. Найти покупателей, у которых последний неотменённый заказ был оформлен более 21 дня назад относительно сегодняшнего дня.

Для каждого покупателя вывести:
- идентификатор;
- ФИО;
- количество неотменённых заказов;
- дату последнего заказа;
- количество дней с момента последнего заказа.
Отсортировать покупателей по количеству дней с момента последнего заказа в порядке убывания.*/

SELECT c.customer_id,
       CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END AS customer,
    (SELECT COUNT(*)
    FROM orders o
    WHERE o.customer_id = c.customer_id AND o.order_status <> 'Отменен') AS order_cnt,
    (SELECT MAX(o.creation_date)
    FROM orders o 
    WHERE o.customer_id = c.customer_id AND o.order_status <> 'Отменен') AS last_order,
    CURRENT_DATE - (SELECT MAX(o.creation_date)
    FROM orders o 
    WHERE o.customer_id = c.customer_id AND o.order_status <> 'Отменен') AS last_order_days
FROM customers c 
WHERE CURRENT_DATE - (SELECT MAX(o.creation_date)
    FROM orders o 
    WHERE o.customer_id = c.customer_id AND o.order_status <> 'Отменен') > INTERVAL '7 days'
ORDER BY last_order_days DESC;