
## Initiate list to store temporary objects
tmp <- list()

## !!! The data is spread over a thd columns as one row is one treeplot, 
##     tree info is in new column for each tree.

## Get table names for main entities
tmp$tab_names <- names(data_init$master_csv) |>
  str_subset("ldw_data_rep|ntfp_rep|sapling_data_rep|tree_data_nest1_rep|tree_data_nest2_rep") |>
  str_remove("___.*") |>
  unique()

tmp$tab_names_new <- tmp$tab_names |>
  str_replace(str_subset(tmp$tab_names, "tree_data_nest1"), "tree_init1") |>
  str_replace(str_subset(tmp$tab_names, "tree_data_nest2"), "tree_init2") |>
  str_replace(str_subset(tmp$tab_names, "sapling"), "sapling_init") |>
  str_replace(str_subset(tmp$tab_names, "ldw"), "ldw_init") |>
  str_replace(str_subset(tmp$tab_names, "ntfp"), "ntfp")

## Extract table at treeplot level
data_init$treeplot_init <- data_init$master_csv |> 
  select(-starts_with(tmp$tab_names))

## Extract data that require conversion to long table
tmp$data_init <- map(tmp$tab_names, function(x){
  tt <- fct_extract_from_csv(
    .httr_csv_content = data_init$master_cs, 
    .pattern = x
  ) 
  
  vars <- names(tt) |> str_subset("ONA_", negate = T)
  
  tt |> drop_na(all_of(vars))
  
})

write_csv(tt, "data/test_sap.csv")


data_init$tree_init1 <- fct_extract_from_csv(
  .httr_csv_content = data_init$master_cs, 
  .pattern = "survey_reference_trees_measure_tree_data_nest1_tree_data_nest1_rep"
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