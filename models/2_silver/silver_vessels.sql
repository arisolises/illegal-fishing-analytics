with 

stg_vessels as (

    select * from {{ ref('stg_vessels') }}

),

transformed as (

    select
        -- identifiers & temporality
        mmsi,
        reporting_year,

        -- flag analysis
        flag_ais,
        flag_registry,
        upper(regexp_replace(gfw_flag, r'^(?i)UNKNOWN-', '')) as clean_flag_code,
        case 
            when flag_ais is null and flag_registry is null 
                then 'unverified'
            when flag_ais is not null and flag_registry is null 
                then 'ais_only'
            when flag_ais is null and flag_registry is not null 
                then 'registry_only'
            when trim(upper(flag_ais)) = trim(upper(flag_registry)) 
                then 'matched'
            else 'mismatched' 
        end as flag_status,

        -- vessel classification & gear mapping
        vessel_class_inferred_score,
        case 
            when vessel_class_inferred_score > {{ var('vessel_class_confidence_threshold', 0.5) }}
                then vessel_class_inferred 
            else null
        end as vessel_class_inferred,
        vessel_class_registry,
        vessel_class,
        is_self_reported_fishing,
        case
            when vessel_class in (
                'tuna_purse_seines', 'other_purse_seines', 'purse_seines', 
                'other_seines', 'seiners', 'trawlers'
            ) then 'industrial'
            when vessel_class in ('drifting_longlines', 'squid_jigger') 
                then 'industrial_distant_water'
            when vessel_class in ('set_longlines', 'fixed_gear') 
                then 'mixed'
            when vessel_class in (
                'pole_and_line', 'trollers', 'set_gillnets', 
                'pots_and_traps', 'dredge_fishing'
            ) then 'small_scale'
            else 'unclassified'
        end as gear_category,

        -- physical specifications & discrepancies
        length_m_registry,
        length_m_gfw,
        case 
            when length_m_registry is null then 'no_registration'
            when length_m_gfw is null then 'unknown_gfw'
            when length_m_registry > length_m_gfw then 'over_reported'
            when length_m_registry < length_m_gfw then 'under_reported'
            else 'matched'
        end as length_discrepancy_status,

        engine_power_kw_registry,
        engine_power_kw_inferred,
        case 
            when engine_power_kw_registry is null then 'no_registration'
            when engine_power_kw_inferred is null then 'unknown_gfw'
            when engine_power_kw_registry > engine_power_kw_inferred then 'over_reported'
            when engine_power_kw_registry < engine_power_kw_inferred then 'under_reported'
            else 'matched'
        end as engine_power_discrepancy_status,

        tonnage_gt_registry,
        tonnage_gt_gfw,
        case 
            when tonnage_gt_registry is null then 'no_registration'
            when tonnage_gt_gfw is null then 'unknown_gfw'
            when tonnage_gt_registry > tonnage_gt_gfw then 'over_reported'
            when tonnage_gt_registry < tonnage_gt_gfw then 'under_reported'
            else 'matched'
        end as tonnage_discrepancy_status,

        registries_listed,

        -- annual activity metrics & operational status
        active_hours,
        fishing_hours,
        case 
            when active_hours is null or active_hours = 0 then null
            else round(least(safe_divide(fishing_hours, active_hours), 1.0) * 100, 2)
        end as fishing_time_percentage,
        (fishing_hours > active_hours) as has_fishing_hours_anomaly,
        case 
            when active_hours is null or active_hours = 0 then 'inactive_or_no_signal'
            when fishing_hours > 0 then 'active_fishing'
            else 'active_navigation_only'
        end as operational_status

    from stg_vessels

)

select * from transformed
    

