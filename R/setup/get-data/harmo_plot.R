
## Initiate list to store temporary objects
tmp <- list()

## Number of plots
tmp$n_plot <- length(unique(data_init$treeplot_init$`plot_info/plot_code_nmbr`))

## Get info from treeplot to plot
tmp$plot_init <- data_init$treeplot_init |>
  group_by