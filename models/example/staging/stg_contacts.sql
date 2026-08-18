with source as (select * from {{ source('crm', 'contacts') }}),
cleaned as (
    select
        id                              as contact_id,
        account_id,
        owner_id,
        nullif(trim(first_name), '')    as first_name,
        nullif(trim(last_name), '')     as last_name,
        lower(nullif(trim(email), ''))  as email,
        nullif(trim(phone), '')         as phone,
        nullif(trim(title), '')         as title,
        nullif(trim(department), '')    as department,
        nullif(trim(lead_source), '')   as lead_source,
        created_date,
        is_primary
    from source
    where id is not null
    qualify row_number() over (partition by id order by created_date desc) = 1
)
select * from cleaned