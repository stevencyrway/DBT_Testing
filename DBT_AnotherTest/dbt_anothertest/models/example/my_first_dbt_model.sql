/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

--{{ config(materialized='table') }}

--Uploads aggregated to Team, Time, Metrics
With uploadscte as (Select uploads.teamid,
                           date_trunc('week', uploads.week) as week,
                           count(distinct uploads.userid)   as UploadUsers,
                           count(distinct uploads.videoid)  as TotalVideos,
                           sum(uploads.uploads)             as TotalUploads
                    from uploads
                    group by teamid, week),

--Views aggregated to Team, Time, Role, Metrics
     viewscte as (Select teamid,
                         date_trunc('week', week) as week,
                         role,
                         sum(video_views)         as TotalViews,
                         count(distinct userid)   as ViewsUsers
                  from views
                  group by teamid, week, role),

     highlightscte as (Select team,
                              date_trunc('week', week) as week,
                              count(distinct authuser) as HighlightUsers,
                              sum(highlights_created)  as TotalHighlights
                       from highlights
                       group by team, week),

     teamsandsubscriptions as (
         Select subscription_term_start_date,
                subscription_term_end_date,
                case when subscription_term_end_date >= now() then true else false end as ActiveSub,
                date_part('year', subscription_term_end_date) -
                date_part('year', subscription_term_start_date)                        as YearsSubscribed,
                date_part('year', subscription_term_end_date)                          as SubscriptionEndYear,
                total_subscription_price,
                subscriptions.teamid,
                sport,
                gender,
                org_type
         from subscriptions
                  join teams on teams.teamid = subscriptions.teamid)

Select *
from teamsandsubscriptions


Select uploadscte.teamid,
       uploadscte.week,
       UploadUsers,
       TotalVideos,
       TotalUploads,
       role,
       TotalViews,
       ViewsUsers,
       HighlightUsers,
       TotalHighlights
from uploadscte
         join highlightscte on uploadscte.teamid = team
    and highlightscte.week = uploadscte.week
         join viewscte on viewscte.teamid = uploadscte.teamid
    and viewscte.week = uploadscte.week;



where teamid = '05d633dc55970d41eb179df9cecd8e4b'



/*
    Uncomment the line below to remove records with null `id` values
*/

-- 1. How many actions (and of what type) a team took during their subscription term
-- 2. Overall renewal rate for basketball teams compared to other sports
-- 3. How far into a subscription term does it typically take a team to get five distinct athletes
-- watching video
-- 4. Identify teams with a drop in year-over-year video views that are within 45 days of their
-- renewal date