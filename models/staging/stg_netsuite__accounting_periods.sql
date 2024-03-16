with source as (
    select * from {{ source('netsuite','accountingperiod') }}
),

renamed as (
    select
        id as accounting_period_id,
        parent as parent_id,

        startdate as started_at,
        enddate as ended_at,
        closedondate as closed_at,
        lastmodifieddate as last_modified_at,

        periodname as period_name,

        allownonglchanges = 'T' as is_allow_non_gl_changes,
        alllocked = 'T' as is_alllocked,
        aplocked = 'T' as is_aplocked,
        arlocked = 'T' as is_arlocked,
        closed = 'T' as is_closed,
        isadjust = 'T' as is_adjust,
        isinactive = 'T' as is_inactive,
        isposting = 'T' as is_posting,
        isquarter = 'T' as is_quarter,
        isyear = 'T' as is_year

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
