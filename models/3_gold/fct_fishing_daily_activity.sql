with 

silver_fishing_events as (

    select 
        *,
        extract(year from event_date) as reporting_year
    from {{ ref('silver_fishing_events') }}
    where event_date >= '2020-01-01'

),

unique_cells_raw as (

    select distinct
        round(lat, 1) as grid_lat,
        round(lon, 1) as grid_lon
    from silver_fishing_events

),

unique_cells as (

    select
        grid_lat,
        grid_lon,
        st_geogpoint(grid_lon, grid_lat) as cell_location
    from unique_cells_raw

),

silver_eez as (

    select
        eez_id,
        eez_polygon,
        st_boundingbox(eez_polygon) as bbox
    from {{ ref('silver_eez') }}

),

cells_resolved as (

    select
        cells.grid_lat,
        cells.grid_lon,
        eez.eez_id
    from unique_cells as cells
    left join silver_eez as eez
        on cells.grid_lon between eez.bbox.xmin and eez.bbox.xmax
        and cells.grid_lat between eez.bbox.ymin and eez.bbox.ymax
        and st_contains(eez.eez_polygon, cells.cell_location)

),

final as (

    select
        -- identifiers & foreign keys
        events.mmsi,
        events.reporting_year,
        coalesce(cells_resolved.eez_id, 0) as eez_id, -- 0 = High Seas / International Waters

        -- temporal & spatial dimensions
        events.event_date,
        events.lat,
        events.lon,
        

        -- activity metrics
        events.total_hours,
        events.fishing_hours,
        events.fishing_time_pct,

        -- quality flags & operational status
        events.has_fishing_hours_anomaly,
        events.has_negative_hours_anomaly,
        events.activity_status

    from silver_fishing_events as events
    left join cells_resolved
        on round(events.lat, 1) = cells_resolved.grid_lat
        and round(events.lon, 1) = cells_resolved.grid_lon

)

select * from final