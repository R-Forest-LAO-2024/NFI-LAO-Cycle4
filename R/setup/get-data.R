
## Initiate list to store temporary objects
tmp <- list()

## Load helpers
source("R/setup/get-data/helpers.R", local = T)

## Remove old zip files if required by user
if (usr$clean_zip) {
  unlink(list.files(path$dat$src, full.names = T, pattern = "\\.zip"))
}

## Remove all files if required by user
if (usr$get_new) {
  
  unlink(list.files(path$dat$src, full.names = T, pattern = "\\.csv"))
  unlink(list.files(path$dat$harmo, full.names = T, pattern = "\\.csv"))
  unlink(list.files(path$dat$clean, full.names = T, pattern = "\\.csv"))
  
}

## Get source data from server if auto
if (usr$get_new & usr$get_auto) {
  source("R/setup/get-data/download_ona.R", local = T)
  usr$get_ext <- "csv"
}

## Get ext if manual
if (!usr$get_auto) usr$get_ext <- str_remove(usr$get_filename, ".*\\.")

## Create entity based CSV if data come from master CSV
if (usr$get_ext == "csv") {
  
  tmp$src_csv <- read_csv(file.path(path$dat$src, usr$get_filename))
  
  
  
}
  
## Download and unzip ####

# check_data$src_zip <- list.files(path$dat$src, pattern = "\\.zip")
# check_data$src_csv <- list.files(path$dat$src, pattern = "\\.csv")

if (usr$download_new) {
  source("R/setup/get-data/download.R", local = T)
}

if (usr$download_new | usr$clean_csv) {
  source("R/setup/get-data/unzip-latest.R", local = T)
}

## Read source and harmonize ######

check_data$harmo <- list.files(path$dat$harmo, pattern = "csv")

if (usr$data_update | length(has_data$harmo) == 0) {
  
  source("R/setup/get-data/read-source.R", local = T)
  
}
