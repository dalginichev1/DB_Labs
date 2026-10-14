INSERT INTO
    customers(
        customer_id,
        first_name,
        last_name,
        middle_name,
        email,
        phone_number
    )
VALUES (
    4,
    'Иван',
    'Антонович',
    'Антонов',
    'ivan@example.com',
    '+79991112233'
);

UPDATE products
SET stock = -1
WHERE product_id = 2;

UPDATE customers
SET phone_number = '+79'
WHERE customer_id = 3;

INSERT INTO orders (
    order_id,
    creation_date,
    order_status,
    customer_id
)
VALUES (
    12,
    '2026-10-14 13:50:00',
    'Ожидает оплаты',
    100
);

UPDATE reviews
SET rating = 6
WHERE review_id = 1;

INSERT INTO deliveries (
    delivery_id,
    delivery_date,
    delivery_cost,
    delivery_status,
    order_id
)
VALUES (
    5,
    '2026-10-5 10:32:36',
    1250.45,
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    2
);