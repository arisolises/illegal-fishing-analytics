with 

source as (

    select * from {{ source('gfw_public', 'fleet_daily_100_v3') }}

),

renamed as (

    select
        -- temporal & spatial dimensions
        safe_cast(date as date) as event_date,
        safe_cast(cell_ll_lat as float64) as lat,
        safe_cast(cell_ll_lon as float64) as lon,

        -- categorical dimensions
        lower(safe_cast(flag as string)) as flag,
        lower(safe_cast(geartype as string)) as gear_type,

        -- activity metrics
        safe_cast(hours as float64) as total_hours,
        safe_cast(fishing_hours as float64) as fishing_hours,
        safe_cast(mmsi_present as int64) as mmsi_count

    from source

)

select * from renamed