with leads as (
    select * from {{ ref('stg_leads') }}
),
users as (
    select user_id, full_name from {{ ref('stg_users') }}
)

select
    l.lead_id,
    l.first_name,
    l.last_name,
    l.first_name || ' ' || l.last_name           as full_name,
    l.company,
    l.email,
    l.phone,
    l.status,
    l.lead_source,

    l.owner_id,
    u.full_name                                  as owner_name,

    l.is_converted,
    l.converted_account_id,
    l.converted_opportunity_id,

    l.created_date,
    year(l.created_date)                         as created_year,
    quarter(l.created_date)                      as created_quarter,
    'Q' || quarter(l.created_date) || ' ' || year(l.created_date) as created_year_quarter
from leads l
left join users u on l.owner_id = u.user_id