# 01_import_clean.R
library(readxl) #install.packages('readxl')
library(dplyr)
## prevent MASS package from interfering with select()
select <- dplyr::select
library(ggplot2)

# A1. Import data
# Read data/HDB_data_2021_sample.xlsx (relative path, not /Users/...)
HDB_data <- read_excel("data/HDB_data_2021_sample.xlsx")
dim(HDB_data)
str(HDB_data) ## all data confirmed to be num
head(HDB_data)

# A2. Data checks
# Missing values, impossible values, outliers
# Rescale resale_price to $000s
sum(is.na(HDB_data)) #check for empty values; no empty values present
#drop columns where values are the same for the entire column (eg, year, or cols with all 0)
HDB_data <- HDB_data %>% select(-where(~ n_distinct(.x) == 1)) 

is_dummy <- HDB_data %>% select(where(~ all(.x %in% c(0, 1)))) %>% names()
#no. of non dummy columns
length(setdiff(names(HDB_data), is_dummy)) 
#no. of dummies
length(is_dummy)
HDB_data <- HDB_data %>% mutate(resale_price = resale_price / 1000)

# summary of all non dummy variables, check for impossible values
summary(HDB_data[, setdiff(names(HDB_data), is_dummy)]) #X2room sold means no. of 2 room sold in the same block
summary(HDB_data[, is_dummy]) 

#check for outliers
ggplot(HDB_data, aes(x = resale_price)) + geom_histogram(bins = 50)
## plot is right-skewed for histogram which represents higher end expensive flats
ggplot(HDB_data, aes(y = resale_price)) + geom_boxplot() + labs(y = 'Resale price in $000s')
## 6 variables picked based on perceived importance 
impt_vars <- c("resale_price", "floor_area_sqm", "Remaining_lease",
          "max_floor_lvl", "Dist_CBD", "Dist_nearest_station")
for (v in impt_vars) {
  print(ggplot(HDB_data, aes(x = .data[[v]])) + geom_histogram(bins = 40) + labs(x = v))
  print(ggplot(HDB_data, aes(y = .data[[v]])) + geom_boxplot() + labs(y = v))
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
                 'Nearest_G_primary_school_gender_CO.ED.SCHOOL',
                 'Nearest_secondary_school_gender_CO.ED.SCHOOL',
                 'Nearest_GAI_secondary_school_gender_CO.ED.SCHOOL',
                 'Nearest_hospital_ownership_Non.profit',
                 'Nearest_A_hospital_ownership_Non.profit'
                 ) ## dont need to drop MRT cos one flat can be close to 2 stations
HDB_data <- HDB_data %>% select(-starts_with('postal_2digits')) #
HDB_data <- HDB_data %>% select(-base_levels) #drop base levels
## mutate the high storey columns together since the top few ranges have less than
## 5 flats each. 
HDB_data <- HDB_data %>%
  mutate(storey_range_37.TO.48 = storey_range_37.TO.39 + storey_range_40.TO.42 +
           storey_range_43.TO.45 + storey_range_46.TO.48) %>%
  select(-c(storey_range_37.TO.39, storey_range_40.TO.42,
            storey_range_43.TO.45, storey_range_46.TO.48)) 
