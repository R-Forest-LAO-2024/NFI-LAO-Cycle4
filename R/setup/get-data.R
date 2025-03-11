
has_data <- list()
src_timestamp <- list()

## Download and unzip ####

has_data$zip <- list.files(path$dat$src, pattern = ".zip")

if (usr$data_update | length(has_data$zip) == 0) {
  source(file.path(path$R$setup, "get-data", "download.R"), local = T)
}

## Read source and harmonize ######

has_data$harmo <- list.files(path$dat$harmo, pattern = "csv")

if (usr$data_update | length(has_data$harmo) == 0) {
  
  source(file.path(path$R$setup, "get-data", "read-source.R"))
  
  
  
}
