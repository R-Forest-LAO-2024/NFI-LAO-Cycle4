
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

