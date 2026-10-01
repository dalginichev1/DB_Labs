INSERT INTO
    customers (
        customer_id,
        first_name,
        last_name,
        email
    )
VALUES
    (
        1,
        'Test',
        'Test',
        'test1@mail.ru'
    );

INSERT INTO
    customers (
        customer_id,
        first_name,
        last_name,
        email
    )
VALUES
    (
        100,
        'Test',
        'Test',
        'user1@mail.ru'
    );

INSERT INTO
    customers (
        customer_id,
        first_name,
        last_name,
        email
    )
VALUES
    (
        101,
        'Test',
        NULL,
        'test101@mail.ru'
    );

INSERT INTO
    products (
        product_id,
        product_name,
        price,
        stock
    )
VALUES
    (100, 'Test product', -100, 10);

INSERT INTO
    orderItem (order_id, product_id, quantity)
VALUES
    (9999, 1, 1);

INSERT INTO
    orderItem (order_id, product_id, quantity)
VALUES
    (1, 1, 0);