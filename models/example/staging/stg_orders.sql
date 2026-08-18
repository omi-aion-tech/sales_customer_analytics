with source as (select * from {{ source('crm', 'orders') }}),
cleaned as (
    select
        id                              as order_id,
        account_id,
        opportunity_id,
        owner_id,
        nullif(trim(order_number), '')  as order_number,
        nullif(trim(status), '')        as status,
        effective_date,
        total_amount,
        contract_term_months,
        created_date
    from source
    where id is not null
    qualify row_number() over (partition by id order by created_date desc) = 1
)
select * from cleaned