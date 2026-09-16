with 

source as (

    select * from {{ source('gfw_public', 'fishing_vessels_v3') }}

),

renamed as (

    select
        -- identifiers & temporality
        safe_cast(mmsi as string) as mmsi,
        safe_cast(year as int64) as reporting_year,

        -- flags
        flag_ais,
        flag_registry,
        flag_gfw as gfw_flag,

        -- vessel classification
        vessel_class_inferred,
        safe_cast(vessel_class_inferred_score as float64) as vessel_class_inferred_score,
        vessel_class_registry,
        vessel_class_gfw as vessel_class,
        self_reported_fishing_vessel as is_self_reported_fishing,

        -- physical specifications
        safe_cast(length_m_registry as float64) as length_m_registry,
        safe_cast(length_m_gfw as float64) as length_m_gfw,
        safe_cast(engine_power_kw_inferred as float64) as engine_power_kw_inferred,
        safe_cast(engine_power_kw_registry as float64) as engine_power_kw_registry,
        safe_cast(tonnage_gt_inferred as float64) as tonnage_gt_inferred,
        safe_cast(tonnage_gt_registry as float64) as tonnage_gt_registry,
        safe_cast(tonnage_gt_gfw as float64) as tonnage_gt_gfw,
        registries_listed,

        -- annual activity metrics
        safe_cast(active_hours as float64) as active_hours,
        safe_cast(fishing_hours as float64) as fishing_hours

    from source

)

select * from renamed