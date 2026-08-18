with source as (select * from {{ source('crm', 'users') }}),
cleaned as (
    select
        id                              as user_id,
        manager_id,
        nullif(trim(first_name), '')    as first_name,
        nullif(trim(last_name), '')     as last_name,
        nullif(trim(name), '')          as full_name,
        nullif(trim(title), '')         as title,
        nullif(trim(role), '')          as role,
        nullif(trim(department), '')    as department,
        lower(nullif(trim(email), ''))  as email,
        hire_date,
        is_active
    from source
    where id is not null
    qualify row_number() over (partition by id order by hire_date desc nulls last) = 1
)
select * from cleaned