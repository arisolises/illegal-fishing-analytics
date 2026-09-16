with 

obt_daily as (

    select * from {{ ref('obt_fishing_daily_activity') }}

),

filtered_monthly as (

    select 
        date_trunc(event_date, month) as month_year, 
        reporting_year,
        eez_id, 
        eez_name,
        risk_level,
        impact_level,
        vessel_sovereign_code,
        vessel_sovereign_name,
        sovereign_country,
        iso_sovereign_code,
        mmsi,
        
        -- metric aggregation
        sum(fishing_hours) as fishing_hours

    from obt_daily
    where 
        iso_sovereign_code is null 
        or vessel_sovereign_code is distinct from iso_sovereign_code
    group by 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11

)

select * from filtered_monthly