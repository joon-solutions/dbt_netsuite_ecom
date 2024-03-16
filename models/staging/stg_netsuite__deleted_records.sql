with source as (
    select * from {{ source('netsuite','deletedrecord') }}
),

renamed as (
    select

        recordid as record_id,
        recordtypeid as record_type,
        scriptid as script_id,

        name,
        type,
        context,

        deletedby as deleted_by,
        deleteddate as deleted_date,

        iscustomlist = 'T' as is_custom_list,
        iscustomrecord = 'T' as is_custom_record,
        iscustomtransaction = 'T' as is_custom_transaction

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
