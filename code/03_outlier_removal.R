############################################################
#           OUTLIER REMOVAL – Median Absolute Deviation
#                 Tundra Flux Database - Version 1.0
#                 Author: Sarah Schwieger
#                 Last updated: 2025-12-05
############################################################

## ===============================
## Load Required Libraries
## ===============================
library(tidyverse)   # includes dplyr, ggplot2, readr, tibble, etc.
library(zoo)         # optional, for rolling operations if needed
library(here)        # reproducible file paths

## ===============================
## Load Raw Data
## ===============================
flux_db_raw <- readRDS(here("data", "Tundra_Flux_raw.rds"))

# Alternative (local cloud path)
flux_db_raw <- readRDS("~/Library/CloudStorage/OneDrive-Umeåuniversitet/1_projects/7_database_publishing/1_upload/2_zenodo/data/Tundra_Flux_raw.rds")


## ===============================
## 1 Initial Setup
## ===============================
n_before <- nrow(flux_db_raw)  # total rows before outlier removal

# Ensure columns are correct type
# flux_db_raw$flux_date <- as.Date(flux_db_raw$flux_date)  # if date exists
# flux_db_raw$reco      <- as.numeric(flux_db_raw$reco)    # ensure numeric

## ===============================
## 2 MAD-based Outlier Detection per Site-Year
## ===============================
db_outl_removed <- flux_db_raw %>%
  group_by(site_id, flux_year) %>%
  group_modify(~{
    df <- .x
    
    # Median and MAD
    med_val <- median(df$reco, na.rm = TRUE)
    mad_val <- mad(df$reco, constant = 1.4826, na.rm = TRUE)
    
    # Modified Z-score
    mod_z <- 0.6745 * (df$reco - med_val) / mad_val
    
    # Flag outliers
    df$outlier_MAD  <- abs(mod_z) > 2.5   # threshold for MAD
    df$outlier_flag <- df$outlier_MAD
    df$reco_clean   <- ifelse(df$outlier_flag, NA, df$reco)
    
    df
  }) %>%
  ungroup()

## ===============================
## 3 Summary Statistics
## ===============================
n_outliers <- sum(db_outl_removed$outlier_MAD, na.rm = TRUE)
n_after    <- n_before - n_outliers

cat("Rows before:", n_before,
    "| Outliers removed:", n_outliers,
    "| Rows after:", n_after, "\n")

## ===============================
## 4 Optional: Visualization
## ===============================
ggplot(db_outl_removed, aes(x = reco, fill = outlier_MAD)) +
  geom_histogram(bins = 50, position = "identity", alpha = 0.6) +
  facet_wrap(~site_id + flux_year, scales = "free") +
  labs(
    title = "Reco Distributions with MAD Outlier Flags",
    x = "Reco",
    y = "Count",
    fill = "Outlier (MAD)"
  ) +
  theme_minimal()

## ===============================
## 5 Optional: Save Cleaned Dataset
## ===============================
# saveRDS(db_outl_removed, here("data", "Flux_DB_outl_removed.rds"))

############################################################
#                     END OF SCRIPT
############################################################