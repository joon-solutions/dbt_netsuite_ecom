with

accounts as (

    select * from {{ ref('stg_netsuite__accounts') }}

),

consolidated_exchange_rates as (
    select *
    from {{ ref('stg_netsuite__consolidated_exchange_rates') }}
),


accounting_xjoined_cer as (
    -- getting the CER for each account in each accounting period
    -- NOTE: we do not join using the tocurrency OR fromcurrency as there's a 1-1 relationship between a subidiary and its currency, aka one subsidiary only has one base currency
    -- if the above premise no longer holds true, revisit the join condition below
    select

        accounts.account_id,
        accounts.general_rate,
        consolidated_exchange_rates.posting_period_id,
        consolidated_exchange_rates.from_subsidiary_id,
        consolidated_exchange_rates.to_subsidiary_id,

        -- logic on getting actual rate for each account
        case
            when lower(accounts.general_rate) = 'historical' then consolidated_exchange_rates.historical_rate
            when lower(accounts.general_rate) = 'current' then consolidated_exchange_rates.current_rate
            when lower(accounts.general_rate) = 'average' then consolidated_exchange_rates.average_rate
        end as consolidated_exchange_rate

    from accounts
    cross join consolidated_exchange_rates
)

select *
from accounting_xjoined_cer
