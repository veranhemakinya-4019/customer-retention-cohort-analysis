/*
Customer Retention & Cohort Analysis
Author: Vera Nhema Kinya
Description:
This script calculates monthly cohort retention and retention percentage
using PostgreSQL window functions and CTEs.
*/

WITH cohort_data AS (
    SELECT
        r.customerid,
        DATE_TRUNC('month', r.invoicedate) AS invoice_month,
        DATE_TRUNC('month', MIN(r.invoicedate) OVER (PARTITION BY r.customerid)) AS cohort_month,

        (
            EXTRACT(YEAR FROM AGE(
                DATE_TRUNC('month', r.invoicedate),
                DATE_TRUNC('month', MIN(r.invoicedate) OVER (PARTITION BY r.customerid))
            )) * 12
        )
        +
        (
            EXTRACT(MONTH FROM AGE(
                DATE_TRUNC('month', r.invoicedate),
                DATE_TRUNC('month', MIN(r.invoicedate) OVER (PARTITION BY r.customerid))
            ))
        ) AS cohort_index

    FROM retail_cleaned r
),

retention_counts AS (
    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customerid) AS active_customers
    FROM cohort_data
    GROUP BY cohort_month, cohort_index
),

cohort_size AS (
    SELECT
        cohort_month,
        active_customers AS total_customers
    FROM retention_counts
    WHERE cohort_index = 0
)

SELECT
    r.cohort_month,
    r.cohort_index,
    r.active_customers,
    c.total_customers,
    ROUND(
        r.active_customers::numeric / c.total_customers * 100,
        2
    ) AS retention_percentage
FROM retention_counts r
JOIN cohort_size c
ON r.cohort_month = c.cohort_month
ORDER BY r.cohort_month, r.cohort_index;