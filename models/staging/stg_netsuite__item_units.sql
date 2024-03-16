with source as (
    select * from {{ source('netsuite','itemunit') }}
),

renamed as (
    select
        key as item_unit_id,
        name

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
