
## Initiate list to store temporary objects
tmp <- list()

## Make unique treeplot_id ####
tmp$treeplot <- data_init$treeplot_init |>
  filter(`plot_info/crew_lead` != "QC") |>
  mutate(
    plot_no = as.numeric(`plot_info/plot_code_nmbr`),
    plot_id =  case_when(
      plot_no < 10 ~ paste0("00", plot_no),
      plot_no < 100 ~ paste0("0", plot_no),
      TRUE ~ as.character(plot_no)
    ),
    treeplot_no = `plot_info/sub_plot`,
    treeplot_id = paste0(plot_id, treeplot_no)
  ) |>
  select(
    ONA_treeplot_id = `_index`, 
    plot_id, treeplot_id, plot_no, treeplot_no, 
    crew_lead = `plot_info/crew_lead`,
    survey_time, 
    time_start = `plot_info/rec_time_start`, 
    time_end = rec_time_end
    )

## Solve duplicates in treeplot table ####
tmp$n_treeplot <- length(unique(tmp$treeplot$treeplot_id))
message("Unique treeplot IDs: ", tmp$n_treeplot == nrow(tmp$treeplot))

if (tmp$n_treeplot != nrow(tmp$treeplot)) {
  
  tmp$check_dup <- tmp$treeplot |>
    group_by(treeplot_id) |>
    summarise(count = n()) |>
    filter(count > 1)
  
  ## !!! TEMPORARY RULE: Solve duplicates by keeping records that took the longest time
  tmp$max_duration <- tmp$treeplot |>
    group_by(treeplot_id) |>
    summarise(max_survey_time = max(survey_time))
  
  tmp$treeplot_nodup <- tmp$treeplot |> 
    left_join(tmp$max_duration, by = "treeplot_id") |>
    filter(survey_time == max_survey_time)
  
  message("Unique treeplot IDs after corr: ", tmp$n_treeplot == nrow(tmp$treeplot_nodup))
  
}

treeplot <- tmp$treeplot_nodup

## Remove tmp objects 
rm(tmp)