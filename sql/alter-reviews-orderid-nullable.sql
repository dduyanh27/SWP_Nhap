-- Make order_id nullable in Reviews table (temporary until payment module is built)
ALTER TABLE Reviews ALTER COLUMN order_id INT NULL;
