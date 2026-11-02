# 07_pcr.R
# Owner: B   Task: B8 (Week 12)
# Training set only. Details: Week12_tasks_explained.md
library(pls)
set.seed(678349)
nrow(HDB_data) #nrows = 6000
ntrain = 4200#set size of the training sample
tr = sample(1:nrow(HDB_data),ntrain)  
train = HDB_data[tr,]  
test = HDB_data[-tr,] 
# PCA on standardised numeric predictors (scree plot)
data = HDB_data
sum(is.na(data))
data=na.omit(data) 
prall = prcomp(data, scale = TRUE)
# PCR with number of components M chosen by CV
biplot(prall)
prall.s = summary(prall)
scree = prall.s$importance[2,] #only proportion of variance
plot(scree, main = "Bond Yields Scree Plot", xlab = "Principal Component", 
     ylab = "Proportion of Variance Explained", ylim = c(0,1), type = 'b', cex = .8)
scree

head(data)
set.seed(678349)
pcr.fit2 = pcr(resale_price ~. ,data = train, scale=TRUE, validation="CV")
validationplot(pcr.fit2, val.type = "MSEP", legendpos = "topright")
MSEPtable=MSEP(pcr.fit2,estimate = "adjCV",ncomp=1:145)
best = which.min(MSEPtable$val)

pcr.pred=predict(pcr.fit2, newdata= test, ncomp= best)
RMSE2 = sqrt(mean((test$resale_price - pcr.pred)^2))

histav=lm(resale_price~1, data=train)
predlm=predict.lm(histav, newdata=test)
RMSE_histav = sqrt(mean((test$resale_price-predlm)^2))
