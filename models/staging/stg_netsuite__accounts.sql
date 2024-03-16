with source as (
    select * from {{ source('netsuite','account') }}
),

renamed as (
    select
        id as account_id,
        currency as currency_id,
        department as department_id,
        externalid as external_id,
        parent as parent_id,
        subsidiary as subsidiary_id,

        lastmodifieddate as last_modified_at,

        acctnumber as account_number,
        accttype as account_type,
        sspecacct as sspec_acct,

        --acc name
        displaynamewithhierarchy as display_name_with_hierarchy,
        fullname as account_full_name, -- only has name without number
        accountsearchdisplayname as account_name, -- has both number & name
        -- accountsearchdisplaynamecopy as account_search_display_name_copy, -- not used

        --boolean
        isinactive = 'T' as is_inactive,
        issummary = 'T' as is_summary,
        eliminate = 'T' as is_eliminate,
        revalue = 'T' as is_revalue,
        includechildren = 'T' as is_include_children,
        inventory = 'T' as is_inventory,
        reconcilewithmatching = 'T' as is_reconcile_with_matching,

        cashflowrate as cashflow_rate,
        description,
        generalrate as general_rate

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
