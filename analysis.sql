-- Marketing Funnel Performance Analysis
-- Tool: Google BigQuery
-- Author: Michael Oswald

-- Description: Channel performance evaluation including conversion rate, CAC, and ROAS

WITH base AS (
  SELECT *
  FROM `.marketing_analysis.marketing_funnel`
),

revenue_by_source AS (
  SELECT 
    Source,
    SUM(Revenue) AS total_revenue,
    SUM(Ad_Spend) AS total_spend,
    COUNT(DISTINCT CASE WHEN Stage = 'Closed Won' THEN Lead_ID END) AS customers,
    COUNT(DISTINCT Lead_ID) AS total_leads
  FROM base
  GROUP BY Source
)

SELECT 
  Source,
  total_leads,
  customers,
  SAFE_DIVIDE(customers, total_leads) AS conversion_rate,
  total_revenue,
  total_spend,
  SAFE_DIVIDE(total_spend, customers) AS CAC,
  SAFE_DIVIDE(total_revenue, total_spend) AS ROAS
FROM revenue_by_source
ORDER BY ROAS DESC;