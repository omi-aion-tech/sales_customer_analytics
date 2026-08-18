with contacts as (
    select * from {{ ref('stg_contacts') }}
),
accounts as (
    select account_id, account_name from {{ ref('stg_accounts') }}
),
users as (
    select user_id, full_name from {{ ref('stg_users') }}
)

select
    c.contact_id,
    c.first_name,
    c.last_name,
    c.first_name || ' ' || c.last_name  as full_name,
    c.email,
    c.phone,
    c.title,
    c.department,
    c.lead_source,
    c.account_id,
    a.account_name,
    c.owner_id,
    u.full_name                          as contact_owner_name,
    c.is_primary,
    c.created_date
from contacts c
left join accounts a on c.account_id = a.account_id
left join users   u on c.owner_id   = u.user_id