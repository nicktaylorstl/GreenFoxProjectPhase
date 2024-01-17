WITH SOURCE AS (SELECT
    EXTRACT(MONTH FROM created_at_datetime_utc) as month,
    CASE
        WHEN EXTRACT(MONTH FROM created_at_datetime_utc) BETWEEN 1 AND 3 THEN 1
        WHEN EXTRACT(MONTH FROM created_at_datetime_utc) BETWEEN 4 AND 6 THEN 2
        WHEN EXTRACT(MONTH FROM created_at_datetime_utc) BETWEEN 7 AND 9 THEN 3
        WHEN EXTRACT(MONTH FROM created_at_datetime_utc) BETWEEN 10 AND 12 THEN 4
    END as quarter,
    EXTRACT(YEAR FROM created_at_datetime_utc) as year,
    organization_name,
    repository_account,
    repository_name,
    COUNT(DISTINCT event_id) as event_count,
    COUNT(DISTINCT user_id) as user_count,
    COUNT(DISTINCT CASE WHEN type = "IssuesEvent" THEN event_id END) AS issues_count,
    COUNT(DISTINCT CASE WHEN type = "MemberEvent" THEN event_id END) AS member_count,
    COUNT(DISTINCT CASE WHEN type = "CreateEvent" THEN event_id END) AS create_count,
    COUNT(DISTINCT CASE WHEN type = "PublicEvent" THEN event_id END) AS public_count,
    COUNT(DISTINCT CASE WHEN type = "DeleteEvent" THEN event_id END) AS delete_count,
    COUNT(DISTINCT CASE WHEN type = "PullRequestEvent" THEN event_id END) AS pr_count,
    COUNT(DISTINCT CASE WHEN type = "WatchEvent" THEN event_id END) AS watch_count,
    COUNT(DISTINCT CASE WHEN type = "ForkEvent" THEN event_id END) AS fork_count,
    COUNT(DISTINCT CASE WHEN type = "PushEvent" THEN event_id END) AS push_count,
    COUNT(DISTINCT CASE WHEN type = "GollumEvent" THEN event_id END) AS gollum_count,
    COUNT(DISTINCT CASE WHEN type = "CommitCommentEvent" THEN event_id END) AS commit_comment_count,
    COUNT(DISTINCT event_id) as total_event_count
FROM {{ ref('dim_github') }}
GROUP BY repository_name, repository_account, organization_name, month, quarter, year)
SELECT
   {{ dbt_utils.generate_surrogate_key(['month','repository_name']) }} as _pk,
   CASE
        WHEN month = 1 THEN '2022-01-01'
        WHEN month = 2 THEN '2022-02-01'
        WHEN month = 3 THEN '2022-03-01'
        WHEN month = 4 THEN '2022-04-01'
        WHEN month = 5 THEN '2022-05-01'
        WHEN month = 6 THEN '2022-06-01'
        WHEN month = 7 THEN '2022-07-01'
        WHEN month = 8 THEN '2022-08-01'
        WHEN month = 9 THEN '2022-09-01'
        WHEN month = 10 THEN '2022-10-01'
        WHEN month = 11 THEN '2022-11-01'
        WHEN month = 12 THEN '2022-12-01'
    END AS first_day_of_period,        
    *

FROM source    
ORDER BY month, repository_name

