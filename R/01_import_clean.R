# 01_import_clean.R
# Owner: A   Tasks: A1-A4 (Week 10)
# Creates the cleaned data and the train/test split that every later script uses.
# Details: Week10_tasks_explained.md
library(readxl) #install.packages('readxl')
library(dplyr)
library(ggplot2)

# A1. Import data
# Read data/HDB_data_2021_sample.xlsx (relative path, not /Users/...)
prices <- read_excel("HDB_resale_prices/HDB_data_2021_sample.xlsx")
dim(prices)
str(prices) ## all data confirmed to be num
head(prices)

# A2. Data checks
# Missing values, impossible values, outliers
# Rescale resale_price to $000s
sum(is.na(prices)) #check for empty values; no empty values present
#drop columns where values are the same for the entire column (eg, year, or cols with all 0)
prices <- prices %>% select(-where(~ n_distinct(.x) == 1)) 

is_dummy <- prices %>% select(where(~ all(.x %in% c(0, 1)))) %>% names()
#no. of non dummy columns
length(setdiff(names(prices), is_dummy)) 
#no. of dummies
length(is_dummy)
prices <- prices %>% mutate(resale_price = resale_price / 1000)

# summary of all non dummy variables, check for impossible values
summary(prices[, setdiff(names(prices), is_dummy)]) #X2room sold means no. of 2 room sold in the same block
summary(prices[, is_dummy]) 

#check for outliers
ggplot(prices, aes(x = resale_price)) + geom_histogram(bins = 50)
## plot is right-skewed for histogram which represents higher end expensive flats
ggplot(prices, aes(y = resale_price)) + geom_boxplot() + labs(y = 'Resale price in $000s')
## 6 variables picked based on perceived importance 
vars <- c("resale_price", "floor_area_sqm", "Remaining_lease",
          "max_floor_lvl", "Dist_CBD", "Dist_nearest_station")
for (v in vars) {
  print(ggplot(prices, aes(x = .data[[v]])) + geom_histogram(bins = 40) + labs(x = v))
  print(ggplot(prices, aes(y = .data[[v]])) + geom_boxplot() + labs(y = v))
}
##resonable anomalies across all plots. A lone anomaly from dist_nearest_station 
## can be seen from the box plot. Data checks out and it should be kept within the
## data set.

# A3. Fix dummy coding
# Drop one base level per dummy group (month, town, flat_type, flat_model, storey)
# Use town OR postal_2digits, not both
base_levels <- c('month_Jan',
                 'town_ANG.MO.KIO', 
                 'storey_range_01.TO.03',
                 'flat_type_1.ROOM', 
                 'flat_model_2.room',
                 'Nearest_primary_school_gender_CO.ED.SCHOOL',
                 'Nearest_GAI_primary_school_gender_CO.ED.SCHOOL',
                 'Nearest_G_secondary_school_gender_CO.ED.SCHOOL',
                 'Nearest_hospital_ownership_Non.profit',
                 'Nearest_A_hospital_ownership_Non.profit'
                 ) ## dont need to drop MRT cos one flat can be close to 2 stations
prices <- prices %>% select(-starts_with('postal_2digits')) #
prices <- prices %>% select(-base_levels) #drop base levels
## mutate the high storey columns together since the top few ranges have less than
## 5 flats each. 
prices <- prices %>%
  mutate(storey_range_37.TO.48 = storey_range_37.TO.39 + storey_range_40.TO.42 +
           storey_range_43.TO.45 + storey_range_46.TO.48) %>%
  select(-c(storey_range_37.TO.39, storey_range_40.TO.42,
            storey_range_43.TO.45, storey_range_46.TO.48)) 
##FYI, 
##A_hospital: Acute Hospital
##G_school: Government School 
## ADF: After_death facilities 
## GAI: Government Aided and independent schools


# A4. Train/test split
# set.seed() before splitting; 70/30
# Objects other scripts rely on: train, test
set.seed(678349)
nrow(prices) #nrows = 6000
ntrain = 4200#set size of the training sample
tr = sample(1:nrow(prices),ntrain)  
train = prices[tr,]  
test = prices[-tr,] 

summary(prices)
