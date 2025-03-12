
## Initiate objects
check_data <- list()

## Remove old zip files if required by user
if (usr$clean_zip) {
  unlink(list.files(path$dat$src, full.names = T, pattern = "\\.zip"))
}

## Remove all files if required by user
if (usr$download_new | usr$clean_csv) {
  
  unlink(list.files(path$dat$src, full.names = T, pattern = "\\.csv"))
  unlink(list.files(path$dat$harmo, full.names = T, pattern = "\\.csv"))
  unlink(list.files(path$dat$clean, full.names = T, pattern = "\\.csv"))
  
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
