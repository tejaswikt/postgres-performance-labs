-- =========================================================================
-- CHAPTER 2: DATABASE RECREATION & HAPPY WORKLOAD SEEDING
-- Target Database: creditcards
-- Target Schema: consumer
-- =========================================================================

\echo 1. Clean up existing structures (Ensures clean slate)
DROP SCHEMA IF EXISTS consumer CASCADE;
CREATE SCHEMA consumer;

\echo 2. Create tables with native serial sequences 
CREATE TABLE consumer.customers (
    customer_id bigserial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone_number varchar(20),
    city varchar(50),
    state varchar(50),
    created_date timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE consumer.credit_cards (
    card_id bigserial PRIMARY KEY,
    customer_id bigint NOT NULL REFERENCES consumer.customers(customer_id) ON DELETE CASCADE,
    card_number varchar(20) NOT NULL UNIQUE,
    card_type varchar(20),
    credit_limit numeric(12,2),
    issue_date date DEFAULT CURRENT_DATE,
    expiry_date date,
    status varchar(20) DEFAULT 'Active'
);

CREATE TABLE consumer.transactions (
    transaction_id bigserial PRIMARY KEY,
    card_id bigint NOT NULL REFERENCES consumer.credit_cards(card_id) ON DELETE CASCADE,
    merchant_name varchar(100),
    transaction_amount numeric(12,2),
    transaction_date timestamp DEFAULT clock_timestamp(),
    transaction_type varchar(20),
    city varchar(50),
    status varchar(20) DEFAULT 'Approved'
);

CREATE TABLE consumer.payments (
    payment_id bigserial PRIMARY KEY,
    customer_id bigint NOT NULL REFERENCES consumer.customers(customer_id) ON DELETE CASCADE,
    payment_amount numeric(12,2),
    payment_method varchar(20),
    payment_date timestamp DEFAULT clock_timestamp()
);

\echo 3. Load baseline mock data -- Generate 1,000 customers
INSERT INTO consumer.customers (first_name, last_name, email, phone_number, city, state)
SELECT 
    'First_' || i,
    'Last_' || i,
    'customer_' || i || '@example.nl',
    '+316' || floor(random() * 90000000 + 10000000)::text,
    CASE floor(random()*4)::int
        WHEN 0 THEN 'Almere'
        WHEN 1 THEN 'Amsterdam'
        WHEN 2 THEN 'Utrecht'
        ELSE 'Rotterdam'
    END,
    'Flevoland'
FROM generate_series(1, 1000) AS i;

\echo Generate 1 credit card per customer
INSERT INTO consumer.credit_cards (customer_id, card_number, card_type, credit_limit, expiry_date)
SELECT 
    customer_id,
    '4111-' || floor(random() * 9000 + 1000)::text || '-XXXX-' || floor(random() * 9000 + 1000)::text,
    CASE floor(random()*2)::int WHEN 0 THEN 'Visa' ELSE 'Mastercard' END,
    (floor(random() * 5 + 1) * 2000)::numeric(12,2),
    CURRENT_DATE + interval '4 years'
FROM consumer.customers;

\echo Generate 5 transactions per credit card (Bulk relational loading)
INSERT INTO consumer.transactions (card_id, merchant_name, transaction_amount, transaction_type, city)
SELECT 
    card_id,
    'Supermarket_' || floor(random() * 10 + 1)::text,
    (random() * 75 + 5)::numeric(12,2),
    'Purchase',
    'Almere'
FROM consumer.credit_cards, generate_series(1, 5);

\echo Generate 1 payment per customer
INSERT INTO consumer.payments (customer_id, payment_amount, payment_method)
SELECT 
    customer_id,
    (random() * 100 + 10)::numeric(12,2),
    'Direct Debit'
FROM consumer.customers;

\echo 4. Analyze all tables immediately to populate optimizer statistics
ANALYZE consumer.customers;
ANALYZE consumer.credit_cards;
ANALYZE consumer.transactions;
ANALYZE consumer.payments;
