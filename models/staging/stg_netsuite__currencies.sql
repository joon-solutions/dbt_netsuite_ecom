with source as (
    select * from {{ source('netsuite','currency') }}
),

renamed as (
    select
        id as currency_id,
        name as currency_name,
        symbol as currency_symbol,

        lastmodifieddate as last_modified_at,

        currencyprecision as currency_precision,
        displaysymbol as display_symbol,
        fxrateupdatetimezone as fx_rate_update_timezone,
        symbolplacement as symbol_placement,
        includeinfxrateupdates = 'T' as is_include_in_fx_rate_updates,
        overridecurrencyformat = 'T' as is_override_currency_format,
        isbasecurrency = 'T' as is_base_currency,
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
