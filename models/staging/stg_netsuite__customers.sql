with source as (
    select * from {{ source('netsuite','customer') }}
),

renamed as (
    select
        --id
        id as customer_id,
        externalid as external_id,
        custentity_open_farm_customer_department as customer_department_id,
        parent as parent_id,
        entitystatus as entity_status_id,

        --customer infor
        companyname as company_name,
        altname as alternative_name,
        phone,
        entityid as entity_name,
        entitytitle as entity_title,
        fax,
        url as customer_url,

        --time
        dateclosed as closed_at,
        datecreated as created_at,
        lastmodifieddate as last_modified_date,
        lastorderdate as last_order_date,
        lastsaledate as last_sale_date,
        firstorderdate as first_order_date,
        firstsaledate as first_sale_date,

        --email
        email,
        emailpreference as email_preference,
        emailtransactions as email_transactions,

        --shipping
        shipcomplete = 'T' as is_shipcomplete,
        shippingcarrier as shipping_carrier,
        shippingitem as shipping_item,
        custentity_shipping_terms as shipping_terms,

        --default
        defaultallocationstrategy as default_allocation_strategy,
        defaultbillingaddress as default_billing_address_id,
        defaultshippingaddress as default_shipping_address_id,

        --consol
        consolbalancesearch as consol_balance_search,
        consoldaysoverduesearch as consol_days_over_dues_earch,
        consoloverduebalancesearch as consol_overdue_balance_search,
        consolunbilledorderssearch as consol_unbilled_orders_search,

        --boolean
        isautogeneratedrepresentingentity = 'T' as is_auto_generated_representing_entity,
        isbudgetapproved = 'T' as has_budget_approved,
        isinactive = 'T' as is_inactive,
        isperson = 'T' as is_person,
        duplicate = 'T' as is_duplicate,
        faxtransactions = 'T' as is_fax_transactions,
        oncredithold = 'T' as is_on_credit_hold,
        printtransactions = 'T' as is_print_transactions,

        --other
        alcoholrecipienttype as alcohol_recipient_type,
        balancesearch__de as balance_search__de,
        balancesearch__fl as balance_search__fl,
        unbilledorderssearch__de as unbilled_orders_search__de,
        unbilledorderssearch__fl as unbilled_orders_search__fl,

        contactlist as contact_list,
        creditholdoverride as credit_hold_override,
        creditlimit as credit_limit,
        cseg_channel,
        currency,
        cseg_geography,

        pricelevel as price_level,
        probability,
        receivablesaccount as receivables_account,
        representingsubsidiary as representing_subsidiary,
        resalenumber as resale_number,
        searchstage as search_stage,
        terms

    --system
    --_sdc_batched_at,
    --_sdc_extracted_at,
    --_sdc_received_at,
    --_sdc_sequence,
    --_sdc_table_version,

    from source
)

select * from renamed
