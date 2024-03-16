with source as (
    select * from {{ source('netsuite','accounttype') }}
),

renamed as (
    select
        internalid as internal_id,
        id as account_type_id,

        defaultcashflowratetype as default_cash_flow_rate_type,
        defaultgeneralratetype as default_general_rate_type,
        eliminationalgo as eliminational_go,
        longname as long_name,
        seqnum,

        "LEFT" = 'T' as is_account_left_side,
        includeinrevaldefault = 'T' as is_include_inreval_default,
        balancesheet = 'T' as is_in_balance_sheet,
        usercanchangerevaloption = 'T' as has_user_can_change_reval_option

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
