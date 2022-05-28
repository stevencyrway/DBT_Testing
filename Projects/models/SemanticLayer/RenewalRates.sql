-- 2. Overall renewal rate for basketball teams compared to other sports
with renewals as (Select
       sport,
       SUM("Renewalcount") as TotalRenewals,
       sUM(subscriptioncount) as TotalSubcriptions
from {{ref('SubscriptionsProd')}}
         join {{ref('teams')}} on teams.teamid = "SubscriptionsProd".teamid
group by  sport)

Select sport,
       cast(sum(TotalRenewals)/sum(TotalSubcriptions) as decimal(9,2)) as RenewalRate,
       concat(cast((sum(TotalRenewals)/sum(TotalSubcriptions))*100 as decimal(9,2)),' ','%') as RenewalRateFormatted
           from renewals
group by sport
order by RenewalRate desc
