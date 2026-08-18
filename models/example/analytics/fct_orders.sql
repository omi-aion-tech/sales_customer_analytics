with orders as (
    select * from {{ ref('stg_orders') }}
),
accounts as (
    select account_id, account_name, industry from {{ ref('stg_accounts') }}
),
users as (
    select user_id, full_name from {{ ref('stg_users') }}
)

select
    o.order_id,
    o.order_number,

    o.account_id,
    o.opportunity_id,
    o.owner_id,

    a.account_name,
    a.industry,
    u.full_name                          as owner_name,

    o.status,
    o.total_amount,
    o.contract_term_months,

    o.effective_date,
    year(o.effective_date)               as effective_year,
    quarter(o.effective_date)            as effective_quarter,
    'Q' || quarter(o.effective_date) || ' ' || year(o.effective_date) as effective_year_quarter,
    o.created_date
from orders o
left join accounts a on o.account_id = a.account_id
left join users    u on o.owner_id   = u.user_id