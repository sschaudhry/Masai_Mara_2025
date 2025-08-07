# ---- Load packages ----
.libPaths("~/R/x86_64-pc-linux-gnu-library/4.3")
install.packages(setdiff(c("SPEI","DBI","RPostgres","dplyr"), rownames(installed.packages())))

library(SPEI)
library(DBI)
library(RPostgres)
library(dplyr)

# ---- Connect to Postgres ----
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "capstone",
  host = "localhost",
  port = 5432,
  user = "capstone_user",
  password = "capstone_pass"
)

mortality <- dbGetQuery(con, "SELECT * FROM mortality_summary;")
print(mortality)

# ---- Load pre-downloaded CHIRPS rainfall CSV ----
rain_data <- read.csv("/workspaces/Masai_Mara_2025/chirps_mara_2009_2020.csv")
rain_data$date <- as.Date(rain_data$date)
print(head(rain_data))

# ---- Compute 3-month SPI ----
spi_3 <- spi(rain_data$precip, scale = 3)
spi_values <- data.frame(date = rain_data$date, spi3 = spi_3$fitted)
print(head(spi_values))
