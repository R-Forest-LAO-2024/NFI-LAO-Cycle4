
## Initiate list to store temporary objects
tmp <- list()

## !!! The data is spread over a thd columns as one row is one treeplot, 
##     tree info is in new column for each tree.

## Extract tables at treeplot level
data_init$treeplot_init <- data_init$master_csv |> 
  select(
    -starts_with("survey_measure_ldw_transect_ldw_data_rep.csv"),
    -starts_with("survey_measure_ntfp_ntfp_rep"),
    -starts_with("survey_measure_sapling_data_rep"),
    -starts_with("survey_measure_tree_data_nest1_tree_data_nest1_rep"),
    -starts_with("survey_measure_tree_data_nest2_tree_data_nest2_rep")
  ) |>
  mutate(ONA_index = row_number())

## Extract data that require conversion to long table
data_init$tree_init1 <- fct_extract_from_csv(
  .httr_csv_content = data_init$master_cs, 
  .pattern = "survey_measure_tree_data_nest1_tree_data_nest1_rep"
)

data_src$tree_nest2_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_tree_data_nest2_tree_data_nest2_rep"
)

data_src$sapling_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_sapling_data_rep"
)

data_src$ldw_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_ldw_transect_ldw_data_rep"
)

data_src$ntfp_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_ntfp_ntfp_rep"
)

## Check what's left in master CSV
# tmp$content_left <- tmp$content |> 
#   select(
#     -starts_with("plot_info"),
#     -starts_with("plot_GPS"),
#     -starts_with("access"), 
#     -starts_with("meta"),
#     -starts_with("ONA_"),
#     -starts_with("survey_mngmt_plot"),
#     -starts_with("survey_measure_slope"),
#     -starts_with("survey_lc_"),
#     -starts_with("survey_measure_canopy"),
#     -starts_with("survey_measure_tree_data_nest1_tree_data_nest1_rep"),
#     -starts_with("survey_measure_tree_data_nest2_tree_data_nest2_rep"),
#     -starts_with("survey_measure_sapling_data_rep"),
#     -starts_with("survey_measure_ldw_transect_ldw_data_rep"),
#     -starts_with("survey_measure_ntfp_ntfp_rep"),
#     -starts_with("survey_measure_bamboo"),
#     -starts_with("survey_measure_seedling_data")
#   )
# names(tmp$content_left)

## Write tables to data-source
tmp$time <- local_time(usr$time_zone, .show_tz = F, .spe_chr = F)

walk(names(data_src), function(x){
  
  write_csv(data_src[[x]], file.path(path$dat$src, paste0(x, "-",tmp$time, ".csv")))
  
})