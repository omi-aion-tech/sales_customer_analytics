with source as (

    select * from {{ source('crm', 'leads') }}

),

renamed as (

    select
        c1  as lead_id,
        c2  as first_name,
        c3  as last_name,
        c4  as company,
        c5  as email,
        c6  as phone,
        c7  as status,
        c8  as lead_source,
        c9  as owner_id,
        c10 as created_date,
        c11 as is_converted,
        c12 as converted_account_id,
        c13 as converted_contact_id,
        c14 as converted_opportunity_id
    from source
    where c1 <> 'id'          -- the header row was loaded as data; drop it

),

cleaned as (

    select
        nullif(trim(lead_id), '')                     as lead_id,
        nullif(trim(owner_id), '')                    as owner_id,
        nullif(trim(first_name), '')                  as first_name,
        nullif(trim(last_name), '')                   as last_name,
        nullif(trim(company), '')                     as company,
        lower(nullif(trim(email), ''))                as email,
        nullif(trim(phone), '')                       as phone,
        nullif(trim(status), '')                      as status,
        nullif(trim(lead_source), '')                 as lead_source,

        -- raw table is all TEXT -> cast to real types (safe casts)
        try_to_date(created_date)                     as created_date,
        (lower(trim(is_converted)) = 'true')          as is_converted,

        -- only populated when the lead converted
        nullif(trim(converted_account_id), '')        as converted_account_id,
        nullif(trim(converted_contact_id), '')        as converted_contact_id,
        nullif(trim(converted_opportunity_id), '')    as converted_opportunity_id
    from renamed
    where lead_id is not null

)

select * from cleaned
qualify row_number() over (partition by lead_id order by created_date desc) = 1