with 

source as (

    select * from {{ source('gfw_public', 'mmsi_daily_10_v3') }}

),

renamed as (

    select
        -- identifiers & temporality
        safe_cast(date as date) as event_date,
        safe_cast(mmsi as string) as mmsi,

        -- spatial dimensions
        safe_cast(cell_ll_lat as float64) as lat,
        safe_cast(cell_ll_lon as float64) as lon,

        -- activity metrics
        safe_cast(hours as float64) as total_hours,
        safe_cast(fishing_hours as float64) as fishing_hours

    from source

)

select * from renamed