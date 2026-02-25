CREATE TABLE retail_cleaned (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10,2),
    CustomerID INT,
    Country VARCHAR(100),
    TotalPrice NUMERIC(10,2),
    InvoiceMonth VARCHAR(10),
    CohortMonth VARCHAR(10)
);

-- First purchase date for each customer
SELECT 
    customerid,

    MIN(invoicedate) AS first_purchase_date
FROM retail_cleaned
GROUP BY customerid;

-- Assign cohort month
SELECT
    customerid,
    DATE_TRUNC('month', MIN(invoicedate)) AS cohort_month
FROM retail_cleaned
GROUP BY customerid;

--Calculate Months Since First Purchase
SELECT
    r.customerid,
    DATE_TRUNC('month', r.invoicedate) AS order_month,
    DATE_TRUNC('month', f.first_purchase_date) AS cohort_month,
    EXTRACT(YEAR FROM AGE(r.invoicedate, f.first_purchase_date)) * 12 +
    EXTRACT(MONTH FROM AGE(r.invoicedate, f.first_purchase_date)) AS months_since_first
FROM retail_cleaned r
JOIN (
    SELECT customerid, MIN(invoicedate) AS first_purchase_date
    FROM retail_cleaned
    GROUP BY customerid
) f
ON r.customerid = f.customerid;


--First Purchase (Cohort Month)
SELECT
    customerid,
    DATE_TRUNC('month', MIN(invoicedate)) AS cohort_month
FROM retail_cleaned
GROUP BY customerid;

--Full Cohort Join
SELECT
    r.customerid,
    DATE_TRUNC('month', r.invoicedate) AS invoice_month,
    c.cohort_month,
    
    EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', r.invoicedate), c.cohort_month)) * 12 +
    EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', r.invoicedate), c.cohort_month))
    AS cohort_index

FROM retail_cleaned r
JOIN (
    SELECT
        customerid,
        DATE_TRUNC('month', MIN(invoicedate)) AS cohort_month
    FROM retail_cleaned
    GROUP BY customerid
) c
ON r.customerid = c.customerid;

--Retention Table
--Convert to Retention %
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