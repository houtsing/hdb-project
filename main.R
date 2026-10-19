# main.R
# Reproduces every result in the report, in the order the report presents them.
# How to run: open hdb-project.Rproj in RStudio, then run this whole file.
# Owner: A (final ordering and clean-session check in tasks A9-A10)

# Packages used across the scripts (install once with install.packages())
# library(readxl)

# Section 2: Data (import, cleaning, train/test split)
source("R/01_import_clean.R")

# Shared helpers: cross-validation function and rmse()
source("R/03_cv_helpers.R")

# Section 3: Descriptive statistics
source("R/02_eda.R")

# Section 4: Models (training set only)
source("R/04_linear.R")       # benchmark MLR, amenities test, cluster label
source("R/05_clustering.R")   # k-means / hierarchical clustering
source("R/06_knn_tree.R")     # kNN regression, pruned regression tree
source("R/07_pcr.R")          # PCA, principal components regression

# Section 5: Test-set comparison and listing exercise
source("R/08_test_eval.R")
