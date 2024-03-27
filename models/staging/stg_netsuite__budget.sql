with source as (
    select * from {{ source('netsuite','budgets') }}
),

renamed as (
    select
        id as budget_id,
        customer as customer_id,
        department as department_id,
        subsidiary as subsidiary_id,

        currency as currency_id,
        class as class_id,

        account as account_id,
        accountingbook as accountingbook_id,

        item as item_id,
        category as category_id,
        location as location_id,

        year as year_id,

        total as amount

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
