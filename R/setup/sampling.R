sampling <- list()
sampling$plot_area <- data.frame(
  plant_type        = c(tree, tree, sapling, seedling),
  dbh_threshold_min = c(30, 10, 5, 0),
  plot_radius       = c(16, 8, 2, 2)
)
sampling$base_unit <- 1
