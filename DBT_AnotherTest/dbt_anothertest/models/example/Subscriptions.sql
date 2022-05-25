Select *,
       case when subscription_term_end_date >= now() then true else false end                             as ActiveSub,
       date_part('year', subscription_term_end_date) -
       date_part('year', subscription_term_start_date)                                                    as YearsSubscribed,
       date_part('year', subscription_term_end_date)                                                      as SubscriptionEndYear,
       case
           when ROW_NUMBER() OVER (PARTITION BY teamid
               ORDER BY subscription_term_start_date ASC) > 1 then 'Renewal'
           else null end                                                                                  AS "SubscriptionNumber",
       ROW_NUMBER() OVER (PARTITION BY teamid
           ORDER BY subscription_term_start_date ASC)                                                     AS "SubscriptionNumber",
       LAG(total_subscription_price)
       OVER (PARTITION by teamid ORDER BY subscription_term_start_date ASC)                               as "PreviousSubCost"
from defaultdb.dev_schema.subscriptions