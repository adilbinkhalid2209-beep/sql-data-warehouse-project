# Data Dictionary For Gold Layer

## Overview

The Gold Layer is the business-level data presentation to support and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---
**1. gold.dim_customers**
 - **Purpose:** Stores customer details with demograhic and geographic data.
 - **Columns:**
| Column Name | Data Type | Description |
:---:
| product_key | INT       | Surrogate key uniquely indentifying each product record in the product dimension table.
