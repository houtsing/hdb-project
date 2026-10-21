# 04_linear.R
# Owner: B   Tasks: B4-B6 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# B4. Benchmark multiple linear regression (core predictors)
# Record: coefficients, adjusted R-squared, CV RMSE

# B5. Amenities test (core + amenity block), compare CV RMSE

# B6. Cluster label in place of town dummies (needs 05_clustering.R output)
library(readxl)
HDB_data = read_excel("data/HDB_data_2021_sample.xlsx")


lm1 <- lm (resale_price ~ Remaining_lease+floor_area_sqm+max_floor_lvl
           +total_dwelling_units+Dist_nearest_mall+Dist_nearest_station
           +Dist_nearest_primary_school+Dist_nearest_secondary_school, data = train)
summary(lm1)

lm2 <- lm (resale_price ~ Remaining_lease+floor_area_sqm+max_floor_lvl
           +total_dwelling_units+Dist_nearest_mall+Dist_nearest_station
           +Dist_nearest_primary_school+Dist_nearest_secondary_school+month_Feb
           +month_Mar+month_Apr+month_May, data = train)
summary(lm2)
