# Simple regression script that works without broom

# ---- Libraries ----
library(dplyr)
library(ggplot2)
library(readr)

# ---- Load data with correct filename (including the "(1)" part) ----
data <- read_csv("/workspaces/Masai_Mara_2025/mortality_spi_ndvi (1).csv", show_col_types = FALSE)

# ---- Fit Models ----
model_spi <- lm(mortality_rate ~ spi_3, data = data)
model_ndvi <- lm(mortality_rate ~ ndvi, data = data)
model_combo <- lm(mortality_rate ~ spi_3 + ndvi, data = data)

# Extract stats from summaries directly
spi_summary <- summary(model_spi)
ndvi_summary <- summary(model_ndvi)
combo_summary <- summary(model_combo)

# ---- Console Output ----
cat("\n=== Model Summaries ===\n")
cat(sprintf("SPI only   : R² = %.3f | p = %.4f\n", 
            spi_summary$r.squared, 
            spi_summary$coefficients[2,4]))

cat(sprintf("NDVI only  : R² = %.3f | p = %.4f\n", 
            ndvi_summary$r.squared,
            ndvi_summary$coefficients[2,4]))

cat(sprintf("Combined   : R² = %.3f | p(SPI) = %.4f | p(NDVI) = %.4f\n",
            combo_summary$r.squared, 
            combo_summary$coefficients["spi_3", 4], 
            combo_summary$coefficients["ndvi", 4]))

# Suggested trigger (20th‑percentile SPI)
spi_trigger <- quantile(data$spi_3, 0.2, na.rm = TRUE)
cat(sprintf("\nSuggested payout trigger: SPI < %.2f\n", spi_trigger))

# ---- Basic plots without aes_string ----
p_spi <- ggplot(data, aes(x = spi_3, y = mortality_rate)) +
  geom_point(color = "darkred", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  theme_minimal() +
  labs(title = "Livestock Mortality vs SPI",
       subtitle = paste0("R² = ", round(spi_summary$r.squared, 3)),
       x = "SPI (3-month)",
       y = "Mortality Rate (%)")

ggsave("/workspaces/Masai_Mara_2025/plot_spi.png", p_spi, width = 8, height = 6)

p_ndvi <- ggplot(data, aes(x = ndvi, y = mortality_rate)) +
  geom_point(color = "forestgreen", alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "darkgreen") +
  theme_minimal() +
  labs(title = "Livestock Mortality vs NDVI",
       subtitle = paste0("R² = ", round(ndvi_summary$r.squared, 3)),
       x = "NDVI",
       y = "Mortality Rate (%)")

ggsave("/workspaces/Masai_Mara_2025/plot_ndvi.png", p_ndvi, width = 8, height = 6)

cat("\nSaved plots: plot_spi.png and plot_ndvi.png\n")