with source as (
    select * from {{ source('netsuite','transactionline') }}
),

renamed as (
    select
        --id
        uniquekey as unique_key,
        id as transaction_line_id,
        category as category_id,
        class as class_id,
        entity as entity_id,
        transaction as transaction_id,
        item as item_id,
        subsidiary as subsidiary_id,
        department as department_id,
        location as location_id,
        transferorderitemlineid as transfer_order_item_line_id,

        --time
        actualshipdate as actualship_at,
        closedate as closed_at,
        expectedshipdate as expected_ship_at,
        linelastmodifieddate as line_last_modified_at,
        requesteddate as requested_date,
        memo,
        cleareddate as cleared_date,
        amortizationenddate as amortization_end_date,
        amortizstartdate as amortiz_start_date,
        productionenddate as production_end_date,
        productionstartdate as production_start_date,
        expectedreceiptdate as expected_receipt_date,

        --transaction line infor
        createdfrom as created_from_id,
        expenseaccount as expense_account,
        accountinglinetype as accounting_line_type,

        --price & quantity
        price,
        units,

        --quantity
        quantityallocated as quantity_allocated,
        quantitybackordered as quantity_backordered,
        quantitybilled as quantity_billed,
        quantitycommitted as quantity_committed,
        quantitypacked as quantity_packed,
        quantitypicked as quantity_picked,
        quantityrejected as quantity_rejected,
        quantityshiprecv as quantity_shiprecv,
        bomquantity as bom_quantity,

        quantitydemandallocated as quantity_demand_allocated,
        quantitypacked__de as quantity_packed__de,
        quantitypicked__de as quantity_picked__de,
        quantityshiprecv__de as quantity_ship_recv__de,
        quantity__de as quantity___de,
        quantity__fl as quantity___fl,

        --bill
        billofmaterials as bill_of_materials,
        billofmaterialsrevision as bill_of_materials_revision,
        billvariancestatus as bill_variance_status,

        --item
        itemtype as item_type,
        itemsource as item_source,
        isbillable = 'T' as is_billable,
        isclosed = 'T' as is_closed,
        cleared = 'T' as is_cleared,
        dropship = 'T' as is_dropship,
        eliminate = 'T' as is_eliminate,
        fulfillable = 'T' as is_fulfillable,
        hasfulfillableitems = 'T' as has_fulfillable_items,
        isscrap = 'T' as is_scrap,

        --cost
        costestimate as cost_estimate,
        costestimaterate__de as cost_estimaterate__de,
        costestimatetype as cost_estimate_type,
        blandedcost = 'T' as is_blanded_cost,
        landedcostperline = 'T' as is_landed_cost_per_line,

        --rate
        rateamount__fl as rate_amount__fl,
        ratepercent as rate_percent,
        rate__fl,
        rate__de,
        rateamount__de as rate_amount__de,

        --est
        estgrossprofit as est_gross_profit,
        estgrossprofitpercent__de as est_gross_profit_percent__de,
        costestimaterate__fl as cost_estimate_rate__fl,

        --assembly
        assembly,
        assemblyunits,
        assemblycomponent = 'T' as is_assembly_component,

        --boolean
        iscogs = 'T' as is_cogs,
        iscustomglline = 'T' as is_customgl_line,
        isfreezefirmallocation = 'T' as is_freeze_firm_allocation,
        isfullyshipped = 'T' as is_fully_shipped,
        isfxvariance = 'T' as is_fx_variance,
        isinventoryaffecting = 'T' as is_inventory_affecting,
        isrevrectransaction = 'T' as is_revrec_transaction,
        isallocatefirminvtonly = 'T' as is_allocatefirminvtonly,
        specialorder = 'T' as is_special_order,
        taxline = 'T' as is_tax_line,
        oldcommitmentfirm = 'T' as is_old_commitment_firm,
        transactiondiscount = 'T' as is_transaction_discount,
        mainline = 'T' as is_main_line,
        matchbilltoreceipt = 'T' as is_match_bill_to_receipt,
        commitmentfirm = 'T' as is_commitment_firm,
        donotdisplayline = 'F' as is_displayed,
        excludefrompredictiverisk = 'T' as is_exclude_fromp_redictive_risk,
        kitcomponent = 'T' as is_kit_component,

        --amount
        netamount as net_amount,
        foreignamount as foreign_amount,
        debitforeignamount as debit_foreign_amount,
        creditforeignamount as credit_foreign_amount,
        fxamountlinked as fx_amount_linked,

        foreignamountpaid as foreign_amount_paid,
        foreignamountunpaid as foreign_amount_unpaid,
        foreignpaymentamountunused as foreign_payment_amount_unused,
        foreignpaymentamountused as foreign_payment_amount_used,

        --other
        cseg_channel as cseg_channel_id,
        cseg_geography as cseg_geography_id,
        allocationalert as allocation_alert,
        dayslate as days_late,
        documentnumber as document_number,

        inventoryreportinglocation as inventory_reporting_location_id,
        orderallocationstrategy as orderal_location_strategy_id,
        kitmemberof as kit_member_of,
        linesequencenumber as line_sequence_number,
        processedbyrevcommit as processed_by_rev_commit,

        transactionlinetype as transaction_line_type,
        amortizationsched as amortization_sched,
        orderpriority as order_priority,
        paymentmethod as payment_method,
        buildvariance as build_variance,
        componentyield as component_yield,
        createoutsourcedwo as create_out_sourced_wo

        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
