with accounts as (
    select * from {{ ref('stg_accounts') }}
),
users as (
    select user_id, full_name from {{ ref('stg_users') }}
)

select
    a.account_id,
    a.account_name,
    a.account_number,
    a.account_type,
    a.industry,
    a.annual_revenue,
    a.employee_count,
    a.billing_city,
    a.billing_state,
    a.billing_country,
    a.owner_id,
    u.full_name as account_owner_name,
    a.is_active,
    a.created_date
from accounts a
left join users u on a.owner_id = u.user_id