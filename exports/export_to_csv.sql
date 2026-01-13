COPY (
    SELECT
        c.name AS city,
        COUNT(ts.stop_id) AS stop_count
    FROM cities c
    LEFT JOIN transit_stops ts
        ON c.city_id = ts.city_id
    GROUP BY c.name
    ORDER BY stop_count DESC
)
TO '/tmp/transit_stop_summary.csv'
WITH CSV HEADER;