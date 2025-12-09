############################################################
#       IMPORT AND MERGE METADATA FOR TUNDRA FLUX DB
#                 Author: Sarah Schwieger
#               Last updated: 2025-10-05
############################################################

## ===============================
## Load Required Libraries
## ===============================
library(tidyverse)  # includes dplyr, readr, tibble, etc.
library(here)       # reproducible file paths

## ===============================
## 1 Define File Paths
## ===============================
# Adjust paths if needed
#data_dir <- "~/Library/1_upload/2_zenodo/data/"

flux_daily_file       <- file.path(data_dir, "Reco_microclimate_daily.rds")
site_metadata_file    <- file.path(data_dir, "site_metadata_v1.rds")
plant_metadata_file   <- file.path(data_dir, "plant_metadata_plot_v1.rds")
soil_metadata_file    <- file.path(data_dir, "soil_metadata_plot_v1.rds")
method_metadata_file  <- file.path(data_dir, "method_metadata_site_v1.rds")

## ===============================
## 2 Load Metadata
## ===============================
flux_daily       <- readRDS(flux_daily_file)
site_metadata    <- readRDS(site_metadata_file)
plant_metadata   <- readRDS(plant_metadata_file)
soil_metadata    <- readRDS(soil_metadata_file)
method_metadata  <- readRDS(method_metadata_file)

## ===============================
## 3 Merge Metadata
## ===============================

# Merge site-level metadata with daily flux data (site_id + flux_year)
flux_with_site <- flux_daily %>%
  left_join(site_metadata, by = c("site_id", "flux_year"))

# Merge plot-level metadata (plant + soil) using site_id, flux_year, plot_id
flux_with_plot <- flux_with_site %>%
  left_join(plant_metadata, by = c("site_id", "flux_year", "plot_id")) %>%
  left_join(soil_metadata, by = c("site_id", "flux_year", "plot_id"))

# Merge method metadata (site-level)
flux_full <- flux_with_plot %>%
  left_join(method_metadata, by = c("site_id", "flux_year"))

## ===============================
## 4 Check Merge Summary
## ===============================
cat("Number of rows in daily flux:", nrow(flux_daily), "\n")
cat("Number of rows after merging all metadata:", nrow(flux_full), "\n")
cat("Number of unique sites:", n_distinct(flux_full$site_id), "\n")
cat("Number of unique plots:", n_distinct(flux_full$plot_id), "\n")

## ===============================
## 5 Optional: Save Merged Dataset
## ===============================
# Save as RDS
saveRDS(flux_full, file.path(data_dir, "Tundra_Flux_DB_merged.rds"))

# Save as CSV (optional)
# write_csv(flux_full, file.path(data_dir, "Tundra_Flux_DB_merged.csv"))

############################################################
#                     END OF SCRIPT
############################################################