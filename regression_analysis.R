# ---- Libraries ----
library(dplyr)
library(ggplot2)
library(readr)

# ---- Load data ----
data <- read_csv("/workspaces/Masai_Mara_2025/mortality_spi_ndvi (1).csv") %>%
  mutate(month = as.Date(paste0(month, "-01")))

# ---- SPI Regression ----
model_spi <- lm(mortality_rate ~ spi_3, data = data)
model_summary_spi <- summary(model_spi)
r2_spi <- model_summary_spi$r.squared
p_val_spi <- model_summary_spi$coefficients[2,4]
slope_spi <- model_summary_spi$coefficients[2,1]
intercept_spi <- model_summary_spi$coefficients[1,1]

# ---- NDVI Regression ----
model_ndvi <- lm(mortality_rate ~ ndvi, data = data)
model_summary_ndvi <- summary(model_ndvi)
r2_ndvi <- model_summary_ndvi$r.squared
p_val_ndvi <- model_summary_ndvi$coefficients[2,4]
slope_ndvi <- model_summary_ndvi$coefficients[2,1]
intercept_ndvi <- model_summary_ndvi$coefficients[1,1]

# ---- Print SPI results ----
cat("SPI Regression Results:\n")
cat("Intercept:", round(intercept_spi, 2), "\n")
cat("Slope:", round(slope_spi, 2), "\n")
cat("R²:", round(r2_spi, 3), "\n")
cat("p-value:", round(p_val_spi, 4), "\n\n")

# ---- Print NDVI results ----
cat("NDVI Regression Results:\n")
cat("Intercept:", round(intercept_ndvi, 2), "\n")
cat("Slope:", round(slope_ndvi, 2), "\n")
cat("R²:", round(r2_ndvi, 3), "\n")
cat("p-value:", round(p_val_ndvi, 4), "\n\n")

# ---- Suggested payout trigger ----
spi_threshold <- quantile(data$spi_3, 0.2, na.rm = TRUE)
ndvi_threshold <- quantile(data$ndvi, 0.2, na.rm = TRUE)
cat("Suggested payout triggers:\n")
cat("SPI <", round(spi_threshold, 2), "\n")
cat("NDVI <", round(ndvi_threshold, 2), "\n")

# ---- SPI Scatterplot ----
plot_spi <- ggplot(data, aes(x = spi_3, y = mortality_rate)) +
  geom_point(color = "darkred", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue") +
  labs(
    title = "Livestock Mortality vs SPI",
    subtitle = paste0("R² = ", round(r2_spi, 3), 
                      " | p = ", round(p_val_spi, 4),
                      " | Trigger: SPI <", round(spi_threshold, 2)),
    x = "3-Month SPI",
    y = "Livestock Mortality Rate (%)"
  ) +
  theme_classic(base_size = 14) +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

# ---- NDVI Scatterplot ----
plot_ndvi <- ggplot(data, aes(x = ndvi, y = mortality_rate)) +
  geom_point(color = "darkgreen", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue") +
  labs(
    title = "Livestock Mortality vs NDVI",
    subtitle = paste0("R² = ", round(r2_ndvi, 3), 
                      " | p = ", round(p_val_ndvi, 4),
                      " | Trigger: NDVI <", round(ndvi_threshold, 2)),
    x = "NDVI",
    y = "Livestock Mortality Rate (%)"
  ) +
  theme_classic(base_size = 14) +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

# ---- Save plots with new filenames ----
ggsave("/workspaces/Masai_Mara_2025/plot_spi.png", plot_spi, width = 8, height = 6)
ggsave("/workspaces/Masai_Mara_2025/plot_ndvi.png", plot_ndvi, width = 8, height = 6)

cat("\nPlots saved as:\n")
cat("- plot_spi.png\n")
cat("- plot_ndvi.png\n")
