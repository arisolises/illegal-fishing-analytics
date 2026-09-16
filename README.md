# 🌊 Dark Fleet & Foreign Waters Analytics

> An end-to-end geospatial analytics project for exploring foreign fishing activity and identifying high-risk fishing patterns across global waters.

![Dashboard Overview](assets/dashboard-overview.png)

## 🎯 Project Overview

This project transforms large-scale **Global Fishing Watch** vessel activity data into an analytics-ready platform for investigating fishing activity across domestic waters, foreign EEZs, and the high seas.

The solution combines **analytics engineering, geospatial analysis, and data visualization** to uncover patterns across vessels, flag states, Exclusive Economic Zones (EEZs), and time.

## 🏗️ Architecture

![dbt Lineage](assets/dbt-lineage.png)

The project follows a **Bronze → Silver → Gold** architecture built with dbt and BigQuery:

- 🥉 **Bronze** — standardizes raw vessel, fleet, and EEZ data.
- 🥈 **Silver** — cleans and transforms fishing events, vessels, and geographic entities.
- 🥇 **Gold** — builds dimensional, fact, and reporting models optimized for analytics and visualization.

## 🧠 Analytical Approach

Vessel coordinates are spatially matched to **Exclusive Economic Zones (EEZs)** and combined with vessel flag information to classify fishing activity as:

- 🏠 **Domestic Waters** — vessel and EEZ sovereignty match
- 🌍 **Foreign Waters** — vessel and EEZ sovereignty differ
- 🌊 **High Seas** — activity occurs outside a mapped EEZ

The reporting layer focuses on **high-risk, medium/high-impact fishing activity** occurring in foreign waters or the high seas.

> High-risk activity represents an analytical signal for investigation and should not be interpreted as proof of illegal fishing.

## 🗺️ Scaling Geospatial Analytics

Large-scale vessel activity creates millions of geographic observations that are expensive to render directly.

The dashboard layer aggregates high-risk activity into a **0.25° spatial grid and monthly periods**, reducing map complexity while preserving meaningful geographic patterns.

## 📊 Dashboard

The interactive dashboard enables exploration of:

- Fishing hours and vessel activity over time
- Foreign fishing across EEZs
- Vessel flag-state patterns
- Risk and impact classifications
- Geographic concentrations of high-risk activity

## 🛠️ Tech Stack

**BigQuery** · **dbt** · **SQL** · **Python** · **Geospatial SQL** · **Looker Studio**

## 📁 Key Models

`fct_fishing_daily_activity` → Core vessel-level fishing activity fact table

`obt_fishing_daily_activity` → Analytics-ready enriched activity dataset

`rpt_foreign_fishing_monthly` → Monthly foreign fishing analysis

`rpt_high_risk_foreign_fishing_grid` → Optimized geospatial reporting layer

## 📚 Data Source

Fishing activity and vessel data are sourced from **Global Fishing Watch**, an open platform providing data and tools for monitoring global fishing activity.

## 👤 Author

**Ariel Solis**

Data Scientist & Analytics Engineer

