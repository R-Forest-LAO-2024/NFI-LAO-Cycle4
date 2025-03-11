
path$dat$src_csv <- list.files(path$dat$src, pattern = "\\.csv")

treeplot_init <- read_csv(file.path(path$dat$src, "data.csv"), col_types = cols(.default = "c"))

tree_init1 <- read_csv(file.path(path$dat$src, "survey_reference_trees_measure_tree_data_nest1_tree_data_nest1_rep.csv"), col_types = cols(.default = "c"))
tree_init2 <- read_csv(file.path(path$dat$src, "survey_reference_trees_measure_tree_data_nest2_tree_data_nest2_rep.csv"), col_types = cols(.default = "c"))

names(tree_init1) <- str_remove(names(tree_init1), pattern = ".*/tree_data_nest1_rep/")
names(tree_init1) <- str_remove_all(names(tree_init1), pattern = "_nest1")

names(tree_init2) <- str_remove(names(tree_init2), pattern = ".*/tree_data_nest2_rep/")
names(tree_init2) <- str_remove_all(names(tree_init2), pattern = "_nest2")

## TEST
print(names(tree_init1))
print(names(tree_init2))
print(match(names(tree_init1), names(tree_init2)))

## Correct column name error
names(tree_init1)[12] <- "t_height_dbh"
names(tree_init2)[12] <- "t_height_dbh"
names(tree_init2)[21] <- names(tree_init1)[21]

write_lines(
  "
corrected column name error in tree_data_nest1 \n
  col 12: height_dbh -> t_height_dbh \n\n
corrected column name error in tree_data_nest2 \n
  col12: t_height_dbh -> t_height_dbh \n
  col21: tree_dead_cl2_tall/t_dead_height_dbh_short -> tree_dead_cl2_tall/t_dead_height_dbh_tall
  ",
  file.path(path$dat$harmo, "correction_columns.txt")
  )

tree_init <- bind_rows(tree_init1, tree_init2)

err_colname <- "survey/measure/tree_data_nest2/tree_data_nest2_rep/tree_dead_nest2_cl2_tall/t_dead_height_dbh_nest2_short" 
err_pos <- match(err_colname, names(tree_init2))
names(tree_init2)[err_pos] <- "t_dead_height_dbh_nest2_tall"


## + Load the data raw
tree_init1 <- readxl::read_xlsx(path = path_datafile, sheet = "tree_data_nest1") 
tree_init2 <- readxl::read_xlsx(path = path_datafile, sheet = "tree_data_nest2") 

## + Correct column name error in tree_data_nest2
err_colname <- "survey/measure/tree_data_nest2/tree_data_nest2_rep/tree_dead_nest2_cl2_tall/t_dead_height_dbh_nest2_short" 
err_pos <- match(err_colname, names(tree_init2))
names(tree_init2)[err_pos] <- "t_dead_height_dbh_nest2_tall"

## + Add filename to data to keep track of origin file
## + Keep the trailing part of all "/" in column name
## + Remove the digit after all "nest1" or "nest2"
## + remame "_index" as it represent the ONA unique treeplot ID.
tree_tmp1 <- tree_init1 |>  
  mutate(filename = "tree_data_nest1") |>
  rename_with(str_remove, pattern = ".*/") |>
  rename_with(str_remove, pattern = "_nest1") |>
  rename(
    ONA_treeplot_id = `_parent_index`
  )

tree_tmp2 <- tree_init2 |>  
  mutate(filename = "tree_data_nest2") |>
  rename_with(str_remove, pattern = ".*/") |>
  rename_with(str_remove, pattern = "_nest2") |>
  rename(
    ONA_treeplot_id = `_parent_index`
  )

## Combine the two datasets by binding rows
tree_init <- bind_rows(tree_tmp1, tree_tmp2)

rm(tree_tmp1, tree_tmp2, tree_init1, tree_init2)


## AUTOMATIC APPROACH ######

## Check the name of all tree sheets starting witn "tree_data_nest"
vec_tree <- readxl::excel_sheets(path_datafile) |> str_subset(pattern = "tree_data_nest")

## PREPARE INITAL TREE TABLE BY ROW BINDING ALL SHEETS STARTING WITH "tree_data_nest"
tree_init <- map(vec_tree, function(x){
  
  ## + Read XL tab
  tt <- readxl::read_xlsx(path_datafile, x) 
  
  ## Correct typo in nest2 column name
  err_colname <- "survey/measure/tree_data_nest2/tree_data_nest2_rep/tree_dead_nest2_cl2_tall/t_dead_height_dbh_nest2_short" 
  if (err_colname %in% names(tt)){
    err_pos <- match(err_colname, names(tt))
    names(tt)[err_pos] <- "t_dead_height_dbh_nest2_tall"
  }
  
  ## Simplify column names and harmonize ONA treeplot IDs
  tt |>
    mutate(filename = x) |>
    rename_with(str_remove, pattern = ".*/") |>
    rename_with(str_remove, pattern = "_nest[0-9]") |>
    rename(
      ONA_treeplot_id = `_parent_index`
    )
  
}) |> list_rbind()
tree_init


## !! FOR TRAINING !!
tree_init2 <- tree_init |>
  filter(t_livedead == 1) |>
  select(
    ONA_treeplot_id, tree_no = t_nb, tree_stem_no = stem_nb, tree_distance = t_dist, tree_azimuth = t_az,
    tree_species_no = t_species_name, tree_species_local_name = t_species_other, tree_dbh = t_dbh, filename
  )

write_csv(tree_init2, "data/tree-initial.csv")
rm(tree_init2)
## !!

