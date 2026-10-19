# 01_import_clean.R
# Owner: A   Tasks: A1-A4 (Week 10)
# Creates the cleaned data and the train/test split that every later script uses.
# Details: Week10_tasks_explained.md
rm(list = ls())

# A1. Import data
# Read data/HDB_data_2021_sample.xlsx (relative path, not /Users/...)

# A2. Data checks
# Missing values, impossible values, outliers
# Rescale resale_price to $000s

# A3. Fix dummy coding
# Drop one base level per dummy group (month, town, flat_type, flat_model, storey)
# Use town OR postal_2digits, not both
# Merge overlapping storey_range bands

# A4. Train/test split
# set.seed() before splitting; 80/20
# Objects other scripts rely on: train, test
