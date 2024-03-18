with budget as (
    select * from {{ ref('stg_netsuite__budget') }}
),

accounts as (
    select * from {{ ref('stg_netsuite__accounts') }}
),

subsidiaries as (
    select * from {{ ref('stg_netsuite__subsidiaries') }}
),

accounting_periods as (
    select * from {{ ref('stg_netsuite__accounting_periods') }}
),

currencies as (
    select * from {{ ref('stg_netsuite__currencies') }}
),

departments as (
    select * from {{ ref('stg_netsuite__departments') }}
),

classifications as (
    select * from {{ ref('stg_netsuite__classifications') }}
),

budgets_machines as (
    select * from {{ ref('stg_netsuite__budgets_machines') }}
),

final as (
    -- join with other 'dim' stg models to extract necessary fields
    select

        budgets_machines.budget_id,
        budgets_machines.accounting_period_id,
        budget.subsidiary_id,
        budget.account_id,
        budget.currency_id,
        budget.customer_id,
        budget.class_id,
        budget.department_id,

        subsidiaries.name as subsidiary_name,
        accounts.account_name,
        accounts.account_type = 'Income' as is_sales_account,
        accounts.account_type = 'COGS' as is_cogs_account,

        currencies.currency_symbol as currency,
        departments.department_full_name,

        accounting_periods.started_at as budget_month,
        budgets_machines.amount as amount_monthly,

        classifications.class_name

    from budgets_machines
    left join budget
        on budgets_machines.budget_id = budget.budget_id
    left join subsidiaries
        on budget.subsidiary_id = subsidiaries.subsidiary_id
    left join accounts
        on budget.account_id = accounts.account_id
    left join currencies
        on budget.currency_id = currencies.currency_id
    left join departments
        on budget.department_id = departments.department_id
    left join classifications
        on budget.class_id = classifications.class_id
    left join accounting_periods
        on budgets_machines.accounting_period_id = accounting_periods.accounting_period_id
)


select * from final
