# ---- Libraries ----
.libPaths("~/R/x86_64-pc-linux-gnu-library/4.3")
install.packages(setdiff(c("SPEI","DBI","RPostgres","dplyr"), rownames(installed.packages())))
library(SPEI)
library(DBI)
library(RPostgres)
library(dplyr)

# ---- Connect to Postgres ----
con <- dbConnect(
  Postgres(),
  dbname = "capstone",
  host = "localhost",
  port = 5432,
  user = "capstone_user",
  password = "capstone_pass"
)

# ---- Pull mortality data ----
mortality <- dbGetQuery(con, "SELECT * FROM mortality_summary;")
print(mortality)

# ---- Load CHIRPS rainfall CSV ----
rainfall <- read.csv("/workspaces/Masai_Mara_2025/chirps_mara_2009_2020.csv")
rainfall$date <- as.Date(rainfall$date)
print(head(rainfall))

# ---- Compute 3-month SPI ----
spi_3 <- spi(rainfall$precip, scale = 3)
spi_values <- data.frame(date = rainfall$date, spi3 = spi_3$fitted)

# ---- Add round column (1-7) matching mortality survey rounds ----
spi_values$round <- rep(1:7, each = floor(nrow(spi_values)/7))[1:nrow(spi_values)]

# ---- Merge SPI with mortality ----
merged <- mortality %>%
  left_join(spi_values %>% group_by(round) %>% summarise(avg_spi3 = mean(spi3, na.rm=TRUE)), by = "round")
print(merged)

# ---- Regression: Mortality vs SPI ----
model <- lm(mortality_rate_pct ~ avg_spi3, data = merged)
summary(model)

# ---- Suggested trigger ----
trigger_spi <- -1.5
cat("\nRecommended Payout Trigger: SPI <", trigger_spi, "\n")

# ---- Save outputs ----
# 1. Save merged mortality + SPI table
write.csv(merged, "final/mortality_spi_merged.csv", row.names = FALSE)

# 2. Save regression summary
sink("final/regression_summary.txt")
print(summary(model))
sink()

# ---- Plot 1: SPI Trend ----
png("final/spi_trend.png", width = 800, height = 600)
plot(rainfall$date, spi_values$spi3, type="l", col="blue",
     main="3-Month SPI Trend (Maasai Mara 2009-2020)",
     xlab="Date", ylab="SPI")
abline(h=-1.5, col="red", lty=2)
dev.off()

# ---- Plot 2: Mortality vs SPI Scatterplot ----
png("final/mortality_vs_spi.png", width = 800, height = 600)
plot(merged$avg_spi3, merged$mortality_rate_pct,
     main="Livestock Mortality vs 3-Month SPI",
     xlab="SPI (3-Month)", ylab="Mortality Rate (%)",
     pch=19, col="darkred")
abline(h=0, col="gray")
abline(v=-1.5, col="blue", lty=2) # Proposed trigger
dev.off()
