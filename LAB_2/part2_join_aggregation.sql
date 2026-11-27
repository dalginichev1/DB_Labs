/*1. Вывести подробную информацию о заказах, оформленных в октябре 2026 года: номер и дату заказа, статус, 
 ФИО покупателя, названия товаров, их количество, цену и общую стоимость каждой позиции заказа. 
 Результат отсортировать по номеру заказа и названию товара*/

SELECT o.order_id,
    o.creation_date,
    o.order_status,
    CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END as customer,
    p.product_name,
    oi.quantity,
    p.price,
    p.price * oi.quantity as total
FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN orderItem oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
WHERE o.creation_date >= '2026-10-01'
    AND o.creation_date <= '2026-10-31'
ORDER BY o.order_id,
    p.product_name;

/*2. Вывести список товаров, которые не встречаются ни в одном заказе. 
 Для каждого товара указать его идентификатор, название, цену, остаток на складе и категорию. 
 Если товар не относится ни к одной категории, вывести «Без категории».*/

SELECT p.product_id,
    p.product_name,
    p.price,
    p.stock,
    COALESCE(cat.category_name, 'Без категории') as cat_name
FROM products p
    LEFT JOIN orderItem oi ON oi.product_id = p.product_id
    LEFT JOIN productcategory pc ON pc.product_id = p.product_id
    LEFT JOIN categories cat ON cat.category_id = pc.category_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;

/*3. Найти заказы, которые:
 - имеют статус «Оплачен»;
 - имеют подтверждённую оплату;
 - ожидают отправки;
 - были оформлены более 7 дней назад относительно сегодняшнего дня.
 Вывести информацию о заказе, покупателе, его номере телефона, способе и сумме оплаты, статусе доставки и количестве дней ожидания. 
 Отсортировать результаты по времени ожидания в порядке убывания.*/

SELECT o.order_id,
    o.creation_date,
    CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END as customer,
    c.phone_number,
    pay.method,
    pay.amount,
    d.delivery_status,
    CURRENT_DATE - o.creation_date::date as waiting_days
FROM orders o                                           
JOIN payments as pay ON pay.order_id = o.order_id
JOIN customers c ON c.customer_id = o.customer_id
JOIN deliveries d ON d.order_id = o.order_id
WHERE o.order_status = 'Оплачен' 
    AND pay.payment_status = 'Оплачен'
    AND d.delivery_status = 'Ожидает отправки'
    AND o.creation_date < CURRENT_DATE - INTERVAL '7 days'
ORDER BY waiting_days DESC;

/*4. Для каждой категории товаров рассчитать:
- количество заказов, в которых присутствуют товары данной категории;
- общее количество проданных единиц товаров;
- общую выручку;
- среднюю, минимальную и максимальную цену товаров.
При расчётах исключить отменённые заказы. Отсортировать категории по убыванию выручки.*/

SELECT cat.category_name,
    SUM(DISTINCT oi.order_id) AS order_count,
    SUM(oi.quantity) AS total_sold,
    SUM(p.price * oi.quantity) AS total_due,
    ROUND(AVG(p.price), 2) AS avg_price,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories cat
JOIN productCategory pc ON pc.category_id = cat.category_id
JOIN products p ON p.product_id = pc.product_id
JOIN orderItem oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status <> 'Отменен'
GROUP BY cat.category_name
ORDER BY total_due DESC;

/*5. Вывести покупателей, сумма покупок которых превышает 100 000 рублей (без учёта отменённых заказов).

Для каждого покупателя определить:
- количество совершённых заказов;
- общую сумму покупок;
- средний чек;
- дату последнего заказа.
Отсортировать покупателей по общей сумме покупок в порядке убывания.*/

SELECT c.customer_id,
    CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
    END as customer,
    COUNT(DISTINCT o.order_id) AS order_cnt,
    SUM(pay.amount) AS total_spent,
    ROUND(SUM(pay.amount) / COUNT(DISTINCT o.order_id), 2) AS avg_bill,
    MAX(o.creation_date) as last_order
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE o.order_status <> 'Отменен'
GROUP BY c.customer_id, c.last_name, c.first_name, c.middle_name
HAVING SUM(pay.amount) > 100000
ORDER BY total_spent DESC;

/*6. Для каждого способа оплаты рассчитать:
- количество платежей;
- общую сумму платежей;
- среднюю сумму платежа;
- минимальную сумму платежа;
- максимальную сумму платежа.
Учитывать только успешно оплаченные платежи. Отсортировать способы оплаты по общей сумме платежей в порядке убывания.*/

SELECT pay.method,
    COUNT(pay.payment_id) as payment_cnt,
    SUM(pay.amount) as total_amount,
    ROUND(AVG(pay.amount), 2) as avg_amount,
    MIN(pay.amount) as min_amount,
    MAX(pay.amount) as max_amount
FROM payments pay
WHERE pay.payment_status = 'Оплачен' 
GROUP BY pay.method
ORDER BY total_amount DESC;