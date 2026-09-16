# 🌊 Dark Fleet & Foreign Waters Analytics

> An end-to-end geospatial analytics project for exploring foreign fishing
> activity and identifying high-risk fishing patterns across global waters.

![Dashboard Overview](assets/dashboard-overview.png)

## 🎯 Project Overview

This project transforms large-scale Global Fishing Watch vessel activity
data into an analytics-ready platform for investigating fishing activity
outside domestic waters.

The solution combines data engineering, analytics engineering and
geospatial analysis to identify patterns across vessels, flag states,
Exclusive Economic Zones (EEZs), and time.

## 🏗️ Architecture

![dbt Lineage](assets/dbt-lineage.png)

## 🧱 Data Architecture

The project follows a layered **Bronze → Silver → Gold** analytics architecture built with dbt and BigQuery.

### 🥉 Bronze — Source Standardization

The Bronze layer provides a clean interface to the raw Global Fishing Watch datasets while preserving their original granularity.

Key models include:

- `stg_fleet_daily` — daily fleet-level fishing activity
- `stg_mmsi_daily` — vessel activity at MMSI level
- `stg_vessels` — vessel identity and registry information
- `stg_eez` — Exclusive Economic Zone reference data

### 🥈 Silver — Analytical Transformation

The Silver layer cleans, joins and standardizes the source data into reusable analytical entities.

Key models:

- `silver_fishing_events`
- `silver_vessels`
- `silver_eez`

This layer separates source-specific logic from downstream business and analytical logic.

### 🥇 Gold — Analytics-Ready Models

The Gold layer contains dimensional, fact and reporting models designed for downstream analysis and visualization.

Core models include:

- `dim_vessels`
- `dim_eez`
- `fct_fishing_daily_activity`
- `obt_fishing_daily_activity`
- `rpt_foreign_fishing_monthly`
- `rpt_high_risk_foreign_fishing_grid`

The final reporting models power the interactive dashboard and provide optimized datasets for temporal and geospatial analysis.
