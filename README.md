# TundraFlux Database (v1)

An open database of ecosystem respiration (Reco), plot-level vegetation
and soil properties, and site-level environmental and method metadata
from Arctic and alpine tundra ecosystems. \## Overview

The TundraFlux database compiles daily-aggregated and raw flux-level
measurements of ecosystem respiration (Reco) (whenever multiple
measurements occurred per day ) from tundra ecosystems across multiple
Arctic and alpine sites. In addition to the flux measurements, the
database provides plot-level metadata (vegetation structure, soil
properties, measurement methods) and site-level metadata (geolocation,
climate, parent material, vegetation type).

All data files are stored as RDS to preserve R-specific data types
(e.g., factors, dates, characters).

## Repository Structure

```{python}
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
│   └── README.Rmd                      # Explanation of each data file
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

### 1. Reco Data + Microclimate Data

-   Reco_microclimate_daily.rds
    -   Daily aggregated Reco values per plot
    -   Includes microclimate variables (PAR, air and soil temperature,
        soil moisture)
    -   Missing values are stored as NA

### 2. Metadata

#### 2.1. Site Metadata

-   site_metadata_v1.rds

The site-level metadata file contains all information that characterizes
each study site. This includes its geographic location, environmental
conditions, soil parent material, vegetation type, and key project
contacts. These variables provide the broader ecological and
methodological context necessary to interpret Reco measurements and
enable comparisons among sites.

#### 2.2. Vegetation Cover and Plant Traits Metadata

-   pant_traits_metadata_v1.rds

The plot-level metdadta file contains vegetation cover estimates and
plant trait measurements for the dominant species at each plot where
Reco was measured. This includes information on species composition,
percent cover, plant height, and biomass. These variables are essential
for understanding how vegetation structure and function influence
ecosystem respiration rates.

#### 2.3. Soil Properties Metadata

-   soil_metadata_v1.rds

The plot-level metadata file contains soil property measurements for
each plot where Reco was measured. This includes organic layer depth,
bulk density, carbon and nitrogen content of the organic and mineral
soil layer, pH, nutrient concentrations, and soil moisture measured on
plot-level. These variables are critical for understanding how soil
characteristics affect carbon cycling processes that drive ecosystem
respiration.

#### 2.4. Method Metdata

### 1. Aggregated ecosystem respiration data

-   TundraFlux_daily_v1.rds

    -   Daily aggregated Reco values
    -   Includes environmental variables (PAR, temperature, soil
        moisture)
    -   Missing values are stored as NA

### 2. Raw flux-level measurements

-   TundraFlux_raw_v1.rds

    -   All individual chamber measurements
    -   Includes QC flags (outliers, measurement inconsistencies)
    -   Allows users to apply their own filtering criteria
    -   Missing values are stored as NA

### Negative and zero Reco values:

The TundraFlux Database contains occasional negative and exact-zero Reco values. Negative values can arise in chamber-based flux measurements due to short-term fluctuations in CO₂ concentration, instrument noise, pressure effects, or brief net uptake moments when Reco is small relative to photosynthetic activity (particularly under high light or rapidly changing conditions). Such values were retained to preserve the integrity of the originally reported datasets and to allow users to apply their preferred quality-control filters.

Exact-zero values may occur when contributors applied local preprocessing steps prior to data submission, such as thresholding small negative fluxes to zero, rounding extremely small magnitude fluxes (e.g., |Reco| < detection limit), or assigning zero when the net change in chamber CO₂ concentration fell within instrument noise. Because preprocessing practices differed among contributing studies, the database includes both zeros and small negative values where originally reported.

Users are therefore encouraged to implement filtering procedures appropriate to their research question—for example removing negative values, applying instrument-specific detection limits, excluding observations below a user-defined threshold, or using the QC flags included in the raw flux file.

## Data Dictionary

A complete list of variables, descriptions, units, and data types is
provided in:

👉 documentation/data_dictionary.Rmd

This file is intended as the authoritative reference for users.

## How to Load the Data in R \# Load libraries library(tidyverse)

```{r}
# Load libraries
library(tidyverse)

# Load data
# flux data
flux    <- readRDS("data/flux_microclimate_daily_v1.rds")
# site_level
site    <- readRDS("data/site_metadata_site_v1.rds")
method  <- readRDS("data/method_metadata_site_v1.rds")
# plot-level   
plant   <- readRDS("data/plant_traits_metadata_v1.rds")
soil    <- readRDS("data/soil_metadata_v1.rds")

# complete dataset (flux+metadata)
daily   <- readRDS("data/TundraFlux_daily_v1.rds")
raw     <- readRDS("data/TundraFlux_raw_v1.rds")

```

## R code

-    01_import_and_merge.R

    -   How to load in data files and merge metadata with flux data
    -   export merged dataset as rds or csv
    
-    02_daily_aggregation.R

    -   load in un-aggregated data
    -   daily aggregation
    -   export aggregated dataset as rds or csv

-    03_outlier_removal.R

    -   load in un-aggregated data (TundraFlux_raw_v1.rds)
    -   daily aggregation
    -   export aggregated dataset as rds or csv

-    04_metadata_presentation.qmd

    -   load in un-aggregated data (TundraFlux_raw_v1.rds)
    -   daily aggregation
    -   export aggregated dataset as rds or csv


## How to Cite

(Replace with DOIs when available.)

Citation for Data: Schwieger et al. (2026). TundraFlux Database v1.
Zenodo Repository.

Citation for Publication: manuscript details.

## Contributing

To follow updates on ongoing and future projects, please visit our
website <https://arcticflux.org/>. To contribute new datasets to our
TundraFlux Database, please get in contact with us via our mail
[tundrafluxdatabase\@lists.umu.se](mailto:tundrafluxdatabase@lists.umu.se).

## Maintainer

**Name:** Sarah Schwieger

**Affiliation:** Umeå University

**Email:**
[tundrafluxdatabase\@lists.umu.se](mailto:tundrafluxdatabase@lists.umu.se){.email}

## License

Specify one:

-   Creative Commons Attribution 4.0 License
    <https://creativecommons.org/licenses/by/4.0/>
