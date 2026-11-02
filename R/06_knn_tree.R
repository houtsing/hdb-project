# 06_knn_tree.R
# Owner: C   Tasks: C3-C4 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# C3. kNN regression
# Standardise predictors using training-set means/SDs; choose k by CV
library(ISLR)
library(ROCR)
library(kknn)

knnpred = kknn(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
               + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
               + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,train_factors,test_factors,k=20,kernel="rectangular")
df.loocv=train.kknn(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
                    + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
                    + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,data = train_factors,kmax=100,kernel="rectangular")

# C4. Regression tree
# Grow large tree, prune by CV, record size and top splits
