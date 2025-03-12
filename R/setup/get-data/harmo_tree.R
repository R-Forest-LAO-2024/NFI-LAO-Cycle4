

## Prepare tree data to combine nest1 ad nest2
names(tree_init1) <- str_remove(names(tree_init1), pattern = ".*/")
names(tree_init1) <- str_remove_all(names(tree_init1), pattern = "_nest[0_9]")

names(tree_init2) <- str_remove(names(tree_init2), pattern = ".*/")
names(tree_init2) <- str_remove_all(names(tree_init2), pattern = "_nest[0-9]")

## TEST
print(names(tree_init1))
print(names(tree_init2))
print(match(names(tree_init1), names(tree_init2)))

## Correct column name error
names(tree_init1)[12] <- "t_height_dbh"
names(tree_init2)[12] <- "t_height_dbh"
names(tree_init2)[21] <- names(tree_init1)[21]

## Keep track of error corrections
write_lines(
  paste0("\n", local_time("UTC"), " Script: 'R/setup/get-data/read-source.R' \n
Corrected column name error in tree_data_nest1 \n
  - col 12: height_dbh -> t_height_dbh \n
Corrected column name error in tree_data_nest2 \n
  - col 12: t_height_dbh -> t_height_dbh \n
  - col 21: tree_dead_cl2_tall/t_dead_height_dbh_short -> tree_dead_cl2_tall/t_dead_height_dbh_tall \n
  "),
  file = "log.txt",
  append = TRUE
)

tree_init <- bind_rows(tree_init1, tree_init2)