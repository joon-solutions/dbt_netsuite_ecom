with source as (
    select * from {{ source('netsuite','subsidiary') }}
),

renamed as (
    select
        --id
        id as subsidiary_id,
        currency as currency_id,
        parent as parent_id,
        representingcustomer as representing_customer_id,
        representingvendor as representing_vendor_id,
        fiscalcalendar as fiscal_calendar_id,

        --time
        lastmodifieddate as last_modified_at,

        --subsidiary information
        email,
        fullname as full_name,
        legalname as legal_name,
        name,

        --address
        mainaddress as main_address,
        returnaddress as return_address_id,
        shippingaddress as shipping_address_id,
        dropdownstate as drop_down_state,
        country,
        edition,
        state,

        --other
        custrecord_psg_lc_test_mode,
        url,
        showsubsidiaryname = 'T' as is_show_subsidiary_name,
        iselimination = 'T' as is_elimination,
        isinactive = 'T' as is_inactive

        --,system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
