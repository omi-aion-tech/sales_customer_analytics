with order_items as (
    select * from {{ ref('stg_order_items') }}
),
orders as (
    select order_id, order_number, account_id, owner_id, status, effective_date
    from {{ ref('stg_orders') }}
),
accounts as (
    select account_id, account_name, industry from {{ ref('stg_accounts') }}
),
users as (
    select user_id, full_name from {{ ref('stg_users') }}
)

select
    oi.order_item_id,
    oi.order_id,
    ord.order_number,

    oi.product_code,
    oi.product_name,

    -- account + owner reached THROUGH the order
    ord.account_id,
    a.account_name,
    a.industry,
    ord.owner_id,
    u.full_name                                    as owner_name,
    ord.status                                     as order_status,

    -- measures
    oi.quantity,
    oi.unit_price,
    oi.discount_pct,
    round(oi.quantity * oi.unit_price, 2)          as list_amount,
    round(oi.quantity * oi.unit_price - oi.line_total, 2) as discount_amount,
    oi.line_total                                  as revenue,

    oi.service_start_date,
    ord.effective_date,
    year(ord.effective_date)                       as order_year,
    quarter(ord.effective_date)                    as order_quarter,
    'Q' || quarter(ord.effective_date) || ' ' || year(ord.effective_date) as order_year_quarter
from order_items oi
left join orders   ord on oi.order_id    = ord.order_id
left join accounts a   on ord.account_id = a.account_id
left join users    u   on ord.owner_id   = u.user_id