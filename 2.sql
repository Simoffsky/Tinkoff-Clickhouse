CREATE TABLE payments (
    id String,
    date Date,
    category String,
    purpose String,
    money Int32,
    index Int32
) ENGINE = ReplacingMergeTree()
ORDER BY (category, date, id, index);


CREATE MATERIALIZED VIEW payments_mv TO payments AS
SELECT
    JSONExtractString(value, 'id') AS id,
    toDate(JSONExtractString(value, 'date')) AS date,
    JSONExtractString(value, 'category') AS category,
    JSONExtractString(value, 'purpose') AS purpose,
    JSONExtractInt(value, 'money') AS money,
    JSONExtractInt(value, 'index') AS index
FROM source
WHERE JSONExtractString(value, 'type') = 'payment';


CREATE TABLE payments_final AS payments
ENGINE = ReplacingMergeTree()
ORDER BY (category, date, id, index);