with source as (select * from {{ source('crm', 'events') }}),
cleaned as (
    select
        id                          as event_id,
        owner_id,
        who_id,
        what_id,
        nullif(trim(subject), '')   as subject,
        nullif(trim(type), '')      as event_type,
        nullif(trim(location), '')  as location,
        start_datetime,
        end_datetime,
        is_all_day_event,
        created_date
    from source
    where id is not null
    qualify row_number() over (partition by id order by created_date desc) = 1
)
select * from cleaned