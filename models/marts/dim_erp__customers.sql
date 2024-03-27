with customers as (
    select * from {{ ref('stg_netsuite__customers') }}
),

customer_subsidiary_relationship as (
    select * from {{ ref('stg_netsuite__customer_subsidiary_relationship') }}
    where is_primary_sub
),

entities as (
    select * from {{ ref('stg_netsuite__entities') }}
),

entity_address as (
    select * from {{ ref('stg_netsuite__entity_address') }}
),

entity_status as (
    select * from {{ ref('stg_netsuite__entity_status') }}
),

departments as (
    select * from {{ ref('stg_netsuite__departments') }}
),

-- adjust base on parent company
adjusted_customers as (
    select
        customers.*,
        coalesce(c2.company_name, customers.company_name) as parent_name,
        case
            when customers.parent_id is null --parent company itself
                then customers.default_billing_address_id
            else customers.default_shipping_address_id
        end as default_address_id
    from customers
    left join customers as c2
        on customers.parent_id = c2.customer_id
),

final as (
    select
        adjusted_customers.customer_id,
        adjusted_customers.external_id,
        adjusted_customers.company_name,
        adjusted_customers.parent_id,
        adjusted_customers.parent_name,
        departments.department_full_name,
        adjusted_customers.phone,
        adjusted_customers.email,
        adjusted_customers.default_address_id,
        entity_address.addr_text,
        entity_address.state,
        entity_address.country,
        entity_status.entity_status,
        entities.entity_id,
        replace(customer_subsidiary_relationship.subsidiary_name, entities.entity_name || ' - ', '') as primary_subsidiary_name

    from adjusted_customers
    left join entities
        on adjusted_customers.customer_id = entities.customer_id
    left join customer_subsidiary_relationship
        on entities.entity_id = customer_subsidiary_relationship.entity_id
    left join entity_address
        on adjusted_customers.default_address_id = entity_address.record_owner_id
    left join entity_status
        on adjusted_customers.entity_status_id = entity_status.entity_status_id
    left join departments
        on adjusted_customers.customer_department_id = departments.department_id
)

select * from final
