ogr2ogr -f GPKG transit_analysis.gpkg \
  PG:"host=localhost dbname=urban_mobility user=postgres password=YOUR_PASSWORD" \
  -sql "
    SELECT
        ts.stop_name,
        ts.mode,
        c.name AS city,
        ts.geom
    FROM transit_stops ts
    JOIN cities c
        ON ts.city_id = c.city_id
    WHERE ST_DWithin(
        ts.geom::geography,
        c.geom::geography,
        500
    )
  "