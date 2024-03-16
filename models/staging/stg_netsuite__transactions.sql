with source as (
    select * from {{ source('netsuite','transaction') }}
),

renamed as (
    select
        --id
        id as transaction_id,
        tranid as tran_id,
        externalid as external_id,
        transactionnumber as transaction_number,
        vendor as vendor_id,
        entity as entity_id,
        currency as currency_id,
        postingperiod as posting_period_id,
        --by
        createdby as created_by,
        lastmodifiedby as last_modified_by,

        --time
        createddate as created_at,
        lastmodifieddate as lastmodified_date,
        trandate as transaction_date,
        shipdate as ship_at,
        actualshipdate as actualship_at,
        startdate as start_at,
        duedate as due_at,
        enddate as end_at,
        closedate as close_at,
        nextbilldate as next_bill_date,
        actualproductionenddate as actual_productionend_date,
        actualproductionstartdate as actual_productionstart_date,

        --transaction infor     
        accountbasednumber as account_based_number,
        trandisplayname as tran_display_name,
        typebaseddocumentnumber as type_based_document_number,
        fax,
        email,
        "STATUS" as trasaction_status,
        balsegstatus as balseg_status,
        intercostatus as interco_status,
        customform as custom_form,

        --item
        custbody_bol_total_item_weight as bol_total_item_weight,
        custbody_total_item_weight as total_item_weight,
        custbody_item_line_number as item_line_number,

        --order
        paymenthold as payment_hold,
        custbody_ofp_order_contains_flag as is_order_contains_flag,
        shipcomplete as is_ship_complete,
        paymentmethod as payment_method,
        paymentoption as payment_option,

        --amount
        foreignamountpaid as foreign_amount_paid,
        foreignamountunpaid as foreign_amount_unpaid,
        foreignpaymentamountunused as foreign_payment_amount_unused,
        foreignpaymentamountused as foreign_payment_amount_used,
        foreigntotal as foreign_total,

        --billing & shipping
        billingaddress as billing_address,
        billofmaterials as bill_of_materials,
        billofmaterialsrevision as bill_of_materials_revision,
        shippingaddress as shipping_address,
        transferlocation as transfer_location,
        useitemcostastransfercost as has_use_item_cost_as_transfer_cost,

        --custbody fields
        custbody_atlas_assy_desc,
        custbody_atlas_backhaul,
        custbody_bol_from_address,
        custbody_bol_fullfilment_weight,
        custbody_bol_printed,
        custbody_createdfrom_expensify,
        custbody_mhi_ofp_po_app_amt,
        custbody_mhi_ofp_po_change,
        custbody_mhi_ofp_po_change_amt,
        custbody_mhi_of_ship_from_a1,
        custbody_mhi_of_ship_from_address,
        custbody_mhi_of_ship_from_city,
        custbody_mhi_of_ship_from_state,
        custbody_mhi_of_ship_from_zip,
        custbody_mhi_openfarm_cm_email as is_openfarm_cm_email,
        custbody_of_landed_cost_applied as is_landed_cost_applied,
        custbody_open_farm_autopack_complete as is_autopack_complete,
        custbody_open_farm_confidential_bill as is_confidential_bill,
        custbody_open_farm_deposit_applied as is_deposit_applied,
        custbody_15699_exclude_from_ep_process as is_exclude_from_ep_process,
        custbody_9997_autocash_assertion_field as is_autocash_assertion_field,
        custbody_9997_is_for_ep_dd as is_for_ep_dd,
        custbody_total_gross_weight,
        custbody_total_net_weight,
        custbodyhj_tc_po_status,
        custbodytc_fulfillmentmode,
        custbody_aln_inventory_detail_addn_fld,
        custbody_mfgmob_mmprocessed as is_mm_processed,
        custbody_mfgmob_wobackflush as is_wobackflush,
        custbody_mfgmob_worealtime as is_worealtime,
        custbody_next_approver,
        custbody4,
        custbodyatlas_bolnet,
        custbodyhj_tc_asntype,
        custbodyhj_tc_dccode,
        custbodyhj_tc_storecode,
        custbodyhj_tc_udf1,
        custbodyhj_tc_udf5,
        custbody_11187_pref_entity_bank,

        custbody_atlas_bolpack,
        custbody_atlas_boltotal,
        custbody_atlas_carrier,
        custbody_bol_delivery_instructions,
        custbody_cci_statement,
        custbody_cci_transaction,
        custbody_if_bol_notes,
        custbody_mhi_bill_of_landing,
        custbody_open_farm_linked_po,

        --regulation & document
        cseg_channel,
        cseg_geography,
        incoterm,
        memo,
        nextapprover as next_approver,
        tobeprinted as to_be_printed,
        terms,
        approvalstatus as approval_status,

        --estimate
        estgrossprofit as est_gross_profit,
        totalcostestimate as total_cost_estimate,

        --type
        type, -- captialised & shorten
        abbrevtype as abbrev_type,
        customtype as custom_type,
        journaltype as journal_type,
        recordtype as record_type,
        recordtype as transaction_type,

        --reversal
        reversal,
        reversaldate as reversal_date,
        reversaldefer as reversal_defer,

        --link
        linkedinventorytransfer as linked_inventory_transfer,
        linkedir as linked_ir,
        linkedpo as linked_po,

        --other
        otherrefnum as other_refnum,
        committed,
        daysopen as days_open,
        daysoverduesearch as days_over_due_search,
        employee,
        estgrossprofitpercent__de,
        estgrossprofitpercent__fl,
        exchangerate__de as exchange_rate_de,
        exchangerate__fl as exchange_rate_fl,
        memdoc,
        nexus,
        number,
        outsourcingcharge as outsourcing_charge,
        outsourcingchargeunitprice as outsourcing_charge_unit_price,
        requireddepositdue as required_deposit_due,
        requireddepositpercentage as required_deposit_percentage,
        shipcarrier as ship_carrier,
        tosubsidiary as to_subsidiary,
        source,

        --boolean
        firmed as is_firmed,
        posting = 'T' as is_posting,
        printedpickingticket = 'T' as is_printed_picking_ticket,
        userevenuearrangement = 'T' as is_use_revenue_arrangement,
        void = 'T' as is_void,
        voided = 'T' as is_voided,
        visibletocustomer = 'T' as is_visibletocustomer,
        isactualprodenddateenteredmanually = 'T' as is_actual_prod_end_date_entered_manually,
        isactualprodstartdateenteredmanually = 'T' as is_actual_prod_start_date_entered_manually,
        isfinchrg = 'T' as is_finchrg,
        isreversal = 'T' as is_reversal,
        iswip = 'T' as is_wip,
        ordpicked = 'T' as is_ord_picked,
        ordreceived = 'T' as is_ord_received,
        outsourced = 'T' as is_out_sourced,
        custbody_11724_pay_bank_fees = 'T' as is_pay_bank_fees,
        custbody_9997_is_for_ep_eft = 'T' as is_for_ep_eft,
        custbody_of_payment_remit_sent = 'T' as is_paument_remit_sent,
        billingstatus = 'T' as has_billing_status,
        includeinforecast = 'F' as is_include_in_forecast

        --_class,
        --_type,
        --system
        --_sdc_batched_at,
        --_sdc_extracted_at,
        --_sdc_received_at,
        --_sdc_sequence,
        --_sdc_table_version,

    from source
)

select * from renamed
