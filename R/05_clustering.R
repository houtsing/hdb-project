# 05_clustering.R
# Owner: A   Task: A6 (Week 11)
# Unsupervised: price is NOT used to form clusters. Details: Week11_tasks_explained.md

# Standardise location and amenity variables
df = HDB_factors
sapply(df, class)
# K-means: set.seed(), elbow plot to choose k
set.seed(678349)
disc2 = c("Remaining_lease", "floor_area_sqm", "max_floor_lvl")
data2 = df[,(names(df) %in% disc2)] 
grp3b = kmeans(scale(data2), centers = 3, nstart = 10)
plot(df$floor_area_sqm, df$resale_price, main = "K = 3", xlab="floor area", ylab="resale price", type="n")
text(df$floor_area_sqm, df$resale_price, labels=df$town, col = rainbow(3)[grp3b$cluster])
# Hierarchical clustering as a cross-check (dendrogram)
set.seed(678349) 
sd.data2 = scale(data2) #standardize the continuous only data extracted earlier
sample_indices = sample(nrow(sd.data2), 20)
sd.data2_sample = sd.data2[sample_indices, ]
dist2_sample = dist(sd.data2_sample)

plot(hclust(dist2_sample, method = "complete"), labels = df$town[sample_indices], 
     main = "Complete Linkage", xlab = "", sub = "")# Profile clusters by average price; create cluster label for B6
