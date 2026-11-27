/*Разделить покупателей на сегменты в зависимости от их покупательской активности и общей суммы покупок по состоянию на сегодняшний день.

Использовать следующие сегменты:
- Без покупок — покупатели, не имеющие оплаченных или выполненных заказов.
- VIP — покупатели с общей суммой покупок не менее 150 000 рублей.
- Постоянные — покупатели, совершившие не менее 3 заказов.
- Спящие — покупатели, последний заказ которых был более 30 дней назад.
- Обычные — остальные покупатели.
Для каждого сегмента рассчитать:
- количество покупателей;
- общее количество заказов;
- общую выручку;
- долю сегмента в общей выручке (в процентах);
- средний чек;
- средний рейтинг покупателей по оставленным отзывам.
Отсортировать сегменты по общей выручке в порядке убывания.*/

WITH params AS (
    SELECT CURRENT_DATE AS report_date
),
order_totals AS (
    SELECT o.order_id,
           o.customer_id,
           o.creation_date,
           SUM(oi.quantity * p.price) as order_total
    FROM orders o 
    JOIN orderItem oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_status IN ('Выполнен', 'Оплачен')
    GROUP BY o.order_id, o.customer_id, o.creation_date
),
customer_orders AS (
    SELECT c.customer_id,
           CASE
        WHEN c.middle_name IS NOT NULL THEN c.last_name || ' ' || c.first_name || ' ' || c.middle_name
        ELSE c.last_name || ' ' || c.first_name
        END as customer,
        COUNT(ot.order_id) as order_cnt,
        COALESCE(SUM(ot.order_total), 0) as revenue,
        MAX(ot.creation_date) as last_order
    FROM customers c 
    LEFT JOIN order_totals ot ON ot.customer_id = c.customer_id
    GROUP BY c.customer_id, c.last_name, c.first_name
),
customer_rating AS (
    SELECT customer_id, AVG(rating) as avg_rating
    FROM reviews
    GROUP BY customer_id
),
segmented AS (
    SELECT co.customer_id,
           co.customer,
           co.order_cnt,
           co.revenue,
           cr.avg_rating,
           (SELECT report_date FROM params) - co.last_order as last_order_days,
           CASE 
                WHEN co.order_cnt = 0 THEN 'Без покупок'
                WHEN co.revenue >= 150000 THEN 'VIP'
                WHEN co.order_cnt >= 3 THEN 'Постоянные'
                WHEN (SELECT report_date FROM params) - co.last_order > INTERVAL '30 days' THEN 'Спящие'
                ELSE 'Обычные'
            END AS segment
        FROM customer_orders co 
        LEFT JOIN customer_rating cr ON cr.customer_id = co.customer_id
)
SELECT segment,
       COUNT(*) AS customers_cnt,
       SUM(order_cnt) AS total_orders_cnt,
       SUM(revenue) AS total_revenue,
       ROUND(100 * SUM(revenue) / NULLIF((SELECT SUM(revenue) FROM segmented), 0), 2) AS revenue_share_pct,
       ROUND(SUM(revenue) / NULLIF((SUM(order_cnt)), 0), 2) AS avg_check,
       ROUND(AVG(avg_rating), 2) as total_avg_rating
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;

/*По категориям вывести средний чек категории и 3-м столбцом вывести глобальный средний чек*/

WITH order_totals AS (
    SELECT oi.order_id,
        SUM(oi.quantity * p.price) as total
    FROM orderItem oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY oi.order_id
),
category_order_totals AS (
    SELECT oi.order_id,
        pc.category_id,
        SUM(oi.quantity * p.price) as total
    FROM orderItem oi
    JOIN products p ON p.product_id = oi.product_id
    JOIN productCategory pc ON pc.product_id = p.product_id
    GROUP BY oi.order_id, pc.category_id
)
SELECT cat.category_name,
    ROUND(AVG(catot.total), 2) AS avg_check_category,
    (SELECT ROUND(AVG(total), 2) FROM order_totals) AS avg_check
FROM categories cat
LEFT JOIN category_order_totals catot ON catot.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY cat.category_name;