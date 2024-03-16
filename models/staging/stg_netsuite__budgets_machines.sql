with source as (
    select * from {{ source('netsuite','budgetsmachine') }}
),

renamed as (
    select
        budget as budget_id,
        period as accounting_period_id,
        amount

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
    qualify row_number() over(partition by budget_id, accounting_period_id order by amount asc) = 1
)

select * from renamed
