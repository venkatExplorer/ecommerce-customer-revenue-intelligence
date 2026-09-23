import pandas as pd
from pathlib import Path

# ============================================================
# 1. PATHS
# ============================================================

# Project root directory
# This works when the script is inside:
# project/python/data_cleaning.py

PROJECT_ROOT = Path(__file__).resolve().parent.parent

RAW_PATH = PROJECT_ROOT / "data" / "raw"
PROCESSED_PATH = PROJECT_ROOT / "data" / "processed"

# Create directories automatically if they don't exist
RAW_PATH.mkdir(parents=True, exist_ok=True)
PROCESSED_PATH.mkdir(parents=True, exist_ok=True)

# ============================================================
# 2. LOAD REFERENCE TABLES
# ============================================================
orders = pd.read_csv(PROCESSED_PATH / "orders_clean.csv")
customers = pd.read_csv(RAW_PATH / "customers.csv")
products = pd.read_csv(RAW_PATH / "products.csv")
sellers = pd.read_csv(RAW_PATH / "sellers.csv")

# ============================================================
# 3. CLEAN CUSTOMERS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING CUSTOMERS")
print("=" * 60)
customers = customers.drop_duplicates()
customers["signup_date"] = pd.to_datetime(customers["signup_date"], errors="coerce")
customers["city"] = customers["city"].fillna("Unknown")

duplicate_customer_ids = customers[customers["customer_id"].duplicated()].shape[0]
invalid_age = ((customers["age"] < 18) | (customers["age"] > 100)).sum()
invalid_signup_dates = customers[customers["signup_date"].isnull()].shape[0]

print("Rows:", len(customers))
print("Duplicate customer IDs:", duplicate_customer_ids)
print("Invalid ages:", invalid_age)
print("Invalid signup dates:", invalid_signup_dates)
print("Missing values:", customers.isnull().sum().sum())

customers.to_csv(PROCESSED_PATH / "customers_clean.csv", index=False)

# ============================================================
# 4. CLEAN PRODUCTS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING PRODUCTS")
print("=" * 60)
products = products.drop_duplicates()
products["category"] = products["category"].str.strip().str.title()
products["sub_category"] = products["sub_category"].str.strip().str.title()
products["brand"] = products["brand"].str.strip()
products["launch_date"] = pd.to_datetime(products["launch_date"], errors="coerce")

invalid_prices = ((products["price"] <= 0) | (products["cost"] <= 0)).sum()
invalid_cost_relationship = (products["cost"] > products["price"]).sum()
duplicate_product_ids = products[products["product_id"].duplicated()].shape[0]

print("Rows:", len(products))
print("Duplicate product IDs:", duplicate_product_ids)
print("Invalid prices/costs:", invalid_prices)
print("Cost > price:", invalid_cost_relationship)
print("Missing values:", products.isnull().sum().sum())

products.to_csv(PROCESSED_PATH / "products_clean.csv", index=False)

# ============================================================
# 5. CLEAN SELLERS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING SELLERS")
print("=" * 60)
sellers = sellers.drop_duplicates()
sellers["joining_date"] = pd.to_datetime(sellers["joining_date"], errors="coerce")

invalid_ratings = ((sellers["seller_rating"] < 0) | (sellers["seller_rating"] > 5)).sum()
duplicate_seller_ids = sellers[sellers["seller_id"].duplicated()].shape[0]

print("Rows:", len(sellers))
print("Duplicate seller IDs:", duplicate_seller_ids)
print("Invalid ratings:", invalid_ratings)
print("Missing values:", sellers.isnull().sum().sum())

sellers.to_csv(PROCESSED_PATH / "sellers_clean.csv", index=False)

# ============================================================
# 6. CLEAN ORDER ITEMS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING ORDER ITEMS")
print("=" * 60)
order_items = pd.read_csv(RAW_PATH / "order_items.csv")
order_items = order_items.drop_duplicates()

invalid_quantity = (order_items["quantity"] <= 0).sum()
invalid_unit_price = (order_items["unit_price"] <= 0).sum()
order_items["line_amount"] = order_items["quantity"] * order_items["unit_price"]

valid_order_ids = set(orders["order_id"])
invalid_order_references = (~order_items["order_id"].isin(valid_order_ids)).sum()

valid_product_ids = set(products["product_id"])
invalid_product_references = (~order_items["product_id"].isin(valid_product_ids)).sum()

print("Rows:", len(order_items))
print("Duplicate rows:", order_items.duplicated().sum())
print("Invalid quantities:", invalid_quantity)
print("Invalid unit prices:", invalid_unit_price)
print("Invalid order IDs:", invalid_order_references)
print("Invalid product IDs:", invalid_product_references)

order_items.to_csv(PROCESSED_PATH / "order_items_clean.csv", index=False)

# ============================================================
# 7. CLEAN PAYMENTS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING PAYMENTS")
print("=" * 60)
payments = pd.read_csv(RAW_PATH / "payments.csv")
payments = payments.drop_duplicates()
payments["payment_date"] = pd.to_datetime(payments["payment_date"], errors="coerce")

valid_payment_statuses = ["Successful", "Failed", "Refunded"]
valid_payment_methods = ["UPI", "Credit Card", "Debit Card", "COD", "Net Banking"]

invalid_status = (~payments["payment_status"].isin(valid_payment_statuses)).sum()
invalid_method = (~payments["payment_method"].isin(valid_payment_methods)).sum()
negative_amount = (payments["amount"] < 0).sum()
invalid_payment_orders = (~payments["order_id"].isin(valid_order_ids)).sum()

