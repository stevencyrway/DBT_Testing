--Uploads aggregated to Team, Time, Metrics
With uploadscte as (Select uploads.teamid,
                           date_trunc('week', uploads.week) as week,
                            'Total Videos' as actiontype,
                            null as role,
                           count(distinct uploads.userid)   as Userscount,
                           count(distinct uploads.videoid)  as Actioncount
                    from {{ref('uploads')}}
                    group by teamid, week),

    videoscte as (Select uploads.teamid,
                           date_trunc('week', uploads.week) as week,
                            'video uploads' as actiontype,
                            null as role,
                           count(distinct uploads.userid)   as Userscount,
                           sum(uploads.uploads)             as Actioncount
                    from {{ref('uploads')}}
                    group by teamid, week),

     viewscte as (Select teamid,
                         date_trunc('week', week) as week,
                        'video views' as actiontype,
                         role,
                         count(distinct userid)   as usercount,
                         sum(video_views)         as actioncount
                  from {{ref('views')}}
                  group by teamid, week, role),

     highlightscte as (Select team,
                              date_trunc('week', week) as week,
                            'highlights' as actiontype,
                             null as role,
                              count(distinct authuser) as usercount,
                              sum(highlights_created)  as Actioncount
                       from {{ref('highlights')}}
                       group by team, week)

Select * from viewscte

union all
--Views aggregated to Team, Time, Role, Metrics
Select * from uploadscte

union  all

Select * from highlightscte