# main.R
# Reproduces every result in the report, in the order the report presents them.
# How to run: open hdb-project.Rproj in RStudio, then run this whole file
# (Session > Restart R first, so nothing left over from earlier work is used).
# Owner: A (final ordering and clean-session check in tasks A9-A10)

# Packages used across the scripts. Install any missing ones once with
# install.packages(c("readxl", "dplyr", "ggplot2", "kknn", "tree", "rpart",
#                    "pls", "ISLR", "ROCR", "MASS"))
pkgs <- c("readxl", "dplyr", "ggplot2", "kknn", "tree", "rpart",
          "pls", "ISLR", "ROCR", "MASS")
missing_pkgs <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
if (length(missing_pkgs) > 0) {
  stop("Install these packages first: ", paste(missing_pkgs, collapse = ", "))
}

# Section 2: Data (import, checks, dummy coding, train/test split)
# Creates HDB_data, HDB_factors, train_factors/test_factors (factor version)
# and train_pcr/test_pcr (dummy version), all split with set.seed(678349)
source("R/01_import_clean.R")

# Section 4: Models (each fitted on the training set, scored on the test set)
source("R/02_linear.R")       # benchmark MLR with 11 predictors       -> RMSE
source("R/03_clustering.R")   # k-means (k = 3) and hierarchical clustering
source("R/04_knn_tree.R")     # kNN (k by LOOCV), pruned tree, rpart tree -> knnrmse, RMSE_tree, RMSE_rpart
source("R/05_pcr.R")          # PCA scree plot, PCR (M by CV), mean benchmark -> RMSE2, RMSE_histav

# Section 5: Test-set comparison (RMSE in $000s)
results <- data.frame(
  Model = c("Mean of training prices (no predictors)",
            "Linear regression (11 predictors)",
            paste0("kNN regression (k = ", kbest, ")"),
            "Regression tree (tree package, pruned by CV)",
            "Regression tree (rpart, pruned by CV)",
            paste0("PCR (M = ", best - 1, " components)")),
  Test_RMSE = round(c(RMSE_histav, RMSE, knnrmse, RMSE_tree, RMSE_rpart, RMSE2), 2)
)
results <- results[order(results$Test_RMSE), ]
print(results, row.names = FALSE)
