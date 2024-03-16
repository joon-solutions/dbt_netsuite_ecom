with items as (
    select * from {{ ref('stg_netsuite__items') }}
),

item_units as (
    select * from {{ ref('stg_netsuite__item_units') }}
),

classifications as (
    select * from {{ ref('stg_netsuite__classifications') }}
),

rename_recast as (

    select
        items.item_id,
        items.sku,
        items.display_name,
        items.item_description,
        items.item_type,
        items.is_inactive,
        items.cost as unit_cost,
        items.item_weight,
        items.org_sku,
        item_units.name as weight_unit,
        first_value(classifications.class_id) over (partition by items.sku order by items.sku_order) as class_id,
        first_value(classifications.parent_id) over (partition by items.sku order by items.sku_order) as parent_class_id,
        first_value(classifications.class_full_name) over (partition by items.sku order by items.sku_order) as class_full_name,
        first_value(classifications.species) over (partition by items.sku order by items.sku_order) as species,
        first_value(classifications.category) over (partition by items.sku order by items.sku_order) as category,
        first_value(classifications.sub_category) over (partition by items.sku order by items.sku_order) as sub_category,
        first_value(classifications.formula) over (partition by items.sku order by items.sku_order) as formula

    from items
    left join classifications
        on items.class_id = classifications.class_id
    left join item_units
        on items.weight_unit_id = item_units.item_unit_id
),

budget_mapping as (
    select
        rename_recast.*,
        case
            -- these are exception, budgeted on category level id
            when (rename_recast.species = ' Mixed Species ' and rename_recast.category = ' Bone Broth ') -- Finished Goods : Mixed Species : Bone Broth
                then 1173
            when (rename_recast.species = ' Dog ' and rename_recast.category = ' Supplements ') -- Finished Goods : Dog : Supplements
                then 1089
            -- majority of the cases, use class on sub-category level id
            else rename_recast.parent_class_id
        end
        as budgeted_class_id,
        -- convert weight to lbs
        {{ lbs_conversion('rename_recast.','item_weight','weight_unit') }}
    from rename_recast

),

final as (
    select

        budget_mapping.*,
        classifications.class_full_name as budgeted_class_name

    from budget_mapping
    left join classifications
        on budget_mapping.budgeted_class_id = classifications.class_id
)

select * from final
