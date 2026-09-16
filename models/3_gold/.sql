
SELECT 
  f.*,
  v.* EXCEPT (mmsi, reporting_year, fishing_hours,active_hours,fishing_time_percentage,has_fishing_hours_anomaly),
  e.eez_name,
  e.iso_sovereign_code,
  e.iso_territory_code,
  e.sovereign_country,
  e.sovereign_country_2,
  e.sovereign_country_3,
  e.is_shared_or_disputed_zone
FROM {{ ref('fct_fishing_monthly_activity') }} AS f
LEFT JOIN {{ ref('dim_vessels') }} AS v
  ON  f.mmsi = v.mmsi 
  AND f.reporting_year = v.reporting_year
LEFT JOIN {{ ref('dim_eez') }} AS e
  ON f.eez_id = e.eez_id
WHERE f.clean_flag_code <> e.iso_territory_code 
  AND f.clean_flag_code <> e.iso_sovereign_code
