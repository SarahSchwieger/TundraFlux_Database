############################################################
#                DAILY AGGREGATION WORKFLOW
#                  Tundra Flux Database - Version 1.0
#                  Author: Sarah Schwieger
#                 Last updated: 2025-12-05
############################################################

## ===============================
## Load Required Libraries
## ===============================
library(tidyverse)   # includes dplyr, ggplot2, readr, tibble, etc.
library(lubridate)   # for robust date handling
library(zoo)         # optional, for rolling ops if needed
library(here)        # for reproducible paths

## ===============================
## Load Raw Data
## ===============================
# Preferred: reproducible path
flux_db_raw <- readRDS(here("data", "Tundra_Flux_raw.rds")) 

# Alternative (local cloud path)
flux_db_raw <- readRDS("data/Tundra_Flux_raw.rds")

## ===============================
## Inspect Number of Observations Per Plot-Day
## ===============================

# Step 1 — Count observations per plot per day
daily_counts <- flux_db_raw %>%
  mutate(flux_date = as.Date(flux_date)) %>%
  group_by(site_id, plot_id, flux_date) %>%
  summarise(
    n_obs = n(),
    .groups = "drop"
  )

# Step 2 — Summaries per site
site_summary <- daily_counts %>%
  group_by(site_id) %>%
  summarise(
    plots_total     = n_distinct(plot_id),
    days_total      = n(),              # number of plot-days
    days_single     = sum(n_obs == 1),
    days_multiple   = sum(n_obs > 1),
    perc_single     = round(100 * days_single / days_total, 1),
    perc_multiple   = round(100 * days_multiple / days_total, 1),
    mean_obs_day    = round(mean(n_obs), 2),
    median_obs_day  = round(median(n_obs), 2),
    max_obs_day     = max(n_obs),
    .groups = "drop"
  )

print(site_summary)

# Step 3 — Overall summary across all sites
overall_summary <- site_summary %>%
  summarise(
    total_sites       = n(),
    total_days        = sum(days_total),
    total_single_days = sum(days_single),
    total_multi_days  = sum(days_multiple),
    perc_single_days  = round(100 * total_single_days / total_days, 1),
    perc_multi_days   = round(100 * total_multi_days / total_days, 1),
    mean_obs_overall  = round(mean(mean_obs_day), 2),
    max_obs_overall   = max(max_obs_day)
  )

print(overall_summary)


## ===============================
## Daily Aggregation of Flux Data
## ===============================

flux_daily_avg <- flux_db_raw %>%
  mutate(flux_date = as.Date(flux_date)) %>%
  group_by(site_id, flux_date, treatment, plot_id) %>%
  summarise(
    # Average all numeric variables (mainly flux measurements)
    across(
      .cols = where(is.numeric),
      .fns  = ~ round(mean(.x, na.rm = TRUE), 6)
    ),
    
    # Keep first factor/character values (assumed non-varying within group)
    across(
      .cols = where(is.character) | where(is.factor),
      .fns  = ~ first(.x)
    ),
    .groups = "drop"
  )

## ===============================
## Optional: Save Output
## ===============================
# saveRDS(flux_daily_avg, here("data", "Tundra_Flux_daily_aggregated.rds"))

# Save as CSV (optional)
# write_csv(flux_full, file.path(data_dir, "Tundra_Flux_DB_merged.csv"))

############################################################
#                     END OF SCRIPT
############################################################