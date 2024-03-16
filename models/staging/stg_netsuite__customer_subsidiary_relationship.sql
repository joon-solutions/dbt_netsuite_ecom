with source as (
    select * from {{ source('netsuite','customersubsidiaryrelationship') }}
),

renamed as (
    select
        --id
        id as customer_subsidiary_relationship_id,
        entity as entity_id,
        lastmodifieddate as last_modified_at,
        primarycurrency as primary_currency_id,
        subsidiary as subsidiary_id,
        name as subsidiary_name,
        balance__de,
        balance__fl,
        depositbalance as deposit_balance,
        unbilledorders as unbilled_orders,
        isprimarysub = 'T' as is_primary_sub

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
    qualify row_number() over (partition by customer_subsidiary_relationship_id order by customer_subsidiary_relationship_id) = 1
)

select * from renamed
