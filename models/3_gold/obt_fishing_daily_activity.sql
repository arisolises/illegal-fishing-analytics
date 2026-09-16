with 

fct_fishing_daily_activity as (

    select * from {{ ref('fct_fishing_daily_activity') }}

),

vessel_flag_resolved as (

    select
        v.*,
        s.sovereign_country_code as vessel_sovereign_code,
        s.sovereign_country_name as vessel_sovereign_name
    from {{ ref('dim_vessels') }} as v
    left join {{ ref('sovereign_countries') }} as s
        on v.clean_flag_code = s.flag_code

),

dim_eez as (

    select * from {{ ref('dim_eez') }}

),

final as (

    select
        f.*,
        
        -- vessel dimension attributes (excluding duplicated keys/metrics)
        v.* except (
            mmsi, 
            reporting_year, 
            fishing_hours, 
            active_hours, 
            fishing_time_percentage, 
            has_fishing_hours_anomaly
        ),

        -- eez dimension attributes
        e.eez_name,
        e.iso_sovereign_code,
        e.iso_territory_code,
        e.sovereign_country,
        e.sovereign_country_2,
        e.sovereign_country_3,
        e.is_shared_or_disputed_zone,

        -- refined location classification
        case 
            when f.eez_id = 0 then 'high_seas'
            when v.vessel_sovereign_code = e.iso_sovereign_code then 'domestic_waters'
            else 'foreign_waters'
        end as fishing_location_type

    from fct_fishing_daily_activity as f

    left join vessel_flag_resolved as v
        on f.mmsi = v.mmsi
        and f.reporting_year = v.reporting_year

    left join dim_eez as e
        on f.eez_id = e.eez_id

)

select * from final