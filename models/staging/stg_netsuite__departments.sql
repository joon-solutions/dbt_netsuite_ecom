with source as (
    select * from {{ source('netsuite','department') }}
),

renamed as (
    select
        id as department_id,
        parent as parent_id,
        subsidiary as subsidiary_id,
        name as department_name,
        lastmodifieddate as last_modified_at,
        fullname as department_full_name,
        includechildren = 'T' as is_include_children,
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
