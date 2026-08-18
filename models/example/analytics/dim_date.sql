with spine as (

    -- 1096 days = all of 2023, 2024, 2025
    select dateadd(day, seq4(), '2023-01-01'::date) as date_day
    from table(generator(rowcount => 1096))

)

select
    date_day,
    year(date_day)                                        as year,
    quarter(date_day)                                     as quarter,
    'Q' || quarter(date_day) || ' ' || year(date_day)     as year_quarter,
    month(date_day)                                       as month,
    monthname(date_day)                                   as month_name,
    date_trunc('month', date_day)                         as month_start,
    dayname(date_day)                                     as day_name,
    (dayname(date_day) in ('Sat', 'Sun'))                 as is_weekend
from spine