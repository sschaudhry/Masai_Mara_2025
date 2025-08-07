#!/usr/bin/env bash
# Ensure the mock CSV is visible to the top‐level script
ln -sf final/mortality_spi_merged.csv mortality_spi_merged.csv
echo "Linked mortality_spi_merged.csv → final/mortality_spi_merged.csv"
