-- Enable PostGIS (safe if already enabled)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Cities table
CREATE TABLE IF NOT EXISTS cities (
    city_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    state TEXT,
    population INTEGER,
    geom GEOMETRY(Point, 4326)
);

-- Transit stops table
CREATE TABLE IF NOT EXISTS transit_stops (
    stop_id SERIAL PRIMARY KEY,
    stop_name TEXT,
    city_id INTEGER REFERENCES cities(city_id),
    mode TEXT CHECK (mode IN ('bus', 'rail', 'tram')),
    geom GEOMETRY(Point, 4326)
);

-- Ridership table
CREATE TABLE IF NOT EXISTS ridership (
    stop_id INTEGER REFERENCES transit_stops(stop_id),
    service_date DATE,
    boardings INTEGER,
    alightings INTEGER,
    PRIMARY KEY (stop_id, service_date)
);
