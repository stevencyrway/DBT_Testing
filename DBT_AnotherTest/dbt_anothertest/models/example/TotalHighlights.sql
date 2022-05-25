-- Use the `ref` function to select from other models

Select count(distinct authuser) as NumberOfUsers, team, week, sum(highlights_created) as TotalHighlights
from highlights
group by team, week
