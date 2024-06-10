CREATE TABLE payments_for_parents (
    id String,
    date Date,
    category String,
    purpose String,
    money Int32
) ENGINE = MergeTree()
ORDER BY (category, date, id);

CREATE MATERIALIZED VIEW payments_for_parents_mv TO payments_for_parents AS
SELECT
    JSONExtractString(value, 'id') AS id,
    toDate(JSONExtractString(value, 'date')) AS date,
    JSONExtractString(value, 'category') AS category,
    JSONExtractString(value, 'purpose') AS purpose,
    JSONExtractInt(value, 'money') AS money
FROM source
WHERE JSONExtractString(value, 'type') = 'payment'
  AND JSONExtractString(value, 'category') NOT IN ('gaming', 'useless');
