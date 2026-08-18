with source as (
    select * from {{ source('crm', 'order_items') }}
),

cleaned as (
    select
        id as order_item_id,
        order_id,
        nullif(trim(product_code), '') as product_code,
        nullif(trim(product_name), '') as product_name,
        quantity,
        unit_price,
        discount_pct,
        line_total,
        service_start_date

    from source
    where id is not null
    qualify row_number() over (
        partition by id
        order by id
    ) = 1
)

select * from cleaned