with 

stg_mmsi_daily as (

    select * from {{ ref('stg_mmsi_daily') }}

),

transformed as (

    select
        -- identifiers & temporality
        mmsi,
        event_date,

        -- spatial dimensions
        lat,
        lon,
        st_geogpoint(lon, lat) as event_location,

        -- activity metrics
        total_hours,
        fishing_hours,
        round(least(safe_divide(fishing_hours, total_hours), 1.0), 2) as fishing_time_pct,

        -- quality & anomaly detection flags
        (fishing_hours > total_hours) as has_fishing_hours_anomaly,
        (total_hours < 0 or fishing_hours < 0) as has_negative_hours_anomaly,

        -- activity classification
        case 
            when total_hours is null or total_hours = 0 then 'no_activity'
            when fishing_hours > 0 then 'fishing'
            else 'transit_only'
        end as activity_status

    from stg_mmsi_daily

)

select * from transformed