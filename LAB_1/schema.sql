CREATE TABLE customers(
    customer_id BIGINT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(16) UNIQUE CHECK (LENGTH(phone_number) >= 4) NOT NULL
);

CREATE TABLE products(
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_description VARCHAR(4096),
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER CHECK (stock >= 0) NOT NULL 
);

CREATE TABLE categories (
    category_id BIGINT PRIMARY KEY,
    category_name VARCHAR(255),
    category_description VARCHAR(4096)
);

CREATE TABLE orders(
    order_id BIGINT PRIMARY KEY,
    creation_date TIMESTAMP NOT NULL,
    order_status VARCHAR(255) NOT NULL,
    customer_id BIGINT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE deliveries (
    delivery_id BIGINT PRIMARY KEY,
    delivery_date TIMESTAMP,
    delivery_cost NUMERIC(8, 2) NOT NULL,
    delivery_status VARCHAR(63) NOT NULL,
    order_id BIGINT NOT NULL,
    FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT
);

CREATE TABLE reviews (
    review_id BIGINT PRIMARY KEY,
    rating SMALLINT CHECK (
        rating BETWEEN 1
        AND 5
    ) NOT NULL,
    creation_at TIMESTAMP DEFAULT NOW() NOT NULL,
    review_text VARCHAR(4096) CHECK (LENGTH(review_text) > 0),
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE productCategory (
    product_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

CREATE TABLE orderItem (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    method VARCHAR(255) NOT NULL,
    amount NUMERIC(15, 2) NOT NULL CHECK (amount > 0),
    payment_status VARCHAR(63) NOT NULL,
    order_id BIGINT UNIQUE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);