with source as (select * from {{ source('crm', 'opportunity') }}),
cleaned as (
    select
        id                              as opportunity_id,
        account_id,
        owner_id,
        lead_source_id,
        nullif(trim(name), '')          as opportunity_name,
        nullif(trim(stage_name), '')    as stage_name,
        nullif(trim(lead_source), '')   as lead_source,
        amount,
        probability,
        close_date,
        created_date
    from source
    where id is not null
    qualify row_number() over (partition by id order by created_date desc) = 1
)
select * from cleaned