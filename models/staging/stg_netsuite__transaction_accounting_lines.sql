with source as (
    select * from {{ source('netsuite','transactionaccountingline') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key(['transaction',"'-'",'transactionline']) }} as unique_id,
        transaction as transaction_id,
        transactionline as transaction_line_id,

        lastmodifieddate as last_modified_at,

        account as account_id,
        accountingbook as accounting_book_id,

        --amount,
        amountlinked as amount_linked,
        amountpaid as amount_paid,
        amountunpaid as amount_unpaid,
        netamount as net_amount,
        coalesce(credit,0) as amount_credit,
        coalesce(debit,0) as amount_debit,

        exchangerate__de as exchange_rate__de,
        exchangerate as exchange_rate,
        paymentamountunused as payment_amount_unused,
        paymentamountused as payment_amount_used,
        processedbyrevcommit = 'T' as is_processed_by_revcommit,
        posting = 'T' as is_posting

        --abs(abs(coalesce(debit_amount,0)) - abs(coalesce(credit_amount,0))) as amount


        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
