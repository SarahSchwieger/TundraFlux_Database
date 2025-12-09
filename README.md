# TundraFlux Database (v1)

An open database of ecosystem respiration ($\text{R}_{\text{eco}}$), plot-level vegetation and soil properties, and site-level environmental and method metadata from Arctic and alpine tundra ecosystems.

---

## Overview

The TundraFlux database compiles **daily-aggregated** and **raw flux-level** measurements of ecosystem respiration ($\text{R}_{\text{eco}}$) from tundra ecosystems across multiple Arctic and alpine sites.

In addition to the flux measurements, the database provides:
* **Plot-level metadata:** Vegetation structure, soil properties, and specific measurement methods.
* **Site-level metadata:** Geolocation, climate, parent material, and vegetation type.

> **Data Storage:** All data files are stored as **RDS** to preserve R-specific data types (e.g., factors, dates, characters).

## Repository Structure


```{r}
TundraFlux_v1/
├── data/
│   ├── Reco_microclimate_daily_v1.rds  # Plot-level Reco and microclimate datq
│   ├── site_metadata_v1.rds            # Site-level site metadata
│   ├── plant_metadata_v1.rds           # Plot-level vegetation metadata
│   ├── soil_metadata_plot_v1.rds       # Plot-level soil metadata
│   ├── method_metadata_site_v1.rds     # Site-level method metadata
│   ├── TundraFlux_daily_v1.rds         # Daily aggregated Reco data (all sites combined)
│   └── TundraFlux_raw_v1.rds           # Raw flux-level data (all individual Reco observations)
│
├── documentation/
│   ├── data_dictionary.Rmd             # Full variable descriptions
│   └── README.md                       # Explanation of each data file
│
├── code/
│   ├── 01_import_and_merge.R
│   ├── 02_daily_aggregation.R
│   ├── 03_outlier_removal.R
│   └── 04_metadata_presentation.qmd
│
└── supplementary/
    ├── figures.zip 
    └── tables_Schwieger_et_al.xlsx

```

## Data Files

The database consists of two core flux files and four metadata files, all located in the `data/` directory.

### 1. Flux and Microclimate Data

| File Name | Description | Key Details |
| :--- | :--- | :--- |
| `Reco_microclimate_daily_v1.rds` | **Plot-level Daily $\text{R}_{\text{eco}}$** | Daily aggregated $\text{R}_{\text{eco}}$ values per plot. Includes microclimate variables (PAR, air and soil temperature, soil moisture). |
| `TundraFlux_daily_v1.rds` | **Combined Daily $\text{R}_{\text{eco}}$** | Merged dataset containing all daily aggregated $\text{R}_{\text{eco}}$ and environmental variables for all sites. |
| `TundraFlux_raw_v1.rds` | **Raw Flux Measurements** | All individual chamber measurements. Includes QC flags (outliers, inconsistencies) to allow users to apply their own filtering criteria. |

### 2. Metadata Files

| File Name | Scope | Description |
| :--- | :--- | :--- |
| `site_metadata_v1.rds` | **Site-level** | Geographic location, environmental conditions, soil parent material, vegetation type, and project contacts. Provides broader ecological and methodological context. |
| `plant_metadata_v1.rds` | **Plot-level** | Vegetation cover estimates and plant trait measurements (species composition, percent cover, height, biomass) for the dominant species at each plot. |
| `soil_metadata_plot_v1.rds` | **Plot-level** | Soil property measurements (organic layer depth, bulk density, C/N content, pH, nutrients, soil moisture) for each plot. |
| `method_metadata_site_v1.rds` | **Site-level** | Information detailing the specific $\text{R}_{\text{eco}}$ and microclimate measurement methods used at each site. |

### Note on Negative and Zero $\text{R}_{\text{eco}}$ Values

The TundraFlux Database retains occasional **negative and exact-zero $\text{R}_{\text{eco}}$ values** as originally reported by contributors.
* **Negative values** can result from short-term fluctuations, instrument noise, pressure effects, or brief net $\text{CO}_2$ uptake (e.g., under rapidly changing conditions).
* **Exact-zero values** may be a result of local preprocessing (e.g., thresholding small negative fluxes to zero, rounding extremely small fluxes).

Users are **encouraged to implement filtering procedures** appropriate to their research question (e.g., removing negatives, applying detection limits, or utilizing the QC flags in the `TundraFlux_raw_v1.rds` file).

---

## Data Dictionary (Variable Descriptions)

A complete and authoritative list of variables, descriptions, units, and data types is provided in:

> 👉 **`documentation/data_dictionary.Rmd`**

---

## How to Load the Data in R

The following $\text{R}$ code snippet demonstrates how to load the primary data files using the `readRDS()` function, which is necessary for the RDS file format.

```r
# Load libraries
library(tidyverse)

# Load flux and microclimate data
reco_daily_plot <- readRDS("data/Reco_microclimate_daily_v1.rds")

# Load combined datasets
daily_combined  <- readRDS("data/TundraFlux_daily_v1.rds")
raw_flux_level  <- readRDS("data/TundraFlux_raw_v1.rds")

# Load metadata files
site_meta       <- readRDS("data/site_metadata_v1.rds")
method_meta     <- readRDS("data/method_metadata_site_v1.rds")
plant_meta      <- readRDS("data/plant_metadata_v1.rds")
soil_meta       <- readRDS("data/soil_metadata_plot_v1.rds")
```
## R Code Scripts

The `code/` directory contains $\text{R}$ scripts used for data processing and analysis:

* **`01_import_and_merge.R`**: Demonstrates how to load data files and **merge the metadata with the flux data**, and export the merged dataset.
* **`02_daily_aggregation.R`**: Shows how to load the raw data, perform **daily aggregation**, and export the resulting aggregated dataset.
* **`03_outlier_removal.R`**: Provides an example of loading the raw data (`TundraFlux_raw_v1.rds`), applying **outlier removal/filtering**, and exporting the cleaned data.
* **`04_metadata_presentation.qmd`**: A **Quarto document** used for generating presentations or reports of the key metadata.

---

## How to Cite

(Replace with DOIs when available.)

* **Citation for Data:** Schwieger et al. (2026). TundraFlux Database v1. Zenodo Repository.
* **Citation for Publication:** manuscript details.

---

## Contributing

* **Project Updates:** To follow updates on ongoing and future projects, please visit our website: <https://arcticflux.org/>.
* **Data Contribution:** To contribute new datasets to the TundraFlux Database, please contact us via email: [tundrafluxdatabase@lists.umu.se](mailto:tundrafluxdatabase@lists.umu.se).

---

## Maintainer

* **Name:** Sarah Schwieger
* **Affiliation:** Umeå University
* **Email:** [tundrafluxdatabase@lists.umu.se](mailto:tundrafluxdatabase@lists.umu.se)

---

## License

This work is licensed under the:

**Creative Commons Attribution 4.0 International License**
<https://creativecommons.org/licenses/by/4.0/>
