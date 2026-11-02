# 06_knn_tree.R
# Owner: C   Tasks: C3-C4 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# C3. kNN regression
# Standardise predictors using training-set means/SDs; choose k by CV
library(ISLR)
library(ROCR)
library(kknn)

df.loocv=train.kknn(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
                    + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
                    + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,data = train_factors,kmax=100,kernel="rectangular")
kbest=df.loocv$best.parameters$k
kbest
# C4. Regression tree
# Grow large tree, prune by CV, record size and top splits
library(tree)
library(MASS)
library(rpart)
library(ROCR)
df = HDB_data

temp = tree(resale_price ~ storey_range + Remaining_lease + floor_area_sqm + town 
            + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
            + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC, data = train_factors,
            mindev=0.0001)
length(unique(temp$where))

nrow(temp$frame) 
cv.hdb = cv.tree(temp, , prune.tree)
bestcp = cv.hdb$size[max(which(cv.hdb$dev == min(cv.hdb$dev)))]
hdb.tree=prune.tree(temp,best= bestcp)
plot(hdb.tree,type="uniform")
text(hdb.tree,col="blue",label=c("yval"),cex=.8)
hdb.fit = predict(hdb.tree,newdata= test_factors)

