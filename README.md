# 📊 Customer Retention Cohort Analysis
**End-to-End Data Analytics Project | SQL • Python • Power BI**

---

## 🚀 Project Overview

This project analyzes **customer retention using cohort analysis** to understand how long customers stay active and when churn occurs.

The analysis helps answer an important business question:

> **Are we retaining customers — or simply replacing the ones who leave?**

The workflow simulates a real-world analytics pipeline from **raw transactional data to an executive dashboard**.

---

## 🏗 Project Workflow


Raw Excel Transaction Data
↓
Python Data Cleaning (Pandas)
↓
PostgreSQL Cohort Modeling
↓
Retention Dataset Export (CSV)
↓
Python Retention Analysis
↓
Power BI Executive Dashboard


---

## 🛠 Tech Stack

- **Python** (Pandas, Matplotlib)  
- **PostgreSQL**  
- **Power BI**  
- **Jupyter Notebook**  
- **Git & GitHub**

---

## 🧠 Key Steps

### Data Preparation (Python)

- Removed null `CustomerID`
- Filtered negative quantities
- Converted invoice dates to datetime
- Created `cohort_month`
- Created `cohort_index` (months since first purchase)

**Output dataset**


data/cleaned/retail_cleaned.csv


---

### Cohort Modeling (SQL)

Customer cohorts were generated using PostgreSQL window functions.

```sql
DATE_TRUNC('month', MIN(invoice_date))
OVER (PARTITION BY customer_id)

This produced the final dataset:

cohort_retention.csv
📊 Dashboard Preview

🔍 Key Insights

Month 1 retention: ~68%

Retention falls below 30% by Month 4

Most churn occurs within the first 90 days

Later cohorts show improved long-term retention

📌 Business Insight

Customer retention strategies should focus on early lifecycle engagement (first 90 days) to reduce churn and improve customer lifetime value (CLV).

📂 Repository Structure
customer-retention-cohort-analysis
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── notebooks/
│   ├── data_cleaning.ipynb
│   └── cohort_analysis.ipynb
│
├── sql/
│   └── retention_analysis.sql
│
├── powerbi/
│   └── customer_retention_dashboard.png
│
└── README.md
💡 Skills Demonstrated

Cohort analysis

SQL window functions

Data cleaning with Python

Customer lifecycle analytics

Executive dashboard design

📬 Connect

Open to opportunities in:

Data Analyst

Business Intelligence Analyst

Product Analyst

Let's build insights that drive better decisions.


---