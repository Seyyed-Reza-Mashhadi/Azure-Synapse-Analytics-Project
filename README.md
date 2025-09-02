<img width="1919" height="500" alt="banner" src="https://github.com/user-attachments/assets/8e49e8dd-418d-418c-bbbb-e9ff81318cdc" />

# ☁️ Azure Synapse Analytics Project  

This project demonstrates how to perform analytics directly in **Azure Synapse Analytics**, using different query engines and compute options.  

Building on the **cleaned Parquet data** produced by the **Azure Data Factory Project**, the focus here is on querying, modeling, and analyzing the data using:  

- **Serverless SQL Pools** (on-demand queries)  
- **Dedicated SQL Pools** (provisioned compute for structured analytics)  
- **Apache Spark Pools** (advanced data exploration & visualization)  

🔗 **Dataset:** The data is available on [Kaggle](https://www.kaggle.com/datasets/155a87ba8d7e92c5896ddc7f3ca3e3fa9c799207ed8dbf9a1cedf2e2e03e3c14). CSV files and processed Parquet outputs were already available in **ADLS**, prepared via pipelines from the [Azure Data Factory Project](https://github.com/Seyyed-Reza-Mashhadi/Azure-Data-Factory-Project).  


## 🎯 Project Goals  

- Showcase how **different Synapse compute engines** (Serverless SQL, Dedicated SQL, Spark) can be applied to the same dataset  
- Demonstrate **end-to-end analytics workflow**: raw data exploration → star schema modeling → BI readiness  
- Highlight **cost-efficient data analysis strategies** in Synapse (when to use serverless vs. dedicated vs. Spark)  
- Enable **seamless Power BI integration** with Synapse for interactive dashboards  
- Provide a **reusable reference architecture** for modern data analytics on Azure  

---

# ⚙️ Step-by-Step Implementation  

## 1️⃣ Azure Resources  

Provisioned within the same resource group:  
- **Azure Data Lake Storage Gen2** → contains raw CSVs + cleaned Parquet outputs  
- **Azure Synapse Analytics** (workspace) with:  
  - **Serverless SQL Pool** → default, on-demand queries  
  - **Dedicated SQL Pool** → provisioned compute, relational schema  
  - **Apache Spark Pool** → notebooks for data exploration & visualization  

<p align="center">
  <img src="https://github.com/user-attachments/assets/7ecaa9df-effd-4269-919a-13101035960a" width="350">
</p>  

## 2️⃣ Serverless SQL Pool  

Serverless SQL is Synapse’s **on-demand query engine** that lets you run **T-SQL queries** directly on files in ADLS without loading them into a database. It is ideal for quick ad-hoc analysis, exploration, and validation of transformed outputs. The advantages of using Serverless SQL pool include:  
- No infrastructure provisioning required  
- Ideal for **exploration & validation** of raw/processed data  
- Can query diverse file formats (CSV, Parquet, JSON) directly  
- Tables are **external tables** (data remains in ADLS; not physically loaded)  
- **Cost Model:** pay only per query (cost-efficient)  
  - ~$5 per TB of data processed  
  - Minimum 10 MB per query (even for smaller files → still very cheap)  
  - Optional: **set query data volume limit** to avoid unexpected costs  

In this project, two example queries are performed using serverless SQL pool:  
- Queried raw CSV directly from ADLS Gen2 to get the total number of cities with sales.  

<p align="center">
  <img src="https://github.com/user-attachments/assets/e27d7e2f-797e-468c-b93c-fa3edffbab8d" width="700">
</p>  

- Queried Parquet files directly from ADLS Gen2 to get the top 5 best selling products.  

<p align="center">
  <img src="https://github.com/user-attachments/assets/fd8d104b-817b-420d-b15a-4832bf08480d" width="700">
</p>  


## 3️⃣ Dedicated SQL Pool  

Dedicated SQL Pool is Synapse’s **provisioned data warehouse** for structured, high-performance analytics using **T-SQL**. Its use cases include:  
- Scalable data warehouse for **BI workloads**  
- Schema-aware integration with **Power BI**  
- High-performance, repeatable queries  
- Tables are **internal tables** (physically stored in the dedicated SQL database)  
- **Distribution Strategies:** Tables can use **hash, round-robin, or replicated distribution** to optimize parallel processing and query performance  
- **Cost Model:** Billed per hour based on **DWUs (Data Warehouse Units)**  
  - Compute billing stops when paused  
  - Storage billed at ~$0.12/GB/month  

In this project, processed **Parquet files** were loaded into the dedicated SQL database using **bulk load**. These files represent **fact and dimension tables** forming a **star schema**. **Primary Keys** were introduced as **metadata** to provide schema clarity for downstream analysis, without enforcing strict constraints, since Synapse Dedicated Pools are designed for **parallel, high-speed analytics**, not strict relational enforcement.  

📸 *[Insert screenshot: dedicated SQL tables with PKs defined]*


## 4️⃣ Apache Spark Pool  

Apache Spark in Synapse enables **data exploration, transformation, and visualization** using **Python / PySpark / ML libraries**. It is ideal for flexible analytics and exploratory data science workloads.  

**Use Cases / Advantages**  
- Flexible data manipulation with **Python / PySpark / ML libraries**  
- Native integration with Synapse workspace for analytics & visualization  
- Suitable for **exploratory data science workloads**  
- Supports reading/writing from **ADLS Gen2**, **Dedicated SQL Pool**, or other external sources  

**Cost Model**  
- Billed per **vCore-hour** while the pool is running  
- Must **stop pool** to avoid charges  
- No persistent storage cost unless explicitly writing outputs  

**Work Done / Examples**  
- Read **Parquet fact (SalesFact)** and **dimension (CustomerDim)** tables from ADLS  
- Performed **joins & aggregations** (e.g., total spending per customer)  
- Plotted **histogram of customer spendings** with median line  

📸 *[Insert screenshot: histogram of customer spendings]*



## 5️⃣ Connection to Power BI  

Two ways of connecting Synapse with Power BI:  
1. **Power BI Desktop** → Connect using server name + credentials  
2. **Power BI Service (Online)** → Link Synapse workspace as a **Linked Service** for managed connectivity  

Validated schema recognition and confirmed readiness for **dashboarding & BI analysis**.  



# 🔄 Synapse vs. ADF  

| Feature              | **Azure Data Factory (ADF)** | **Azure Synapse Analytics** |
|----------------------|-------------------------------|-----------------------------|
| **Primary Focus**    | ETL/ELT (data movement & transformation) | Analytics & data warehousing |
| **Data Handling**    | Ingest, clean, transform data | Query, model, visualize data |
| **Core Strengths**   | Pipelines, data orchestration | Serverless queries, Spark, Dedicated SQL pools |
| **Integration**      | Data prep for downstream use | BI-ready datasets & analysis |
| **Best For**         | Preparing structured data | Exploring & analyzing data |

👉 In short: **ADF = Data Preparation**, **Synapse = Data Analysis**  

---

# 💰 Cost Considerations  

- **Serverless SQL Pool** → ~$5/TB scanned (min 10 MB/query)  
- **Dedicated SQL Pool** → Pay for DWUs (pause to save costs, storage billed separately)  
- **Apache Spark Pool** → Pay for vCore-hours (stop after use)  
- **ADLS Storage** → ~$0.12/GB/month for persisted data  
- ⚠️ **Best Practices:**  
  - Pause/stop compute resources when idle  
  - Partition files for more efficient queries  
  - Use Parquet/Delta instead of CSV for cost + performance  

---

# 🔑 Key Features  

- Queried data directly from ADLS without ETL (Serverless SQL)  
- Built star schema in Dedicated SQL Pool  
- Integrated schema with Power BI for BI readiness  
- Used Apache Spark for aggregations & visualizations  
- Compared Synapse vs. ADF for clear separation of concerns  
- Highlighted cost efficiency across compute options  

---

# 🔁 Related Projects  

📊 **Azure Data Factory Project** → End-to-end ETL pipelines & star schema prep  
📊 **SQL Project** → PostgreSQL analytics on Grocery Sales dataset  
📊 **Power BI Dashboard** → Interactive visual exploration of sales & customer insights  
