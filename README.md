# GIS SQL Portfolio – PostgreSQL + PostGIS Setup Guide

This repository demonstrates how SQL and spatial databases support real-world GIS analysis. It includes two example PostgreSQL/PostGIS databases, realistic schemas, and sample spatial data that can be queried locally.

## 🗂 Project Structure
```
sql-gis-portfolio/
│
├── databases/
│   ├── urban_mobility_schema.sql
│
├── queries/
│   ├── transit_analysis.sql
│
├── exports/
│   ├── export_to_csv.sql
│   ├── export_to_gpkg.md
```

---

## 1. Prerequisites

Before starting, install the following:

* **PostgreSQL** (v14+ recommended)
* **PostGIS** (installed via PostgreSQL installer)
* **pgAdmin 4** (comes with PostgreSQL)
* **VS Code**
* **VS Code PostgreSQL extension** (by Microsoft)

---

## 2. Database Overview

### Database 1: `urban_mobility`

Focus: public transit access and ridership patterns.

Tables:

* `cities` – city locations and populations
* `transit_stops` – bus/rail/tram stop locations
* `ridership` – daily boarding/alighting counts

### Database 2: `environmental_risk`

Focus: environmental hazards and demographic vulnerability.

Tables:

* `counties` – county boundaries
* `hazard_events` – point-based hazard incidents
* `demographics` – socioeconomic attributes by county

---

## 3. Creating the Databases

Open **pgAdmin 4** and connect to your PostgreSQL server.

Create both databases:

```sql
CREATE DATABASE urban_mobility;
CREATE DATABASE environmental_risk;
```

---

## 4. Enable PostGIS (Required)

PostGIS must be enabled **inside each database**.

For each database:

```sql
CREATE EXTENSION postgis;
```

Verify installation:

```sql
SELECT postgis_full_version();
```

---

## 5. Create Tables

Run the schema files located in `/databases/`:

* `urban_mobility_schema.sql`
* `environmental_risk_schema.sql`

Each schema defines geometry columns using EPSG:4326 (WGS84).

---

## 6. Load Sample Spatial Data

These examples use simplified coordinates for demonstration purposes only.

### urban_mobility – Sample Data

```sql
INSERT INTO cities (name, state, population, geom)
VALUES
('Raleigh', 'NC', 476587, ST_SetSRID(ST_MakePoint(-78.6382, 35.7796), 4326)),
('Durham', 'NC', 296186, ST_SetSRID(ST_MakePoint(-78.8986, 35.9940), 4326));

INSERT INTO transit_stops (stop_name, city_id, mode, geom)
VALUES
('Downtown Station', 1, 'bus', ST_SetSRID(ST_MakePoint(-78.6400, 35.7800), 4326)),
('Union Station', 1, 'rail', ST_SetSRID(ST_MakePoint(-78.6390, 35.7770), 4326)),
('Durham Central', 2, 'bus', ST_SetSRID(ST_MakePoint(-78.9010, 35.9960), 4326));

INSERT INTO ridership (stop_id, service_date, boardings, alightings)
VALUES
(1, '2024-06-01', 120, 115),
(2, '2024-06-01', 340, 330),
(3, '2024-06-01', 90, 95);
```

---

### environmental_risk – Sample Data

```sql
INSERT INTO counties (name, state, geom)
VALUES
('Wake County', 'NC', ST_SetSRID(
    ST_GeomFromText('POLYGON((-78.9 35.6, -78.3 35.6, -78.3 36.1, -78.9 36.1, -78.9 35.6))'), 4326)),
('Durham County', 'NC', ST_SetSRID(
    ST_GeomFromText('POLYGON((-79.1 35.9, -78.7 35.9, -78.7 36.1, -79.1 36.1, -79.1 35.9))'), 4326));

INSERT INTO demographics (county_id, median_income, population, percent_over_65)
VALUES
(1, 85000, 1130000, 13.2),
(2, 72000, 330000, 12.5);

INSERT INTO hazard_events (event_type, event_date, severity, geom)
VALUES
('Flood', '2023-09-12', 3, ST_SetSRID(ST_MakePoint(-78.7, 35.8), 4326)),
('Heat Wave', '2023-07-05', 4, ST_SetSRID(ST_MakePoint(-78.85, 36.0), 4326));
```

---

## 7. Connecting via VS Code

1. Install **PostgreSQL (Microsoft)** extension
2. Open Command Palette → `PostgreSQL: Add Connection`
3. Use:

   * Host: `localhost`
   * Port: `5432`
   * User: `postgres`
   * Database: urban_mobility (repeat for environmental_risk)

Queries can now be run directly from .sql files in VS Code.

## 8. Example Spatial Query
```sql
SELECT c.name, COUNT(ts.stop_id) AS stop_count
FROM cities c
LEFT JOIN transit_stops ts
  ON ST_DWithin(c.geom::geography, ts.geom::geography, 1000)
GROUP BY c.name;
```
## 9. Exporting Query Results for GIS Use
Query results from PostgreSQL/PostGIS can be exported for use in desktop GIS software such as ArcGIS Pro. Two common export formats are CSV and GeoPackage.

Export to CSV

CSV exports are useful for tabular summaries or non-spatial results.

## 10. Portfolio Notes

All spatial logic uses PostGIS functions

Sample data is intentionally small and readable

Queries are written for clarity and storytelling, not volume

This structure mirrors how spatial SQL is used in professional GIS and data engineering workflows.
