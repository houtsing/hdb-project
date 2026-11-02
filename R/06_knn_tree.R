# 06_knn_tree.R
# Owner: C   Tasks: C3-C4 (Week 11)
# Training set only. Details: Week11_tasks_explained.md

# C3. kNN regression
# Standardise predictors using training-set means/SDs; choose k by CV
library(ISLR)
library(ROCR)
library(kknn)

set.seed(678349)
df.loocv=train.kknn(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
                    + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
                    + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,data = train_factors,kmax=100,kernel="rectangular")
kbest=df.loocv$best.parameters$k

knnreg= kknn(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
             + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
             + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,train_factors,test_factors,
             k=kbest,kernel="rectangular")
knnrmse=(mean((test_factors$resale_price-knnreg$fitted.values)^2))^0.5

#knnrmse is 59.49.

# C4. Regression tree
# Grow large tree, prune by CV, record size and top splits
library(tree)
library(MASS)
library(rpart)
library(ROCR)
df = HDB_data

set.seed(678349)

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
text(hdb.tree,col="black",label=c("yval"),cex=.8)
hdb.fit = predict(hdb.tree,newdata= test_factors)
treefit=predict(hdb.tree,newdata=test_factors,type="vector") #prediction on test data
RMSE_tree = sqrt(mean((test_factors$resale_price-treefit)^2))

#RMSE_tree is 79.25.
set.seed(678349)
big.tree = rpart(resale_price~storey_range + Remaining_lease + floor_area_sqm + town 
                 + max_floor_lvl + Dist_nearest_station + flat_model + unique_no_mrt_1km
                 + Dist_CBD + Dist_nearest_GAI_jc + Dist_nearest_CC,
                 method="anova",data=train_factors, minsplit=5,cp=.0005)
length(unique(big.tree$where))
plotcp(big.tree)
bestcp=big.tree$cptable[which.min(big.tree$cptable[,"xerror"]),"CP"]
best.tree = prune(big.tree,cp=bestcp)
plot(best.tree,uniform=TRUE)
text(best.tree,digits=4,use.n=TRUE,fancy=FALSE,bg='lightblue')
treefit2=predict(best.tree,newdata=test_factors,type="vector") 
RMSE_rpart = sqrt(mean((test_factors$resale_price-treefit2)^2))

#RMSE_rpart is 55.43.
