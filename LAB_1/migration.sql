/*Хотим хранить историю цены каждого продукта*/

CREATE TABLE priceHistory(
    product_id BIGINT NOT NULL,
    valid_from TIMESTAMP NOT NULL,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    PRIMARY KEY(product_id, valid_from),
    FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

INSERT INTO priceHistory (product_id, valid_from, price)
SELECT product_id, NOW(), price
FROM products;

ALTER TABLE products
DROP COLUMN price;

INSERT INTO 
    priceHistory(
        product_id, 
        valid_from, 
        price
    )
VALUES
(1, '2025-01-01 00:00', 1000.00),
(1, '2025-06-01 00:00',  900.00),
(1, '2026-01-01 00:00',  950.00),
(2, '2025-01-01 00:00',   20.00),
(2, '2025-09-01 00:00',   25.00),
(3, '2025-01-01 00:00',   50.00),
(4, '2025-02-01 00:00',  300.00),
(4, '2026-03-01 00:00',  280.00);