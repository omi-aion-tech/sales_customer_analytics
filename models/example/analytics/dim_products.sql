with order_items as (

    select * from {{ ref('stg_order_items') }}

)

select
    product_code,
    max(product_name) as product_name
from order_items
where product_code is not null
group by product_code