with source as (

    select * from {{ source('crm', 'accounts') }}

),

cleaned as (

    select
        id as account_id,
        owner_id,
        nullif(trim(name), '') as account_name,
        nullif(trim(account_number), '') as account_number,
        nullif(trim(type), '') as account_type,
        nullif(trim(industry), '') as industry,
        nullif(trim(billing_city), '') as billing_city,
        nullif(trim(billing_state), '') as billing_state,
        nullif(trim(billing_country), '') as billing_country,
        annual_revenue,
        employee_count,
        created_date,
        is_active

    from source
    where id is not null
    qualify row_number() over (
        partition by id
        order by created_date desc
    ) = 1

)

select * from cleaned