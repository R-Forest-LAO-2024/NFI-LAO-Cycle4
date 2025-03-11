

## Remove CSV files from source
unlink(list.files(path$dat$src, full.names = T, pattern = "\\.csv"))

## Clean current zipped data
if (usr$data_old_clean) {
  walk(path$dat[! names(path$dat) == "parent"], function(x) unlink(list.files(x, full.names = T, pattern = "\\.zip")))
}

## Connect to ONA and download

## ++ Code for connecting and download ++

## ++ Code for renaming download with timestamp ++
src_timestamp$dl <- local_time(usr$time_zone)


## Extract latest zip
has_data$latest_dl <- sort(list.files(path$dat$src))[1]

unzip(
  zipfile = file.path(path$dat$src, latest_dl),
  exdir = file.path(path$dat$src)
)

src_timestamp$unzip <- local_time(usr$time_zone)

## Create a download report
data_dl_report <- paste0(
  "Data downloaded at ", src_timestamp$dl, 
  ", with file name ",  has_data$latest_dl,
  ", and unzipped at ", src_timestamp$unzip, "."
)
writeLines(data_dl_report, file.path(path$dat$src, "Download details.txt"))

