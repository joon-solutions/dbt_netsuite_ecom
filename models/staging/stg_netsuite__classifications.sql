with source as (
    select * from {{ source('netsuite','classification') }}
),

renamed as (
    select
        id as class_id,
        externalid as external_id,
        parent as parent_id,
        subsidiary as subsidiary_id,
        name as class_name,
        lastmodifieddate as last_modified_at,
        custrecord_nspb_segment_code as nspb_segment_code,
        fullname as class_full_name,
        includechildren = 'T' as has_children,
        isinactive = 'T' as is_inactive

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
