-- models/3_gold/dim_eez.sql

with silver_eez as (

    select *
    from {{ ref('silver_eez') }}

),

real_zones as (

    select
        eez_id,
        eez_name,
        polygon_type,
        area_km2,
        territory_name,
        iso_territory_code,
        sovereign_country,
        iso_sovereign_code,
        territory_name_2,
        sovereign_country_2,
        territory_name_3,
        sovereign_country_3,
        is_shared_or_disputed_zone

    from silver_eez

),

high_seas as (

    select
        0 as eez_id,
        'High Seas / No EEZ' as eez_name,
        cast(null as string) as polygon_type,
        cast(null as numeric) as area_km2,
        cast(null as string) as territory_name,
        cast(null as string) as iso_territory_code,
        cast(null as string) as sovereign_country,
        cast(null as string) as iso_sovereign_code,
        cast(null as string) as territory_name_2,
        cast(null as string) as sovereign_country_2,
        cast(null as string) as territory_name_3,
        cast(null as string) as sovereign_country_3,
        false as is_shared_or_disputed_zone

),

final as (

    select * from real_zones
    union all
    select * from high_seas

)

select * from final