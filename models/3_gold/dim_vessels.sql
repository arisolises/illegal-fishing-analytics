with 

silver_vessels as (

    select * from {{ ref('silver_vessels') }}

),

scored as (

    select
        *,
        (
            -- Flag anomaly weight
            case 
                when flag_status in ('mismatched', 'unverified') 
                    then {{ var('risk_weight_flag', 5) }} 
                else 0 
            end

            -- Operational anomalies weight
            + case 
                when has_fishing_hours_anomaly 
                    then {{ var('risk_weight_hours_anomaly', 3) }} 
                else 0 
            end

            -- Registry inconsistency weights
            + case 
                when tonnage_discrepancy_status in ('over_reported', 'under_reported') 
                    then {{ var('risk_weight_tonnage', 2) }} 
                else 0 
            end
            + case 
                when engine_power_discrepancy_status in ('over_reported', 'under_reported') 
                    then {{ var('risk_weight_engine', 2) }} 
                else 0 
            end
            + case 
                when length_discrepancy_status in ('over_reported', 'under_reported') 
                    then {{ var('risk_weight_length', 1) }} 
                else 0 
            end
        ) as risk_score,

        (
            -- Gear category capacity weight
            case 
                when gear_category in ('industrial', 'industrial_distant_water') 
                    then {{ var('impact_weight_gear_industrial', 5) }}
                when gear_category = 'mixed' 
                    then {{ var('impact_weight_gear_mixed', 3) }}
                else 0 
            end

            -- Tonnage capacity weight (fleet percentiles)
            + case 
                when tonnage_gt_gfw >= {{ var('impact_tonnage_p75', 500) }} 
                    then {{ var('impact_weight_tonnage_high', 3) }}
                when tonnage_gt_gfw >= {{ var('impact_tonnage_p50', 200) }} 
                    then {{ var('impact_weight_tonnage_mid', 2) }}
                else 0 
            end

            -- Engine power capacity weight (fleet percentiles)
            + case 
                when engine_power_kw_inferred >= {{ var('impact_power_p75', 1000) }} 
                    then {{ var('impact_weight_power_high', 3) }}
                when engine_power_kw_inferred >= {{ var('impact_power_p50', 400) }} 
                    then {{ var('impact_weight_power_mid', 2) }}
                else 0 
            end
        ) as impact_score

    from silver_vessels

),

evaluated as (

    select
        *,
        case 
            when risk_score = 0 then 'low'
            when risk_score <= {{ var('risk_threshold_medium_max', 5) }} then 'medium'
            else 'high'
        end as risk_level,

        case 
            when impact_score = 0 then 'low'
            when impact_score <= {{ var('impact_threshold_medium_max', 5) }} then 'medium'
            else 'high'
        end as impact_level

    from scored

),

final as (

    select 
        *,
        concat(risk_level, '_risk_', impact_level, '_impact') as risk_impact_segment
    from evaluated

)

select * from final