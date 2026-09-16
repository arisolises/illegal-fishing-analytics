
{{ config(
    materialized = 'table',
    partition_by = {
      'field': 'month_year',
      'data_type': 'date',
      'granularity': 'month'
    },
    cluster_by = ['eez_id', 'vessel_sovereign_code', 'impact_level']
) }}

with 

obt_daily as (

    select * from {{ ref('obt_fishing_daily_activity') }}

),

aggregated_grid as (

    select 
        -- temporal dimensions
        date_trunc(event_date, month) as month_year, 
        reporting_year,

        -- eez & vessel attributes
        eez_id, 
        eez_name,
        risk_level,
        impact_level,
        vessel_sovereign_code,
        vessel_sovereign_name,
        sovereign_country,
        iso_sovereign_code,

        -- spatial grid discretization (0.25 degree resolution)
        round(safe_cast(lat as float64) / 0.25) * 0.25 as lat, 
        round(safe_cast(lon as float64) / 0.25) * 0.25 as lon,

        -- aggregated activity metrics
        round(sum(total_hours), 2) as total_hours,
        round(sum(fishing_hours), 2) as fishing_hours
    
    from obt_daily
    where 
        -- risk & impact filters
        risk_level = 'high' 
        and impact_level in ('high', 'medium')
        
        -- foreign waters or high seas condition
        and (
            iso_sovereign_code is null 
            or vessel_sovereign_code is distinct from iso_sovereign_code
        )
    group by 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

),

final as (

    select 
        *,
        concat(cast(lat as string), ', ', cast(lon as string)) as lat_lon_string
    from aggregated_grid

)

select * from final