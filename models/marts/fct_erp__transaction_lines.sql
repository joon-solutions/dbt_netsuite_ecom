with transactions as (
    select * from {{ ref('stg_netsuite__transactions') }}
),

transaction_accounting_lines as (
    select * from {{ ref('stg_netsuite__transaction_accounting_lines') }}
    where is_posting
),

transaction_lines as (
    select * from {{ ref('stg_netsuite__transaction_lines') }}
    where is_displayed
),

accounts as (
    select * from {{ ref('stg_netsuite__accounts') }}
),

currencies as (
    select * from {{ ref('stg_netsuite__currencies') }}
),

account_types as (
    select * from {{ ref('stg_netsuite__account_types') }}
),

departments as (
    select * from {{ ref('stg_netsuite__departments') }}
),

deleted_records as (
    select * from {{ ref('stg_netsuite__deleted_records') }}
),

final as (
    select
        -- Keys
        transaction_lines.unique_key,
        transaction_lines.transaction_line_id,
        transaction_lines.transaction_id,
        transaction_lines.item_id,
        transaction_accounting_lines.account_id,
        transaction_lines.subsidiary_id,
        transaction_lines.department_id,
        transaction_lines.location_id,

        -- logic confirmed by Finance team on 2023-12-06
        -- fill in customer_id of a Journal Entry transacton with customer_id of its transaction lines
        case
            when current_transactions.transaction_type = 'Journal Entry'
                then transaction_lines.entity_id
            else current_transactions.entity_id
        end as customer_id, -- FK to dim_erp__customers

        parent_transaction.tran_display_name as created_from_transaction,
        parent_transaction.entity_id as created_from_transaction__customer_id, -- FK to dim_erp__customers
        parent_transaction.transaction_date as created_from_transaction__transaction_date,
        parent_transaction.transaction_type as created_from_transaction__transaction_type,

        departments.department_full_name,

        current_transactions.transaction_date,
        current_transactions.transaction_type,
        current_transactions.type_based_document_number as document_number,

        accounts.account_type,
        accounts.account_name,
        accounts.account_type = 'Income' as is_sales_account,
        accounts.account_type = 'COGS' as is_cogs_account,

        -- filtering for reconcilliation with Netsuite report
        transaction_lines.is_displayed,
        transaction_accounting_lines.is_posting,

        -- quantity field(s)
        transaction_lines.quantity___fl as transaction_line_quantity,

        -- amount related fields
        current_transactions.posting_period_id,

        currencies.currency_name,
        --transaction_accounting_lines.amount,
        transaction_accounting_lines.amount_debit,
        transaction_accounting_lines.amount_credit,

        transaction_accounting_lines.exchange_rate,
        div0(transaction_accounting_lines.amount_debit, transaction_accounting_lines.exchange_rate) as amount_debit_foreign,
        div0(transaction_accounting_lines.amount_credit, transaction_accounting_lines.exchange_rate) as amount_credit_foreign,

        --For some accounts, the side will be either on the left (Debit) or right (Credit). This depends on accounting equation Assets = Liabilities + Equity
        --For example, asset, expense account will be on the debit side since they decrease equity of business (drawings)
        --Liabilities and revenue will be on the credit side since they icnrease equity of the business (investments)
        --There're also cases of reverse entries. For example, when customer return an order => revenue will be reduced and on the debit side => net amount will be difference between debit and credit
        --The case when condition whether to put debit or credit first in the equation, which depends on the above principle
        case
            when account_types.is_account_left_side then transaction_accounting_lines.amount_debit - transaction_accounting_lines.amount_credit
            else transaction_accounting_lines.amount_credit - transaction_accounting_lines.amount_debit
        end as amount,
        div0(amount, transaction_accounting_lines.exchange_rate) as amount_foreign

    from transaction_lines
    left join transaction_accounting_lines
        on
            transaction_lines.transaction_line_id = transaction_accounting_lines.transaction_line_id
            and transaction_lines.transaction_id = transaction_accounting_lines.transaction_id
    left join accounts
        on transaction_accounting_lines.account_id = accounts.account_id
    left join departments
        on transaction_lines.department_id = departments.department_id
    left join transactions as current_transactions
        on transaction_lines.transaction_id = current_transactions.transaction_id
    left join transactions as parent_transaction
        on transaction_lines.created_from_id = parent_transaction.transaction_id
    left join currencies
        on current_transactions.currency_id = currencies.currency_id
    left join account_types
        on accounts.account_type = account_types.account_type_id
    where
        true
        and not exists (
            select 1
            from deleted_records
            where
                true
                and current_transactions.transaction_id = deleted_records.record_id
                and current_transactions.record_type = deleted_records.record_type
        )

)

select * from final
