-- 4. Identify teams with a drop in year-over-year video views that are within 45 days of their
-- renewal date
with videosviewperyear as (
    Select teams.teamid                                                                                   as team,
           min(subscription_term_start_date)                                                              as StartDate,
           max(subscription_term_end_date)                                                                as MaxEndDate,
           "SubscriptionNumber",
           date_trunc('year', week)                                                                       as Year,
           sum(actioncount)                                                                               as videoViews,
           Lead(sum(actioncount))
           OVER (PARTITION by teams.teamid ORDER BY date_trunc('year', week) desc)                        as LastyearViews
    from "SubscriptionsProd"
             join teams on teams.teamid = "SubscriptionsProd".teamid
             join "TeamActions" on "TeamActions".teamid = teams.teamid
        and week >= subscription_term_start_date and week <= subscription_term_end_date
    where actiontype = 'video views'
    group by teams.teamid, "SubscriptionNumber", date_trunc('year', week)
    order by teams.teamid asc, date_trunc('year', week) asc),

     viewsdifference as (Select team,
                                year,
                                VideoViews,
                                LastyearViews,
                                MaxEndDate,
                                sum(videoViews) - sum(LastyearViews) as VideoDifference
                         from videosviewperyear
                         group by team, year, VideoViews, LastyearViews, MaxEndDate)

Select *
from viewsdifference
where VideoDifference < 0

-- from {{ref('SubscriptionsProd')}}
--                                 join {{ref('teams')}} on teams.teamid = "SubscriptionsProd".teamid
--                                 join {{ref('TeamActions')}} on "TeamActions".teamid = teams.teamid
--                                 and week >= subscription_term_start_date and week <= subscription_term_end_date