with 

stg_eez as (

    select * from {{ ref('stg_eez') }}

),

transformed as (

    select
        -- identifiers
        safe_cast(mrgid_eez as int64) as eez_id,

        -- zone description
        replace(
            safe_cast(geoname as string), 
            'Exclusive Economic Zone', 
            'EEZ'
        ) as eez_name,
        safe_cast(pol_type as string) as polygon_type,
        safe_cast(area_km2 as float64) as area_km2,

        -- primary territory & sovereignty
        safe_cast(territory1 as string) as territory_name,
        safe_cast(iso_ter1 as string) as iso_territory_code,
        safe_cast(sovereign1 as string) as sovereign_country,
        safe_cast(iso_sov1 as string) as iso_sovereign_code,

        -- secondary territory/sovereign (shared or disputed zones)
        safe_cast(territory2 as string) as territory_name_2,
        safe_cast(sovereign2 as string) as sovereign_country_2,

        -- tertiary territory/sovereign (tripoint/rare cases)
        safe_cast(territory3 as string) as territory_name_3,
        safe_cast(sovereign3 as string) as sovereign_country_3,

        -- zone status flags
        (territory2 is not null) as is_shared_or_disputed_zone,

        -- spatial geometry optimization
        st_simplify(geometry, 50000) as eez_polygon

    from stg_eez
    where geometry is not null

)

select * from transformed