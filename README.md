# Masai_Mara_2025
Maasai Mara: Simple Livestock Mortality Regression (R Script)
A basic, tidyverse-powered R script for exploring how drought (SPI) and vegetation (NDVI) affect livestock mortality in Kenya’s Maasai Mara.
No extra packages needed beyond dplyr, ggplot2, and readr.

## What This Script Does: 

- Loads your survey data from CSV.

## Runs three regression models:

Mortality vs. SPI (Standardized Precipitation Index, 3-month)

Mortality vs. NDVI (Normalized Difference Vegetation Index)

Mortality vs. both SPI & NDVI together

- Prints out R² (fit) and p-values (significance) for each model in the console.

- Calculates a suggested payout trigger (the 20th percentile SPI value).


## Install the needed packages (first time only):

R
Copy
Edit
install.packages(c("dplyr", "ggplot2", "readr"))
Run the script line by line, or use:

R
Copy
Edit
source("your_script_name.R")
Check the output:


## Creator: 
Samia Chaudhry
B.B.A Undergraduate, Actuarial Science & Global Health
University of Wisconsin–Madison
