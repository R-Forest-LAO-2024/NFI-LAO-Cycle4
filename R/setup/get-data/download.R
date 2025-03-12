
## Initiate list to store temporary objects
tmp <- list()


## Connect to ONA and download
tmp$get <- httr::GET("https://api.ona.io/api/v1/data/793500.csv", httr::authenticate("fipdlaos", rstudioapi::askForSecret("ONA password")))

if (tmp$get$status_code == 200) {

  ## get data in table format
  tmp$content <- httr::content(tmp$get, type = "text/csv")
  #write_csv(tmp$content, file.path(path$dat$src, "test.csv"))
  
  ## !!! The data is spread over thds of columns to as one row is one treeplot.
  
  ## Extracting tree_nest1
  tmp$tree_nest1 <- tmp$content |>
    select(`_id`, `_uuid`, `plot_info/plot_code_nmbr`, `plot_info/sub_plot`, starts_with("survey/measure/tree_data_nest1/tree_data_nest1_rep"))

  tmp$new_names <- names(tmp$tree_nest1) |>
    str_remove("survey/measure/tree_data_nest1/") |>
    str_replace("\\[", "___") |>
    str_replace("\\]/", "___") |>
    str_remove("tree_data_nest1_rep")
  
  names(tmp$tree_nest1) <- tmp$new_names
  
  tree_nest1_init <- tmp$tree_nest1 |>
    mutate(across(starts_with("___"), as.character)) |>
    pivot_longer(
      cols = starts_with("___"), cols_vary = "slowest",
      names_to = c("set", ".value"), 
      names_pattern = "___(.*)___(.*)"
      ) |>
    arrange(`plot_info/plot_code_nmbr`, `plot_info/sub_plot`) |>
    filter(`tree_data_basic_nest1/t_nb_nest1` != "n/a")
  
}




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

