# 04_linear.R
# Owner: B   Tasks: B4-B6 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# B4. Benchmark multiple linear regression (core predictors)
# Record: coefficients, adjusted R-squared, CV RMSE

# B5. Amenities test (core + amenity block), compare CV RMSE

# B6. Cluster label in place of town dummies (needs 05_clustering.R output)
df = HDB_factors
# 1. Clean the test set rows of any unseen factor categories
for(col in colnames(test_factors)) {
  if(is.factor(test_factors[[col]])) {
    train_levels <- levels(train_factors[[col]])
    test_factors <- test_factors[test_factors[[col]] %in% train_levels, ]
  }
}
test_factors <- droplevels(test_factors)
train_factors <- droplevels(train_factors)
# best 11 predictors in lm1
lm1 = lm(resale_price ~ storey_range + Remaining_lease + floor_area_sqm + town + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC, data = train_factors)
summary(lm1)$adj.r.squared
summary

coef_matrix <- summary(lm1)$coefficients #Extract the coefficients matrix from the summary

coef_df <- as.data.frame(coef_matrix) #convert to data frame

colnames(coef_df) <- c("Estimate", "Std_Error", "t_value", "p_value") #rename columns

sorted_coef <- coef_df[order(coef_df$p_value), ] #sort by ascending p-value

#using economic intuition and ascending p-value, choose 11 best predictors

#RMSE calculation
predlm1 = predict(lm1, newdata = test_factors)
real_price = test_factors$resale_price
RMSE = sqrt(mean((real_price - predlm1) ^2))

