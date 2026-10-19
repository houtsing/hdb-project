The file contains a sample of HDB resale transactions in 2021.

The data has been sourced from data.gov.sg and other open sources.
Special thanks go to Nathanael Lam Zhao Dian who has graciously agreed to share the cleaned up data HDB resale price data used for his Honours Thesis.

The main variables are as follows:

resale_price - Resale price in $(SGD).
year - Year of transaction (all transactions done in 2021 in this subsample)
month_* - dummy variables for month of transaction
postal_2digits_* - dummy variables for 2-digit postal code
twon_* - dummy variables for towns
Remaining_lease - remaining number of years on the lease
floor_area_sqm - area in square meters 
max_floor_lvl - total number of floors in a building
storey_range_* - dummy variables for story ranges
flat_model_* - type/model of the HDB flat

There are many other potentially helpful predictors, such as distance to amenities etc. Their names are pretty self-explanatory.
