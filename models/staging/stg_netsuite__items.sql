with source as (
    select * from {{ source('netsuite','item') }}
),

renamed as (
    select
        --id
        id as item_id,
        externalid as external_id,
        department as department_id,

        --time
        createddate as created_date,
        lastmodifieddate as last_modified_date,

        --item infor
        class as class_id,
        stockdescription as stock_description,
        "DESCRIPTION" as item_description,
        displayname as item_display_name,
        manufacturer,
        "LOCATION" as item_location,

        --sku
        itemid as org_sku,
        regexp_replace(itemid, '^x', '') as sku,
        case when itemid like 'x%' then 2 else 1 end as sku_order,

        --cost
        cost,
        costestimate as cost_estimate,
        costestimatetype as cost_estimate_type,
        costingmethod as costing_method,
        costingmethoddisplay as costing_method_display,
        fxcost as fx_cost,
        tracklandedcost as track_landed_cost,

        --account
        assetaccount as asset_account,
        expenseaccount as expense_account,
        incomeaccount as income_account,
        billexchratevarianceacct as bill_exchrate_variance_acct,
        billpricevarianceacct as bill_price_variance_acct,
        billqtyvarianceacct as bill_quantity_variance_acct,

        --weight
        "WEIGHT" as item_weight,
        weightunit as weight_unit_id,
        weightunits as weight_units,

        --unit & quantity
        purchaseunit as purchase_unit,
        saleunit as sale_unit,
        stockunit as stock_unit,
        consumptionunit as consumption_unit,

        --type
        itemtype as item_type,
        subtype as sub_type,
        unitstype as units_type,

        --boolean
        includechildren = 'T' as is_include_children,
        isdropshipitem = 'T' as is_dropship_item,
        isfulfillable = 'T' as is_fulfillable,
        isinactive = 'T' as is_inactive,
        islotitem = 'T' as is_lot_item,
        isonline = 'T' as is_online,
        isphantom = 'T' as is_phantom,
        isserialitem = 'T' as is_serial_item,
        isspecialorderitem = 'T' as is_special_order_item,
        isspecialworkorderitem = 'T' as is_special_work_order_item,
        shipindividually = 'T' as is_ship_individually,
        generateaccruals = 'T' as generate_accruals,
        enforceminqtyinternally = 'T' as is_enforce_minqty_internally,
        matchbilltoreceipt = 'T' as is_match_bill_to_receipt,
        printitems = 'T' as is_print_items,
        copydescription = 'T' as is_copy_description,
        buildentireassembly = 'T' as is_build_entire_assembly,
        seasonaldemand = 'T' as is_seasonal_demand,
        roundupascomponent = 'T' as is_round_up_as_component,
        usemarginalrates = 'T' as is_use_marginal_rates,

        --other
        atpmethod as atp_method,
        supplyreplenishmentmethod as supply_replenishment_method,
        countryofmanufacture as country_of_manufacture,
        fullname as full_name,

        purchasedescription as purchase_description,
        subsidiary,
        totalvalue as total_value,
        vendorname as vendor_name

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
