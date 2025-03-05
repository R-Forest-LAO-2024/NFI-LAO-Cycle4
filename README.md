# NFI-LAO-Cycle4
Analysis of NFI LAO cycle 4


## Context of NFI cycle 4

- inc. link to the NFI field manual and design documents.


## Main calculations

- Description of core variables, i.e. response design, to be calculated from the field data
- List of output tables and figures 


## Repository description

### Data preparation (security, integrity and harmonization)

- The raw data is hosted on ONA, need access without storing sensitive info inside script 
- Check if local version of the data is up-to-date with remote database
- Update gitignore to not sync data with Github
- read data, join and harmonize
- clean and validate data
- save the harmonized and cleaned data in "data-clean/"


### Analysis scripts

- sampling design variables (tree and base unit weight)
- response design variables at tree level (basal area, volume, biomass)
- weighted variables (number of trees per DBH class, biodiversity indicators)
- aggregation scripts for tree to plot, forest type and country statistics


### Reporting scripts

- ggplots, tables, quarto documents, dashboards, geo-spatial files, etc.


## Workflow

1. Load packages and paths.
1. Load `R/user/commons.R` (user defined constants and functions).
1. Edit `R/user/user_inputs.R` to force data update from server or not.
1. If necessary read data from online service and update/create new data (download the data, harmonize, extract and clean new data).
1. Load ancillary data.
1. Load sampling design characteristics from `R/sampling/`.
1. Load calculated variables at tree level from `R/user/`.
1. Aggregate units to main unit (cluster or plot)
1. Aggregate main units to population / stratas.
1. Produce tables, figures, output data


