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
        custitem_item_category as tem_category,
        custitem_formulation as formulation,
        class as class_id,
        stockdescription as stock_description,
        "DESCRIPTION" as item_description,
        displayname as display_name,
        manufacturer,
        "LOCATION" as item_location,

        --sku
        itemid as org_sku,
        regexp_replace(itemid, '^x', '') as sku,
        custitem_interal_sku as internal_sku,
        custitem_internal_sku_description as internal_sku_description,
        custitem_open_farm_new_sku as new_sku,
        case when itemid like 'x%' then 2 else 1 end as sku_order,

        --cost
        cost,
        costestimate as cost_estimate,
        costestimatetype as cost_estimate_type,
        costingmethod as costing_method,
        costingmethoddisplay as costing_method_display,
        averagecost__de as averagecost__de,
        averagecost__fl as averagecost__fl,
        fxcost as fx_cost,
        tracklandedcost as track_landed_cost,

        --account
        assetaccount as asset_account,
        custreturnvarianceaccount as custreturn_variance_account,
        expenseaccount as expense_account,
        {# gainlossaccount as gainloss_account, #}
        incomeaccount as income_account,
        billexchratevarianceacct as bill_exchrate_variance_acct,
        billpricevarianceacct as bill_pricevariance_acct,
        billqtyvarianceacct as bill_qtyvariance_acct,

        --price
        custitem_price_change_approve as price_change_approve,
        custitem_pricing_formulation as pricing_formulation,
        lastpurchaseprice__de as lastpurchaseprice__de,
        lastpurchaseprice__fl as lastpurchaseprice__fl,

        --numeric
        custitemeighty_thousand as eighty_thousand,
        custitem_twohundred_fifty_thousand as two_hundred_fifty_thousand,
        custitem_twohundredthousand as two_hundredthousand,
        custitem_hundredtwentythousand as hundred_twentythousand,
        custitem_fourty_thousand as fourty_thousand,

        --atlas
        custitem_atlas_hi as atlas_hi,
        custitem_atlas_product_group as atlas_product_group,
        custitem_atlas_ti as atlas_ti,

        --weight
        custitem_gross_weight as gross_weight,
        custitem_net_weight as net_weight,
        "WEIGHT" as item_weight,
        weightunit as weight_unit_id,
        weightunits as weight_units,

        --unit & quantity
        purchaseunit as purchase_unit,
        saleunit as sale_unit,
        stockunit as stock_unit,
        consumptionunit as consumption_unit,
        totalquantityonhand__de as total_quantity_on_hand__de,
        totalquantityonhand__fl as total_quantity_on_hand__fl,

        --type
        itemtype as item_type,
        subtype as sub_type,
        unitstype as units_type,

        --boolean
        custitem_aln_1_auto_numbered = 'T' as is_aln_1_auto_numbered,
        custitem_atlas_approved = 'T' as is_atlas_approved,
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
        custitem_hj_tc_autopackquantity as hj_tc_autopackquantity,
        custitem_lot_assembly_upc as lot_assembly_upc,
        custitem_mhi_of_preferred_vendor as mhi_of_preferred_vendor,
        custitem_mhi_open_farm_omult as mhi_omult,
        custitem_open_farm_fulfillment_loc as fulfillment_loc,
        custitem_open_farm_legacy_item as legacy_item,
        custitem_open_farm_pallet_in_ea as pallet_in_ea,
        custitem_of_legacy_item_link as legacy_item_link,

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
