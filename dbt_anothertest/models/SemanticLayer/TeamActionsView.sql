-- 1. How many actions (and of what type) a team took during their subscription term

Select teams.teamid,
       "SubscriptionNumber",
       "RenewalFlag",
       actiontype,
       sum(actioncount) as Actioncount
from defaultdb.dev_schema."SubscriptionsProd"
         join defaultdb.dev_schema.teams on teams.teamid = "SubscriptionsProd".teamid
         join defaultdb.dev_schema."TeamActions" on "TeamActions".teamid = teams.teamid
    and week >= subscription_term_start_date and week <= subscription_term_end_date
group by teams.teamid, "SubscriptionNumber", "RenewalFlag", actiontype


-- 2. Overall renewal rate for basketball teams compared to other sports
-- 3. How far into a subscription term does it typically take a team to get five distinct athletes
-- watching video
-- 4. Identify teams with a drop in year-over-year video views that are within 45 days of their
-- renewal date