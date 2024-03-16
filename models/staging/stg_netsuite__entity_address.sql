with source as (
    select * from {{ source('netsuite','entityaddress') }}
),

renamed as (
    select
        --id
        nkey as address_id,
        recordowner as record_owner_id,
        lastmodifieddate as last_modified_at,

        addr1,
        addr2,
        addressee,
        addrphone as addr_phone,
        addrtext as addr_text,

        state,
        zip,
        city,
        country,

        attention,
        dropdownstate as dropdown_state,
        override = 'T' as is_override

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
