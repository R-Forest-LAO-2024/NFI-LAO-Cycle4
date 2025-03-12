
## Initiate list to store temporary objects
tmp <- list()


## Connect to ONA
tmp$get <- httr::GET(paste0("https://api.ona.io/api/v1/data/", rstudioapi::askForSecret("ONA Form ID code"), ".csv"))


## Fetch data, make all character and remove special characters in col name
if (tmp$get$status_code == 200) {

  tmp$content <- httr::content(tmp$get, type = "text/csv") |> 
    mutate(across(everything(), as.character)) |>
    rename_with(.cols = everything(), str_replace_all, "/", "_") |>
    rename_with(.cols = everything(), str_replace_all, "\\[|\\]", "__") |>
    rename_with(.cols = everything(), str_replace_all, "___", "__") |>
    rename_with(.cols = starts_with("_"), str_replace, "_", "ONA_")
  
}

if (is.null(tmp$content)) stop("Couldn't download data from API") 

## !!! The data is spread over a thd columns as one row is one treeplot, 
##     tree info is o new column for each tree.

## Extract tables
treeplot_init <- tmp$content |> 
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

treeplot_lc_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_lc_"),
    starts_with("survey_measure_canopy"),
    "survey_nf_terminate"
  )

tree_nest1_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_tree_data_nest1_tree_data_nest1_rep"
)
tree_nest2_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_tree_data_nest2_tree_data_nest2_rep"
)

sapling_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_sapling_data_rep"
)

ldw_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_ldw_transect_ldw_data_rep"
)

ntfp_init <- fct_extract_from_csv(
  .httr_csv_content = tmp$content, 
  .pattern = "survey_measure_ntfp_ntfp_rep"
)

seedling_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_measure_bamboo")
  )

bamboo_init <- tmp$content |>
  select(
    ONA_id, plot_info_plot_code_nmbr, plot_info_sub_plot,
    starts_with("survey_measure_seedling_data")
  )

test <- tmp$content_left <- tmp$content |> 
  select(
    -starts_with("plot_info"), 
    -starts_with("plot_GPS"),
    -starts_with("access"), 
    -starts_with("meta"),
    -starts_with("ONA_"),
    -starts_with("survey_mngmt_plot"),
    -starts_with("survey_measure_slope"),
    -starts_with("survey_lc_"),
    -starts_with("survey_measure_canopy"),
    -starts_with("survey_measure_tree_data_nest1_tree_data_nest1_rep"),
    -starts_with("survey_measure_tree_data_nest2_tree_data_nest2_rep"),
    -starts_with("survey_measure_sapling_data_rep"),
    -starts_with("survey_measure_ldw_transect_ldw_data_rep"),
    -starts_with("survey_measure_ntfp_ntfp_rep"),
    
  )

names(tmp$content_left)


## Update log




## ++ Code for renaming download with timestamp ++
tmp$dl_time <- local_time(usr$time_zone)

## Extract latest zip
tmp$latest_dl <- sort(list.files(path$dat$src, pattern = "\\.zip"))[1]

unzip(
  zipfile = file.path(path$dat$src, tmp$latest_dl),
  exdir = file.path(path$dat$src)
)

tmp$unzip_time <- local_time(usr$time_zone)

## Update log
write_lines(
  paste0(
    tmp$dl_time, ": Data downloaded with file name ",  tmp$latest_dl, " \n", 
    tmp$unzip_time, ": Data unzipped"
    ),
    "log.txt" , append = T
  )

