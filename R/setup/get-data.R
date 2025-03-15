
## RUN ONLY IF USER REQUEST NEW DATA
if (usr$get_new) {
  
  ## Initiate list to store source data
  data_init <- list()
  
  ## Load helpers
  source("R/setup/get-data/helpers.R", local = T)
  
  ## REMOVE EXISTING FILES ####
  
  ## Remove all harmo and clean files
  unlink(list.files(path$dat$harmo, full.names = T, pattern = "\\.csv"))
  unlink(list.files(path$dat$clean, full.names = T, pattern = "\\.csv"))
  
  ## Clean source files if requested
  if (usr$clean_all) {
    unlink(list.files(path$dat$src, full.names = T), recursive = T)
  }
  
  ## GET INITIAL DATA ####
  
  ## Get new file, download or unzip if necessary
  if (usr$get_auto) {
    source("R/setup/get-data/download-ona.R", local = T)
  } else if (!usr$get_auto) {
    source("R/setup/get-data/read-manual.R", local = T)
  }
  
  ## If file is CSV, need to make entities
  if ("master_csv" %in% names(data_init)) {
    source("R/setup/get-data/split-master-csv.R", local = T)
  }
  
}






## Create entity based CSV if data come from master CSV
if (usr$get_auto | usr$get_ext == "csv") {
  
  source("R/setup/get-data/split_master_csv.R")
  
  
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
