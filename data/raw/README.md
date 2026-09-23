# Raw Data

This folder represents the raw source data used in the E-Commerce Customer & Revenue Intelligence Platform.

The raw dataset contains the following source tables:

- customers.csv
- products.csv
- sellers.csv
- orders.csv
- order_items.csv
- payments.csv
- deliveries.csv
- returns.csv
- marketing_campaigns.csv
- customer_sessions.csv

## Data Handling

The complete dataset is not stored in this GitHub repository because of dataset size and repository management considerations.

The source data was used for:

- Data cleaning and validation using Python/Pandas
- Loading cleaned data into Google BigQuery
- Transformation using dbt
- Business analysis and dashboard development

The Python cleaning pipeline is available in:

`../.. /python/data_cleaning.py`