print("Rows:", len(payments))
print("Invalid statuses:", invalid_status)
print("Invalid payment methods:", invalid_method)
print("Negative amounts:", negative_amount)
print("Invalid order IDs:", invalid_payment_orders)

payments.to_csv(PROCESSED_PATH / "payments_clean.csv", index=False)

# ============================================================
# 8. CLEAN DELIVERIES
# ============================================================
print("\n" + "=" * 60)
print("CLEANING DELIVERIES")
print("=" * 60)
deliveries = pd.read_csv(RAW_PATH / "deliveries.csv")
deliveries = deliveries.drop_duplicates()

for column in ["shipped_date", "expected_date", "actual_date"]:
    deliveries[column] = pd.to_datetime(deliveries[column], errors="coerce")

valid_delivery_statuses = ["Not Shipped", "On Time", "Late"]
invalid_delivery_status = (~deliveries["delivery_status"].isin(valid_delivery_statuses)).sum()
invalid_delivery_orders = (~deliveries["order_id"].isin(valid_order_ids)).sum()
invalid_delivery_dates = (deliveries["actual_date"] < deliveries["shipped_date"]).sum()

print("Rows:", len(deliveries))
print("Invalid statuses:", invalid_delivery_status)
print("Invalid order IDs:", invalid_delivery_orders)
print("Actual date before shipped date:", invalid_delivery_dates)

deliveries.to_csv(PROCESSED_PATH / "deliveries_clean.csv", index=False)

# ============================================================
# 9. CLEAN RETURNS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING RETURNS")
print("=" * 60)
returns = pd.read_csv(RAW_PATH / "returns.csv")
returns = returns.drop_duplicates()
returns["return_date"] = pd.to_datetime(returns["return_date"], errors="coerce")

valid_return_statuses = ["Approved", "Rejected"]
valid_return_reasons = ["Damaged", "Wrong Product", "Quality Issue", "Changed Mind", "Late Delivery"]

invalid_return_status = (~returns["return_status"].isin(valid_return_statuses)).sum()
invalid_return_reason = (~returns["return_reason"].isin(valid_return_reasons)).sum()
negative_refund = (returns["refund_amount"] < 0).sum()
invalid_return_orders = (~returns["order_id"].isin(valid_order_ids)).sum()
invalid_return_products = (~returns["product_id"].isin(valid_product_ids)).sum()

print("Rows:", len(returns))
print("Invalid return statuses:", invalid_return_status)
print("Invalid return reasons:", invalid_return_reason)
print("Negative refunds:", negative_refund)
print("Invalid order IDs:", invalid_return_orders)
print("Invalid product IDs:", invalid_return_products)

returns.to_csv(PROCESSED_PATH / "returns_clean.csv", index=False)

# ============================================================
# 10. CLEAN MARKETING CAMPAIGNS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING MARKETING CAMPAIGNS")
print("=" * 60)
marketing = pd.read_csv(RAW_PATH / "marketing_campaigns.csv")
marketing = marketing.drop_duplicates()
marketing["start_date"] = pd.to_datetime(marketing["start_date"], errors="coerce")
marketing["end_date"] = pd.to_datetime(marketing["end_date"], errors="coerce")

invalid_campaign_dates = (marketing["end_date"] < marketing["start_date"]).sum()
negative_budget = (marketing["budget"] < 0).sum()
negative_spend = (marketing["spend"] < 0).sum()

print("Rows:", len(marketing))
print("Invalid campaign dates:", invalid_campaign_dates)
print("Negative budgets:", negative_budget)
print("Negative spend:", negative_spend)
print("Missing values:", marketing.isnull().sum().sum())

marketing.to_csv(PROCESSED_PATH / "marketing_campaigns_clean.csv", index=False)

# ============================================================
# 11. CLEAN CUSTOMER SESSIONS
# ============================================================
print("\n" + "=" * 60)
print("CLEANING CUSTOMER SESSIONS")
print("=" * 60)
sessions = pd.read_csv(RAW_PATH / "customer_sessions.csv")
sessions = sessions.drop_duplicates()
sessions["session_date"] = pd.to_datetime(sessions["session_date"], errors="coerce")

invalid_pages = (sessions["pages_viewed"] < 0).sum()
invalid_products_viewed = (sessions["products_viewed"] < 0).sum()

valid_yes_no = ["Yes", "No"]
invalid_cart = (~sessions["added_to_cart"].isin(valid_yes_no)).sum()
invalid_checkout = (~sessions["checkout_started"].isin(valid_yes_no)).sum()
invalid_purchase = (~sessions["purchase_completed"].isin(valid_yes_no)).sum()

valid_customer_ids = set(customers["customer_id"])
invalid_session_customers = (~sessions["customer_id"].isin(valid_customer_ids)).sum()

print("Rows:", len(sessions))
print("Invalid pages viewed:", invalid_pages)
print("Invalid products viewed:", invalid_products_viewed)
print("Invalid cart values:", invalid_cart)
print("Invalid checkout values:", invalid_checkout)
print("Invalid purchase values:", invalid_purchase)
print("Invalid customer IDs:", invalid_session_customers)

sessions.to_csv(PROCESSED_PATH / "customer_sessions_clean.csv", index=False)

# ============================================================
# 12. FINAL SUMMARY
# ============================================================
print("\n" + "=" * 60)
print("CLEANING COMPLETED")
print("=" * 60)
print("Clean files saved to:", PROCESSED_PATH.resolve())
