with source as (
    select * from {{ source('netsuite','consolidatedexchangerate') }}
),

renamed as (
    select
        id as exchange_rate_id,
        postingperiod as posting_period_id,
        accountingbook as accounting_book_id,

        fromsubsidiary as from_subsidiary_id,
        tosubsidiary as to_subsidiary_id,

        fromcurrency as from_currency_id,
        tocurrency as to_currency_id,

        averagerate as average_rate,
        currentrate as current_rate,
        historicalrate as historical_rate

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