##FYI, 
##A_hospital: Acute Hospital
##G_school: Government School 
## ADF: After_death facilities 
## GAI: Government Aided and independent schools
HDB_factors <- HDB_data %>%
  mutate(
    month = case_when(
      month_Feb == 1 ~ "Feb",
      month_Mar == 1 ~ "Mar",
      month_Apr == 1 ~ "Apr",
      month_May == 1 ~ "May",
      .default = "Jan"),
    month = relevel(factor(month), ref = "Jan"),
    
    town = case_when(
      town_BEDOK == 1 ~ "BEDOK",
      town_BISHAN == 1 ~ "BISHAN",
      town_BUKIT.BATOK == 1 ~ "BUKIT.BATOK",
      town_BUKIT.MERAH == 1 ~ "BUKIT.MERAH",
      town_BUKIT.PANJANG == 1 ~ "BUKIT.PANJANG",
      town_BUKIT.TIMAH == 1 ~ "BUKIT.TIMAH",
      town_CENTRAL.AREA == 1 ~ "CENTRAL.AREA",
      town_CHOA.CHU.KANG == 1 ~ "CHOA.CHU.KANG",
      town_CLEMENTI == 1 ~ "CLEMENTI",
      town_GEYLANG == 1 ~ "GEYLANG",
      town_HOUGANG == 1 ~ "HOUGANG",
      town_JURONG.EAST == 1 ~ "JURONG.EAST",
      town_JURONG.WEST == 1 ~ "JURONG.WEST",
      town_KALLANG.WHAMPOA == 1 ~ "KALLANG.WHAMPOA",
      town_MARINE.PARADE == 1 ~ "MARINE.PARADE",
      town_PASIR.RIS == 1 ~ "PASIR.RIS",
      town_PUNGGOL == 1 ~ "PUNGGOL",
      town_QUEENSTOWN == 1 ~ "QUEENSTOWN",
      town_SEMBAWANG == 1 ~ "SEMBAWANG",
      town_SENGKANG == 1 ~ "SENGKANG",
      town_SERANGOON == 1 ~ "SERANGOON",
      town_TAMPINES == 1 ~ "TAMPINES",
      town_TOA.PAYOH == 1 ~ "TOA.PAYOH",
      town_WOODLANDS == 1 ~ "WOODLANDS",
      town_YISHUN == 1 ~ "YISHUN",
      .default = "ANG.MO.KIO"),
    town = relevel(factor(town), ref = "ANG.MO.KIO"),
    
    storey_range = case_when(
      storey_range_04.TO.06 == 1 ~ "04.TO.06",
      storey_range_07.TO.09 == 1 ~ "07.TO.09",
      storey_range_10.TO.12 == 1 ~ "10.TO.12",
      storey_range_13.TO.15 == 1 ~ "13.TO.15",
      storey_range_16.TO.18 == 1 ~ "16.TO.18",
      storey_range_19.TO.21 == 1 ~ "19.TO.21",
      storey_range_22.TO.24 == 1 ~ "22.TO.24",
      storey_range_25.TO.27 == 1 ~ "25.TO.27",
      storey_range_28.TO.30 == 1 ~ "28.TO.30",
      storey_range_31.TO.33 == 1 ~ "31.TO.33",
      storey_range_34.TO.36 == 1 ~ "34.TO.36",
      storey_range_37.TO.48 == 1 ~ "37.TO.48",
      .default = "01.TO.03"),
    storey_range = relevel(factor(storey_range), ref = "01.TO.03"),
    
    flat_type = case_when(
      flat_type_2.ROOM == 1 ~ "2.ROOM",
      flat_type_3.ROOM == 1 ~ "3.ROOM",
      flat_type_4.ROOM == 1 ~ "4.ROOM",
      flat_type_5.ROOM == 1 ~ "5.ROOM",
      flat_type_EXECUTIVE == 1 ~ "EXECUTIVE",
      flat_type_MULTI.GENERATION == 1 ~ "MULTI.GENERATION",
      .default = "1.ROOM"),
    flat_type = relevel(factor(flat_type), ref = "1.ROOM"),
    
    flat_model = case_when(
      flat_model_adjoined.flat == 1 ~ "adjoined.flat",
      flat_model_apartment == 1 ~ "apartment",
      flat_model_dbss == 1 ~ "dbss",
      flat_model_improved == 1 ~ "improved",
      flat_model_improved.maisonette == 1 ~ "improved.maisonette",
      flat_model_maisonette == 1 ~ "maisonette",
      flat_model_model.a == 1 ~ "model.a",
      flat_model_model.a.maisonette == 1 ~ "model.a.maisonette",
      flat_model_model.a2 == 1 ~ "model.a2",
      flat_model_multi.generation == 1 ~ "multi.generation",
      flat_model_new.generation == 1 ~ "new.generation",
      flat_model_premium.apartment == 1 ~ "premium.apartment",
      flat_model_premium.apartment.loft == 1 ~ "premium.apartment.loft",
      flat_model_premium.maisonette == 1 ~ "premium.maisonette",
      flat_model_simplified == 1 ~ "simplified",
      flat_model_standard == 1 ~ "standard",
      flat_model_terrace == 1 ~ "terrace",
      flat_model_type.s1 == 1 ~ "type.s1",
      flat_model_type.s2 == 1 ~ "type.s2",
      .default = "2.room"),
    flat_model = relevel(factor(flat_model), ref = "2.room"),
    
    Nearest_primary_school_gender = case_when(
      Nearest_primary_school_gender_BOYS..SCHOOL  == 1 ~ "BOYS..SCHOOL",
      Nearest_primary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_primary_school_gender = relevel(factor(Nearest_primary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_GAI_primary_school_gender = case_when(
      Nearest_GAI_primary_school_gender_BOYS..SCHOOL  == 1 ~ "BOYS..SCHOOL",
      Nearest_GAI_primary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_GAI_primary_school_gender = relevel(factor(Nearest_GAI_primary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_G_primary_school_gender = case_when(
      Nearest_G_primary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_G_primary_school_gender = relevel(factor(Nearest_G_primary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_secondary_school_gender = case_when(
      Nearest_secondary_school_gender_BOYS..SCHOOL  == 1 ~ "BOYS..SCHOOL",
      Nearest_secondary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_secondary_school_gender = relevel(factor(Nearest_secondary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_GAI_secondary_school_gender = case_when(
      Nearest_GAI_secondary_school_gender_BOYS..SCHOOL  == 1 ~ "BOYS..SCHOOL",
      Nearest_GAI_secondary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_GAI_secondary_school_gender = relevel(factor(Nearest_GAI_secondary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_G_secondary_school_gender = case_when(
      Nearest_G_secondary_school_gender_BOYS..SCHOOL  == 1 ~ "BOYS..SCHOOL",
      Nearest_G_secondary_school_gender_GIRLS..SCHOOL == 1 ~ "GIRLS..SCHOOL",
      .default = "CO.ED.SCHOOL"),
    Nearest_G_secondary_school_gender = relevel(factor(Nearest_G_secondary_school_gender), ref = "CO.ED.SCHOOL"),
    
    Nearest_hospital_ownership = case_when(
      Nearest_hospital_ownership_Private == 1 ~ "Private",
      Nearest_hospital_ownership_Public  == 1 ~ "Public",
      .default = "Non.profit"),
    Nearest_hospital_ownership = relevel(factor(Nearest_hospital_ownership), ref = "Non.profit"),
    
    Nearest_A_hospital_ownership = case_when(
      Nearest_A_hospital_ownership_Private == 1 ~ "Private",
      Nearest_A_hospital_ownership_Public  == 1 ~ "Public",
      .default = "Non.profit"),
    Nearest_A_hospital_ownership = relevel(factor(Nearest_A_hospital_ownership), ref = "Non.profit")) %>%
 
  select(-starts_with(c("month_", "town_", "storey_range_", "flat_type_", "flat_model_",
                        "Nearest_primary_school_gender_", "Nearest_GAI_primary_school_gender_",
                        "Nearest_G_primary_school_gender_", "Nearest_secondary_school_gender_",
                        "Nearest_GAI_secondary_school_gender_", "Nearest_G_secondary_school_gender_",
                        "Nearest_hospital_ownership_", "Nearest_A_hospital_ownership_"),
                      ignore.case = FALSE))

## for non knn 
set.seed(678349)
nrow(HDB_factors) #nrows = 6000
ntrain = 4200#set size of the training sample
tr_factors = sample(1:nrow(HDB_factors),ntrain)  
train_factors = HDB_factors[tr_factors,]  
test_factors = HDB_factors[-tr_factors,] 
summary(HDB_factors)
head(HDB_factors)

train_factors <- droplevels(train_factors) #remove unused 
for(col in colnames(test_factors)) {
  if(is.factor(test_factors[[col]])) {
    train_levels <- levels(train_factors[[col]])
    test_factors <- test_factors[test_factors[[col]] %in% train_levels, ]
    test_factors[[col]] <- factor(test_factors[[col]], levels = train_levels)
  }
}
test_factors <- droplevels(test_factors)
 
# for knn and PCR
set.seed(678349)
nrow(HDB_data) #nrows = 6000
ntrain = 4200#set size of the training sample
tr = sample(1:nrow(HDB_data),ntrain)  
train = HDB_data[tr,]  
test = HDB_data[-tr,] 
## remove columns where there is only 1 non_zero value out of all rows
## prevents zerodivision error during scaling in PCR
rare_cols <- train %>%
  select(where(~ sum(.x != 0) <= 1)) %>%
  names()
train_pcr <- train %>% select(-all_of(rare_cols))
test_pcr  <- test  %>% select(-all_of(rare_cols))

summary(HDB_data)
