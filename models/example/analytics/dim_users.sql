with users as (

    select * from {{ ref('stg_users') }}

)

select
    u.user_id,
    u.full_name,
    u.first_name,
    u.last_name,
    u.title,
    u.role,
    u.department,
    u.email,
    u.manager_id,
    m.full_name as manager_name,
    u.hire_date,
    u.is_active
from users u
left join users m on u.manager_id = m.user_id