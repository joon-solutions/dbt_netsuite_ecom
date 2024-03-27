with source as (
    select * from {{ source('netsuite','entity') }}
),

renamed as (
    select
        --id
        id as entity_id,
        contact as contact_id,
        customer as customer_id,
        employee as employee_id,
        "GROUP" as group_id,
        othername as other_name_id,
        vendor as vendor_id,
        toplevelparent as top_level_parent_id,

        datecreated as created_at,
        lastmodifieddate as last_modified_at,

        entitytitle as entity_title,
        entityid as entity_name,
        altname as alternative_name,
        type,

        isinactive = 'T' as is_inactive,
        isperson = 'T' as is_person

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
