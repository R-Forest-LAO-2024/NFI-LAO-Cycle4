
use_package <- function(.pkg_name) {
  pkg_name <- as.character(substitute(.pkg_name))
  if (!require(pkg_name, character.only = T,  quietly = TRUE)) install.packages(pkg_name, dep =TRUE)
  library(pkg_name, character.only = T, quietly = TRUE)
}

use_package(dplyr)
use_package(ggplot2)
use_package(purrr)
use_package(sf)
use_package(terra)

## paths
paths <- list()
paths$dat <- list()
paths$R <- list()

paths$dat$src   <- "data/data-source"
paths$dat$harmo <- "data/data-harmo"
paths$dat$clean <- "data/data-clean"  

paths$R$setup    <- "R/setup"
paths$R$sampling <- "R/sampling"
paths$R$user     <- "R/user"
paths$R$report   <- "R/reporting"

