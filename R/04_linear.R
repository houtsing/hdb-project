# 04_linear.R
# Owner: B   Tasks: B4-B6 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# B4. Benchmark multiple linear regression (core predictors)
# Record: coefficients, adjusted R-squared, CV RMSE

# B5. Amenities test (core + amenity block), compare CV RMSE

# B6. Cluster label in place of town dummies (needs 05_clustering.R output)
library(readxl)
HDB_data = read_excel("data/HDB_data_2021_sample.xlsx")
