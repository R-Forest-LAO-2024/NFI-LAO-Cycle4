
## Initiate list to store temporary objects
tmp <- list()

## List files
path$dat$src_csv <- list.files(path$dat$src, pattern = "\\.csv", full.names = T)

## Read files
data_init <- map(path$dat$src_csv, read_csv, col_types = cols(.default = "c"))

## Get dataframes names from file names
tmp$names <- path$dat$src_csv |> 
  str_replace(str_subset(path$dat$src_csv, "data\\.csv"), "treeplot_init") |>
  str_replace(str_subset(path$dat$src_csv, "tree_data_nest1"), "tree_init1") |>
  str_replace(str_subset(path$dat$src_csv, "tree_data_nest2"), "tree_init2") |>
  str_replace(str_subset(path$dat$src_csv, "sapling"), "sapling_init") |>
  str_replace(str_subset(path$dat$src_csv, "ldw"), "ldw_init") |>
  str_replace(str_subset(path$dat$src_csv, "ntfp"), "ntfp")
  
## Assign dataframes names
names(data_init) <- tmp$names

## Clean tmp elements
rm(tmp)

