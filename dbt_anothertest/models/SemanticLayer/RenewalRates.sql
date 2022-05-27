Select "SubscriptionsProd".teamid,
       "SubscriptionNumber",
       subscriptionendyear,
       "PreviousSubCost",
       sport,
       "RenewalFlag",
       sum(case when "RenewalFlag" = 'Renewal' then 1 else 0 end)/ count("SubscriptionNumber") as RenewalCount
from defaultdb.dev_schema."SubscriptionsProd"
         join teams on teams.teamid = "SubscriptionsProd".teamid
group by "SubscriptionsProd".teamid, subscriptionendyear, "SubscriptionNumber", "PreviousSubCost", sport, "RenewalFlag"
--
-- Select *
-- from {{ref('SubscriptionsProd')}}


-- 2. Overall renewal rate for basketball teams compared to other sports
-- 3. How far into a subscription term does it typically take a team to get five distinct athletes
-- watching video
-- 4. Identify teams with a drop in year-over-year video views that are within 45 days of their
-- renewal date