ALTER TABLE products
ADD COLUMN manufacturer VARCHAR(255);

ALTER TABLE products
ALTER COLUMN manufacturer SET DEFAULT 'не указан';

UPDATE products
SET manufacturer = 'не указан' WHERE manufacturer IS NULL;

ALTER TABLE products
ALTER COLUMN manufacturer SET NOT NULL;

ALTER TABLE products
ADD COLUMN warranty_months INTEGER DEFAULT 12;

ALTER TABLE products
ADD CONSTRAINT warranty_months CHECK (warranty_months >= 0);

ALTER TABLE products
RENAME COLUMN manufacturer TO brand;

ALTER TABLE products
ALTER COLUMN brand TYPE VARCHAR(512);

ALTER TABLE products 
ALTER COLUMN brand DROP DEFAULT;

ALTER TABLE products
DROP COLUMN warranty_months;
