
use_package <- function(.pkg_name, .github = FALSE, .gh_repo = NULL, .load = T) {
  pkg_name <- as.character(substitute(.pkg_name))
  if (!require(pkg_name, character.only = T,  quietly = TRUE)) {
    if (!.github) {
      install.packages(pkg_name, dep =TRUE)
    } else if (.github) {
      if (!require(remotes, quietly = TRUE)) install.packages("remotes", dep = TRUE)
      remotes::install_github(paste0(.gh_repo))
    }
  }
  if (.load) library(pkg_name, character.only = T, quietly = TRUE)
}

use_package(ona, .github = T, .gh_repo = "onaio/ona.R", .load = F)

use_package(readr)
use_package(stringr)
use_package(tidyr)
use_package(dplyr)
use_package(ggplot2)
use_package(purrr)
use_package(sf)
use_package(terra)


## Get time in UTC
local_time <- function(tz) {
  
  tt <- Sys.time()
  attr(tt,"tzone") <- tz
  tt <- str_remove(as.character(tt), "\\..*")
  paste0(tt, " ", tz)
  
}


## Initiate log
write_lines(
  paste0(local_time("UTC"), ": Initiate log \n\n"), 
  file = "log.txt"
)


