
## User inputs ####

usr <- list()
usr$download_new <- FALSE
usr$clean_csv    <- TRUE
usr$clean_zip    <- FALSE
usr$time_zone    <- "Asia/Bangkok"

## Run analysis ####

source(file.path("R/setup/init.R"), local = T)

source(file.path("R/setup/paths.R"), local = T)

source(file.path("R/setup/sampling.R"), local = T)

source(file.path("R/setup/get-data.R"), local = T)

source(file.path("R/calc/00-common.R"), local = T)


