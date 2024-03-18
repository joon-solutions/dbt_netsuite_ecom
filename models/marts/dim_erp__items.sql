with items as (
    select * from {{ ref('stg_netsuite__items') }}
),

item_units as (
    select * from {{ ref('stg_netsuite__item_units') }}
),

classifications as (
    select * from {{ ref('stg_netsuite__classifications') }}
),

final as (

    select
        items.item_id,
        items.sku,
        items.item_display_name,
        items.item_description,
        items.item_type,
        items.is_inactive,
        items.cost as unit_cost,
        items.item_weight,
        items.org_sku,
        item_units.name as weight_unit,
        first_value(classifications.class_id) over (partition by items.sku order by items.sku_order) as class_id,
        first_value(classifications.parent_id) over (partition by items.sku order by items.sku_order) as parent_class_id,
        first_value(classifications.class_name) over (partition by items.sku order by items.sku_order) as class_name

    from items
    left join classifications
        on items.class_id = classifications.class_id
    left join item_units
        on items.weight_unit_id = item_units.item_unit_id
)

select
    *,
    {{ lbs_conversion('','item_weight','weight_unit') }}

from final
