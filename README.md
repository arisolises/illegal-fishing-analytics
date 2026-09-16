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

## ⚠️ Risk & Impact Scoring

To prioritize vessel activity for investigation, the project evaluates vessels across two independent dimensions: **risk** and **potential impact**.

### 🚨 Risk Score

Risk captures operational and registry anomalies associated with each vessel:

| Signal | Score |
|---|---:|
| Flag mismatch or unverified flag | +5 |
| Fishing-hours anomaly | +3 |
| Tonnage discrepancy | +2 |
| Engine-power discrepancy | +2 |
| Length discrepancy | +1 |

**Low:** 0 · **Medium:** 1–5 · **High:** >5

### ⚓ Impact Score

Impact represents the vessel's potential operational capacity based on gear type, tonnage, and engine power:

| Signal | Score |
|---|---:|
| Industrial / distant-water gear | +5 |
| Mixed gear | +3 |
| Tonnage ≥ 500 GT | +3 |
| Tonnage ≥ 200 GT | +2 |
| Engine power ≥ 1,000 kW | +3 |
| Engine power ≥ 400 kW | +2 |

**Low:** 0 · **Medium:** 1–5 · **High:** >5

The final reporting layer prioritizes **High-Risk vessels with Medium or High Impact** operating in foreign EEZs or the high seas.

> These scores are analytical screening indicators designed to prioritize patterns for further investigation. They do not establish that illegal fishing occurred.

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
