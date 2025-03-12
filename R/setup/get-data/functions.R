
fct_extract_from_csv <- function(.httr_csv_content, .pattern) {
  
  ## !!! FOR TESTING ONLY
  # .httr_csv_content = tmp$content
  # .pattern = "survey_measure_tree_data_nest1_tree_data_nest1_rep"
  ## !!!
  
  if (!is.data.frame(.httr_csv_content)) stop(".httr_csv_content should be a data frame")
  if (!is.character(.pattern)) stop(".pattern should be a character vector of size 1")
  if (length(.pattern) != 1)   stop(".pattern should be a character vector of size 1")
  
  out_df <- .httr_csv_content |>
    select(
      ONA_id, ONA_uuid, plot_info_plot_code_nmbr, plot_info_sub_plot, 
      starts_with(.pattern)
    ) |>
    rename_with(.cols = starts_with(.pattern), str_extract, "__.*") |>
    pivot_longer(
      cols = starts_with("__"), 
      cols_vary = "slowest",
      names_to = c("ONA_tree_no", ".value"), 
      names_pattern = "__(.*[0-9])__(.*)"
    ) |>
    arrange(plot_info_plot_code_nmbr, plot_info_sub_plot, ONA_tree_no)
  
  out_df
  
}
