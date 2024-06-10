CREATE TABLE counters
(
    id String,
    counter Int32
) ENGINE = SummingMergeTree()
ORDER BY id;

CREATE MATERIALIZED VIEW counters_mv TO counters
AS SELECT
    JSONExtractString(value, 'id') AS id,
    JSONExtractInt(value, 'value') AS counter
FROM source
WHERE JSONExtractString(value, 'type') = 'counter';