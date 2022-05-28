--the main subscription level query
SELECT subscriptionid,
       teams.teamid,
       total_subscription_price,
       "PreviousSubCost",
       activesub,
       yearssubscribed,
       sum("Renewalcount"),
       Max("SubscriptionNumber")                                       as TimesRenewed,
       sport,
       gender,
       org_type,
       sum(case when org_type = 'Youth' then usercount end)            as YouthOrgUsers,
       sum(case when org_type = 'Other' then usercount end)            as OtherOrgUsers,
       sum(case when actiontype = 'highlights' then actioncount end)   as Highlights,
       sum(case when actiontype = 'Total Videos' then actioncount end) as Videos,
       SUM(case when actiontype = 'Total views' then actioncount end)  as Views,
       SUM(case when role = 'Administrator' then usercount end)        as Admins,
       SUM(case when role = 'Athlete' then usercount end)              as Athletes,
       SUM(case when role = 'Coach' then usercount end)                as Coachs,
       min(subscription_term_start_date)                               AS StartDate,
       max(subscription_term_end_date)                                 as EndDate,
       sum(usercount)                                                  as TotalDistinctUsers
from {{ref('SubscriptionsProd')}}
join {{ref('teams')}} on teams.teamid = "SubscriptionsProd".teamid
join {{ref('TeamActions')}} on "TeamActions".teamid = teams.teamid
    AND week >= subscription_term_start_date
    AND week <= subscription_term_end_date
-- where subscriptionid = '0010d7953d20fda16bd4fa363a150cf30000001'
GROUP BY subscriptionid, teams.teamid, total_subscription_price, "PreviousSubCost", activesub, yearssubscribed, sport,
         gender, org_type
order by subscriptionid asc, teams.teamid asc