local_time <- function(tz) {
  
  tt <- Sys.time()
  attr(tt,"tzone") <- tz
  tt
}
