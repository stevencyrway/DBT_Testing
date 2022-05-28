-- 3. How far into a subscription term does it typically take a team to get five distinct athletes
-- watching video

with viewoverstime as (select teams.teamid,
                              "SubscriptionNumber",
                              min(subscription_term_start_date)                                                                   as subStartDate,
                              subscription_term_start_date,
                              subscription_term_end_date,
                              week,
                              sum(usercount)
                              over (partition by teams.teamid order by week asc rows between unbounded preceding and current row) as athleteusertotal
                       from {{ref('SubscriptionsProd')}}
                                join {{ref('teams')}} on teams.teamid = "SubscriptionsProd".teamid
                                join {{ref('TeamActions')}} on "TeamActions".teamid = teams.teamid
                                and week >= subscription_term_start_date and week <= subscription_term_end_date
                       where role = 'Athlete'
                         and actiontype = 'video views'
                       group by teams.teamid, "SubscriptionNumber", subscription_term_start_date,
                                subscription_term_end_date, week, usercount
                       order by week asc),

     avgdaysto5users as (Select teamid,
                                case
                                    when athleteusertotal = 5
                                        then extract(day from (subStartDate - week)) end daysto5users,
                                week,
                                subStartDate,
                                athleteusertotal
                         from viewoverstime)

Select concat('about', ' ', cast(avg(daysto5users) as integer), ' ', 'days to 5 users')
from avgdaysto5users
where daysto5users is not null
