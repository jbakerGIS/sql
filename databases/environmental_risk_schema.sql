-- Enable PostGIS (safe if already enabled)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Counties table
CREATE TABLE counties (
    county_id SERIAL PRIMARY KEY,
    name TEXT,
    state TEXT,
    geom GEOMETRY(Polygon, 4326)
);

-- Hazard events table
CREATE TABLE hazard_events (
    event_id SERIAL PRIMARY KEY,
    event_type TEXT,
    event_date DATE,
    severity INTEGER,
    geom GEOMETRY(Point, 4326)
);

-- Demographics table
CREATE TABLE demographics (
    county_id INTEGER REFERENCES counties(county_id),
    median_income INTEGER,
    population INTEGER,
    percent_over_65 NUMERIC(5,2),
    PRIMARY KEY (county_id)
);
