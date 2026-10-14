INSERT INTO
    customers (
        customer_id,
        first_name,
        last_name,
        middle_name,
        email,
        phone_number
    )
VALUES
    (
        1,
        'Иван',
        'Иванов',
        'Иванович',
        'ivan@example.com',
        '+79991112233'
    ),
    (
        2,
        'Петр',
        'Петров',
        'Петрович',
        'petr@example.com',
        '+79992223344'
    ),
    (
        3,
        'Анна',
        'Смирнова',
        NULL,
        'anna@example.com',
        '+79993334455'
    );

INSERT INTO
    products (
        product_id,
        product_name,
        product_description,
        price,
        stock
    )
VALUES
    (1, 'Ноутбук', 'Игровой ноутбук', 120000, 10),
    (2, 'Мышь', 'Беспроводная мышь', 3500, 50),
    (
        3,
        'Клавиатура',
        'Механическая клавиатура',
        7000,
        25
    ),
    (4, 'Монитор', '27-дюймовый монитор', 30000, 15);

INSERT INTO
    categories (
        category_id,
        category_name,
        category_description
    )
VALUES
    (1, 'Компьютеры', 'Компьютерная техника'),
    (2, 'Периферия', 'Компьютерная периферия'),
    (3, 'Мониторы', 'Мониторы и дисплеи');

INSERT INTO
    orders (
        order_id,
        creation_date,
        order_status,
        customer_id
    )
VALUES
    (1, '2026-09-29 10:00:00', 'Создан', 1),
    (2, '2026-09-29 11:30:00', 'Оплачен', 2),
    (3, '2026-09-29 14:00:00', 'Создан', 3);

INSERT INTO
    deliveries (
        delivery_id,
        delivery_date,
        delivery_cost,
        delivery_status,
        order_id
    )
VALUES
    (1, '2026-09-30 12:00:00', 500.00, 'Доставляется', 1),
    (
        2,
        '2026-10-01 15:00:00',
        700.00,
        'Ожидает отправки',
        2
    ),
    (
        3, '2026-10-04 12:32:15', 400.00, 'Доставлено', 3);

INSERT INTO
    reviews (
        review_id,
        rating,
        creation_at,
        review_text,
        customer_id,
        product_id
    )
VALUES
    (
        1,
        5,
        '2026-09-29 16:00:00',
        'Отличный товар!',
        1,
        1
    ),
    (
        2,
        4,
        '2026-09-29 17:00:00',
        'Хорошая мышь.',
        2,
        2
    ),
    (
        3,
        5,
        '2026-09-29 18:00:00',
        'Отличная клавиатура.',
        3,
        3
    );

INSERT INTO
    productCategory (product_id, category_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 2),
    (4, 3);

INSERT INTO
    orderItem (order_id, product_id, quantity)
VALUES
    (1, 1, 1),
    (1, 2, 2),
    (2, 3, 1),
    (2, 4, 2),
    (3, 2, 3);

INSERT INTO
    payments (
        payment_id,
        method,
        amount,
        payment_status,
        order_id
    )
VALUES
    (1, 'Банковская карта', 127000.00, 'Оплачен', 1),
    (2, 'Банковская карта', 67000.00, 'Оплачен', 2),
    (3, 'Наличные', 11200.00, 'Ожидает оплаты', 3);