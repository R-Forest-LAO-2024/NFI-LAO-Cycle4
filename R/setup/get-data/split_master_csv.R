## !!! The data is spread over a thd columns as one row is one treeplot, 
##     tree info is o new column for each tree.

## Extract tables at treeplot level
data_src$treeplot_init <- tmp$content |> 
  select(
    "start", "end", "today", "deviceid", 
    starts_with("plot_info"), 
    starts_with("plot_GPS"),
    starts_with("access"), 
    starts_with("survey_mngmt_plot"), 
    starts_with("survey_measure_slope"),
    "button_end1",
    "rec_time_end",
    "end_survey",
    "time3",
    "survey_time",
    "remarks",
    starts_with("meta"),
    starts_with("ONA_") 
  )

data_src$tp_lc_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_lc_"),
    starts_with("survey_measure_canopy"),
    "survey_nf_terminate"
  )

data_src$tp_bamboo_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_measure_bamboo")
  )

data_src$tp_seedling_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_measure_seedling_data")
  )

## Extract data that require conversion to long table
data_src$tree_nest1_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
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