with source as (select * from {{ source('crm', 'tasks') }}),
cleaned as (
    select
        id                          as task_id,
        owner_id,
        who_id,
        what_id,
        nullif(trim(subject), '')   as subject,
        nullif(trim(type), '')      as task_type,
        nullif(trim(status), '')     as status,
        nullif(trim(priority), '')   as priority,
        activity_date,
        is_closed,
        created_date
    from source
    where id is not null
    qualify row_number() over (partition by id order by created_date desc) = 1
)
select * from cleaned