Select concat(teamid,Lpad((cast(ROW_NUMBER() OVER (PARTITION BY teamid
    ORDER BY subscription_term_start_date ASC) as varchar)),7,'0'))                  as subscriptionid,
       teamid,
       subscription_term_start_date,
       subscription_term_end_date,
       total_subscription_price,
       case when subscription_term_end_date >= now() then true else false end as ActiveSub,
       date_part('year', subscription_term_end_date) -
       date_part('year', subscription_term_start_date)                        as YearsSubscribed,
       date_part('year', subscription_term_end_date)                          as SubscriptionEndYear,
       case
           when ROW_NUMBER() OVER (PARTITION BY teamid
               ORDER BY subscription_term_start_date ASC) > 1 then 'Renewal'
           else null end                                                      AS "RenewalFlag",
       case
           when ROW_NUMBER() OVER (PARTITION BY teamid
               ORDER BY subscription_term_start_date ASC) > 1 then 1
           else 0 end                                                         AS "Renewalcount",
       ROW_NUMBER() OVER (PARTITION BY teamid
           ORDER BY subscription_term_start_date ASC)                         AS "SubscriptionNumber",
       1                                                                      as subscriptioncount,
       LAG(total_subscription_price)
       OVER (PARTITION by teamid ORDER BY subscription_term_start_date ASC)   as "PreviousSubCost"
from {{ source('dev_schema', 'subscriptions') }}