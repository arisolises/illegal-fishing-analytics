select *
from {{ source('gfw_bronze', 'stg_eez_v12') }}
