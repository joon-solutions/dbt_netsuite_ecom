with source as (
    select * from {{ source('netsuite','entitystatus') }}
),

renamed as (
    select
        key as entity_status_id,
        name as entity_name,
        entitytype as entity_type,
        probability,
        inactive = 'T' as is_inactive,
        includeinleadreports = 'T' as is_includeinleadreports,
        readonly = 'T' as is_readonly,

        entity_type || '-' || entity_name as entity_status

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
