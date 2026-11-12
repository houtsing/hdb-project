df = HDB_factors
# Clean the test set rows of any unseen factor categories
# best 11 predictors in lm1
lm1 = lm(resale_price ~ storey_range + Remaining_lease + floor_area_sqm + town 
         + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
         + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC, data = train_factors)
summary(lm1)$adj.r.squared
summary(lm1)

lm_base = lm(resale_price ~., data = train_factors)
coef_matrix = summary(lm_base)$coefficients #Extract the coefficients matrix from the summary
coef_df = as.data.frame(coef_matrix) #convert to data frame
colnames(coef_df) = c("Estimate", "Std_Error", "t_value", "p_value") #rename columns
sorted_coef = coef_df[order(coef_df$p_value), ] #sort by ascending p-value

#using economic intuition and ascending p-value, choose 11 best predictors

#RMSE calculation
predlm1 = predict(lm1, newdata = test_factors)
real_price = test_factors$resale_price
RMSE = sqrt(mean((real_price - predlm1) ^2))

#RMSE is 51.24.
