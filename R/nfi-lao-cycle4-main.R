
## User inputs for user 793500 ####

usr <- list()
usr$get_new      <- FALSE
usr$get_auto     <- FALSE
usr$get_filename <- "4th_NFI_up to2025_02_24_withpath.csv" ## "4th_NFI_2025_02_10_csv.zip" ## if method is manual, specify file name 
usr$clean_all <- FALSE
usr$time_zone <- "Asia/Bangkok"

## Run analysis ####

source(file.path("R/setup/init.R"), local = T)

source(file.path("R/setup/paths.R"), local = T)

source(file.path("R/setup/sampling.R"), local = T)

source(file.path("R/setup/get-data.R"), local = T)

source(file.path("R/calc/00-common.R"), local = T)


