
<h1 align="center">☁️ Azure Synapse Analytics Project</h1>  
<img width="1919" height="500" alt="banner" src="https://github.com/user-attachments/assets/8e49e8dd-418d-418c-bbbb-e9ff81318cdc" />
  
## 🧩 About Project
This project is a hands-on exploration of **Azure Synapse Analytics**, demonstrating how to leverage its integrated analytics service to perform everything from ad-hoc data exploration to building a structured data warehouse. By applying different Synapse engines—**Serverless SQL**, **Dedicated SQL**, and **Spark**—to the same dataset, it provides a clear framework for choosing the right tool based on cost, performance, and use-case requirements.

🔗 **Dataset:** Grocery sales transactions sourced from [Kaggle](https://www.kaggle.com/datasets/155a87ba8d7e92c5896ddc7f3ca3e3fa9c799207ed8dbf9a1cedf2e2e03e3c14), stored in **Azure Data Lake Gen2 (ADLS)** as both raw CSVs and cleaned Parquet files processed by a previous [Azure Data Factory pipeline](https://github.com/Seyyed-Reza-Mashhadi/Azure-Data-Factory-Project).  


## 🎯 Project Goals  

- **Compare Synapse Engines:** Showcase the distinct roles of Serverless SQL (ad-hoc querying), Dedicated SQL (modeled warehousing), and Spark (exploration/visualization) within a single analytics workflow.
- **Implement an Analytics Pipeline:** Progress from raw data exploration to a optimized star schema data model, ready for business intelligence.
- **Optimize for Cost & Performance:** Highlight cost-efficient strategies (e.g., serverless for exploration, pausing dedicated pools) and performance optimizations like Round-robin distribution and Columnstore indexes.
- **Enable BI Integration:** Connect Synapse SQL pools to Power BI, demonstrating a seamless path from data lake to dashboard.
- **Provide a Reference Architecture:** Document a reusable, scalable pattern for modern analytics on Microsoft Azure.

## ⚙️ Step-by-Step Implementation  

### 1️⃣ Azure Resources  

The following resources were provisioned within the same resource group to build this analytics solution:
- **Azure Data Lake Storage Gen2**:  The foundational storage layer containing all raw and processed data files.  
- **Azure Synapse Analytics Workspace**: The integrated analytics service containing:  
  - A **Serverless SQL Pool** for on-demand querying.
  - A **Dedicated SQL Pool** (data warehouse) for modeled data.
  - An **Apache Spark Pool** for data engineering and data science tasks.

<p align="center">
  <img src="https://github.com/user-attachments/assets/7ecaa9df-effd-4269-919a-13101035960a" width="300">
</p>  

### 2️⃣  Explore & Validate: Serverless SQL Pool  

Serverless SQL is Synapse’s **on-demand query engine** that lets you run SQL queries directly on files in **ADLS Gen2** without loading them into a database. It is ideal for **quick ad-hoc analysis** and validation of transformed outputs. Serverless SQL Pool features include:  
- No infrastructure provisioning required  
- Ideal for exploration & validation of raw/processed data  
- Can query diverse file formats (CSV, Parquet, JSON) directly  
- **Cost Model:** pay only per query (cost-efficient)  
  - ~$5 per TB of data processed  
  - A minimum of 10 MB of data processed is charged per query, even if the underlying file is only 1 KB. Note that the equivalent cost for 10MB is only $0.00005.  

#### **Query Raw Data**

In this project, two example queries for raw data are illustrated using serverless SQL pool:  

- Queried Parquet files directly from ADLS Gen2 to get the top 5 most expensive "durable" products [[View SQL File](https://github.com/Seyyed-Reza-Mashhadi/Azure-Synapse-Analytics-Project/blob/main/SQL%20files/0_Direct_Query_parquet.sql)]

<p align="center">
  <img src="https://github.com/user-attachments/assets/fd8d104b-817b-420d-b15a-4832bf08480d" width="700">
</p>  

- Queried raw CSV directly from ADLS Gen2 to get the total number of cities with sales [[View SQL File](https://github.com/Seyyed-Reza-Mashhadi/Azure-Synapse-Analytics-Project/blob/main/SQL%20files/0_Direct_Query_csv.sql)]  
    

<p align="center">
  <img src="https://github.com/user-attachments/assets/e27d7e2f-797e-468c-b93c-fa3edffbab8d" width="700">
</p>  


#### **Query External Tables**

Serverless SQL pool also supports **external tables**, which are metadata definitions inside the database that point to files in ADLS.  
Key points about external tables:  
- The data itself remains in ADLS; the table only stores schema and location metadata  
- Allows querying raw or processed data as if it were a normal table in SQL  
- Useful for consistent queries, schema enforcement, and integration with views or downstream pipelines  
- Tables in serverless SQL pool are external by default (this is the opposite of dedicated SQL pool where tables are internal and data is physically stored in the database)  

Here is an example showing a query result using the serverless SQL pool for calculating the total revenue generated by different product categories [[View SQL File](https://github.com/Seyyed-Reza-Mashhadi/Azure-Synapse-Analytics-Project/blob/main/SQL%20files/1_Serverless_Query_1.sql)]. 

<p align="center">
  <img src="https://github.com/user-attachments/assets/5aa2a39d-8212-498b-98a2-2e4a25a70bb0" width="700">
</p>  

**⚡Quick Visualization in Synapse:**

Synapse provides some basic plotting options (bar charts, line charts, pie charts, etc.) that can be used for quick visualization of query results. These are useful for rapid validation and exploration, though more advanced analysis and dashboards are typically built in Power BI or using Apache Spark notebooks.


### 3️⃣ Model & Serve: Dedicated SQL Pool 

Dedicated SQL Pool is **Synapse’s provisioned data warehouse** for structured, high-performance analytics using **T-SQL**. Dedicated SQL Pool features include:  
- Scalable data warehouse for BI workloads 
- Schema-aware integration with Power BI 
- High-performance, repeatable queries  
- Tables are **internal tables** (physically stored in the dedicated SQL database)  
- **Distribution Strategies:** Tables can use **hash, round-robin, or replicated distribution** to optimize parallel processing and query performance  
- **Cost Model:** Billed per hour based on **DWUs (Data Warehouse Units)**  
  - Compute billing stops when paused  
  - Storage billed at ~$0.12/GB/month  

In this project, processed **Parquet files** were loaded into the dedicated SQL database using **bulk load**. To optimize performance, the tables in the database were created with **Round-robin distribution** (ensuring even data spread across compute nodes), and a **Clustered Columnstore Index (CCI)** was applied by default, providing high compression and efficient analytical query execution on large datasets. **Primary Keys** were added as **metadata** after loading, to provide schema clarity for downstream analysis (e.g., Power BI), without enforcing strict constraints, since Synapse Dedicated Pools are designed for **parallel, high-speed analytics**, not strict relational enforcement.

**Query Example**
- Example of a T-SQL query to get the top 5 best-selling products (i.e., products with highest generated revenue) [[View SQL File](https://github.com/Seyyed-Reza-Mashhadi/Azure-Synapse-Analytics-Project/blob/main/SQL%20files/2_Dedicated_Query_2.sql)]

<br>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e1296dd9-35a1-464a-85e1-d78325dfec55" width="700">
</p>  


### 4️⃣ Analyze & Visualize: Apache Spark Pool  

Apache Spark in Synapse enables **data exploration, transformation, and visualization** using **Python / PySpark / ML libraries**. It is ideal for flexible analytics and exploratory data science workloads. Apache Spark features include:  
- Flexible data manipulation with **Python / PySpark / ML libraries**  
- Native integration with Synapse workspace for analytics & visualization  
- Suitable for **exploratory data science workloads**  
- Supports reading/writing from **ADLS Gen2**, **Dedicated SQL Pool**, or other external sources
- Spark notebooks can also be **integrated into Synapse pipelines** for scheduled or automated data processing, similar to Azure Data Factory pipelines.
- **Cost Model:** Billed per vCore-hour while the pool is running  
  - Must stop pool to avoid charges when not in use  
  - No persistent storage cost unless explicitly writing outputs  

**Example**
Understanding customer spending distribution is crucial for identifying VIP customers and tailoring marketing strategies. The following analysis calculates the total spend per customer and visualizes its distribution to reveal patterns that would be difficult to see in a table. This is performed using a [[PySpark notebook](https://github.com/Seyyed-Reza-Mashhadi/Azure-Synapse-Analytics-Project/blob/main/Notebook_CustomersSpending.ipynb)] via the following steps:

- Read `FactSales` and `DimCustomers` parquet files from ADLS container.
- Perform proper joins & aggregations to calculate total spending per customer and store results in a dataframe.
- Calculate the median value of customer spending.
- Generate the histogram of customer spendings using matplotlib.pyplot, with the median indicated by a dashed line.


<p align="center">
  <img src="https://github.com/user-attachments/assets/45d2c131-1e6c-467b-afca-6940970d5ba8" width="900">
</p>  

### 5️⃣ Connection to Power BI  

There are two ways of connecting **Azure Synapse** with **Power BI**:  

- **Power BI Desktop** → Connect using server name + credentials.  
- **Power BI Service (Online)** → Link Synapse workspace as a Linked Service for managed connectivity.  


⚠️ **Note:** In this project, we focused on Synapse itself and did not perform any dashboarding or reporting beyond connecting the Synapse SQL Pools to Power BI. For full dashboards, reporting, and visualization examples, please refer to the Related Projects section below.

  
## 💰 Cost Considerations  
### 📋 Overview
Here is an overview of the cost models for core Synapse services.
<table>
  <tr>
    <th width="25%" align="center">Resource</th>
    <th width="30%" align="center">Cost Model</th>
    <th width="45%" align="center">Key Cost-Saving Tip</th>
  </tr>
  <tr>
    <td align="center"><b>Serverless SQL Pool</b></td>
    <td align="center">~$5 per TB processed</td>
    <td align="center">Use Cost Control limits; query partitioned Parquet/Delta files (if possible).</td>
  </tr>
  <tr>
    <td align="center"><b>Dedicated SQL Pool</b></td>
    <td align="center">DWU-hours (compute) + Storage (~$0.12/GB/month)</td>
    <td align="center">Pause compute when not in use.</td>
  </tr>
  <tr>
    <td align="center"><b>Apache Spark Pool</b></td>
    <td align="center">vCore-hours</td>
    <td align="center">Stop the pool when not in use.</td>
  </tr>
</table>


### 📋 General Recommendations
- When using Serverless SQL Pool, **partition large files** to query only the required portion of data. This reduces the amount of data scanned and lowers costs.
- Use **optimized file formats** such as Parquet or Delta instead of CSV for better performance and lower cost.
- Use the **Cost Control** option to set daily/weekly/yearly limits when using Serverless SQL Pool, preventing accidental overspending due to errors or misconfigured queries.
-  **Pause/stop provisioned compute resources** (Dedicated SQL Pool and Apache Spark) when idle to avoid unnecessary charges.

### 💡 Special Considerations when Connecting to Power BI 

Since cost models differ between **Serverless** and **Dedicated SQL Pools**, careful selection of connection/refresh strategy is important:  

- **Serverless SQL Pool**:  
  - Only **DirectQuery / Live Connection** is available (no import option).  
  - Manual refresh is recommended over automatic refresh to minimize the number of queries, reducing costs.  
<p align="center">
  <img src="https://github.com/user-attachments/assets/8896a4cd-e8e8-4c9e-91d0-288d0cf99411" width="700">
</p>

- **Dedicated SQL Pool**:  
  - Both **Import** and **DirectQuery** options are available.  
  - Importing data is suitable for smaller datasets to improve performance.  
  - Always pause the dedicated SQL pool when not in use to avoid unnecessary compute charges.  

<p align="center">
  <img src="https://github.com/user-attachments/assets/bff93499-494d-4141-b148-974d64beb1a3" width="700">
</p>



## 🔑 Technical Highlights  
This project demonstrates a practical, multi-engine analytics architecture on Azure Synapse, highlighting key skills and design decisions:
- **Multi-Engine Strategy:** Effectively leveraged the right tool for each task: **Serverless SQL** for ad-hoc data exploration, **Dedicated SQL** for high-performance warehousing, and **Spark** for flexible analysis and visualization.
- **Data Warehousing Performance:** Engineered a star schema in Dedicated SQL Pool, applying critical performance optimizations like **Round-robin distribution** and **Clustered Columnstore Indexes (CCI)**.
- **Cost-Optimized Design:** Implemented **cost-control measures** across all services, from pausing Dedicated SQL Pools to using serverless queries for initial validation, demonstrating expertise in Azure's consumption-based model.

➡️ **End-to-End Automation**
This Synapse analytics layer consumes data processed by [Azure Data Factory](https://github.com/Seyyed-Reza-Mashhadi/Azure-Data-Factory-Project). The next step for a complete CI/CD workflow would be to use Synapse Pipelines to automate the execution of these notebooks and SQL scripts, triggered by the arrival of new data. This automation was out of scope for this project, which focuses on analytics techniques using a static, historical dataset.


## 🔁 Related Projects  

These projects explore **the same dataset** using different tools and technologies:

- ☁️ [**Azure Data Factory Project**](https://github.com/Seyyed-Reza-Mashhadi/Azure-Data-Factory-Project): Implements a complete ETL pipeline for data orchestration using Azure Data Factory, ADLS, and Azure SQL Database. 
- 📊 [**Power BI Dashboard**](https://github.com/Seyyed-Reza-Mashhadi/Power-BI-Project_Grocery-Sales): An interactive Power BI report analyzing sales performance, product demand, customer spending, and regional insights.
- 🗄️ [**SQL Project**](https://github.com/Seyyed-Reza-Mashhadi/SQL-Project_Grocery-Sales): Features deep-dive analytical SQL queries in PostgreSQL for revenue trends, customer segmentation, and product performance.


