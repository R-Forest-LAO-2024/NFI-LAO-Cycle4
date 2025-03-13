
## Initiate list for temporary objects
tmp_read <- list()

## Get ext
tmp_read$get_ext <- str_remove(usr$get_filename, ".*\\.")

if (tmp_read$get_ext == "zip") {
  
  ## Create directory for the data
  tmp_read$dir_name <- str_remove(usr$get_filename, "\\..*")
  tmp_read$dir_path <- file.path(path$dat$src, tmp_read$dir_name)
  dir.create(tmp_read$dir_path, showWarnings = F)
  
  ## Unzip file
  unzip(
    zipfile = file.path(path$dat$src, usr$get_filename),
    exdir = tmp$dir_path
  )
  
  ## List data and create names
  tmp_read$list_csv <- list.files(tmp_read$dir_path, pattern = "\\.csv", full.names = T)
  tmp_read$names <- tmp_read$list_csv |> 
    str_replace(str_subset(tmp_read$list_csv, "data\\.csv"), "treeplot_init") |>
    str_replace(str_subset(tmp_read$list_csv, "tree_data_nest1"), "tree_init1") |>
    str_replace(str_subset(tmp_read$list_csv, "tree_data_nest2"), "tree_init2") |>
    str_replace(str_subset(tmp_read$list_csv, "sapling"), "sapling_init") |>
    str_replace(str_subset(tmp_read$list_csv, "ldw"), "ldw_init") |>
    str_replace(str_subset(tmp_read$list_csv, "ntfp"), "ntfp")
  
  ## Read data
  tmp_read$data_init <- map(tmp_read$list_csv, function(x) {
    tt <- read_csv(x, col_types = cols(.default = "c")) |>
      rename_with(.cols = everything(), str_replace_all, "/", "_") |>
      rename_with(.cols = everything(), str_replace_all, "\\[|\\]", "__") |>
      rename_with(.cols = everything(), str_replace_all, "___", "__") |>
      rename_with(.cols = starts_with("_"), str_replace, "_", "ONA_")
    })
  
  ## Rename data
  names(tmp_read$data_init) <- tmp_read$names
  
  ## Transfer to data_init
  data_init <- append(data_init, tmp_read$data_init)
  
} else if (usr$get_ext == "csv") {
  
  ## Read data directly into data_init
  data_init$master_csv <- read_csv(
    file.path(path$dat$src, usr$get_filename), 
    col_types = cols(.default = "c")
  )
  
}

## Clean tmp elements
rm(tmp_read)

