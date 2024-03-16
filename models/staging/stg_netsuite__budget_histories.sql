with source as (
    select * from {{ source('netsuite','budgetsmachine') }}
),

renamed as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['budget','period']) }} as unique_id,
        budget as budget_id,
        period as period_id,
        amount

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
    qualify row_number() over (partition by unique_id order by _sdc_received_at desc) = 1
)

select * from renamed
