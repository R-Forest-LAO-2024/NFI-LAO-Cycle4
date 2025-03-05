## paths
paths <- list()
paths$dat <- list()
paths$R <- list()

paths$dat$parent <- "data"
paths$dat$src   <- file.path(paths$dat$parent, "data-source")
paths$dat$harmo <- "data/data-harmo"
paths$dat$clean <- "data/data-clean"  

paths$R$setup    <- "R/setup"
paths$R$sampling <- "R/sampling"
paths$R$user     <- "R/user"
paths$R$report   <- "R/reporting"

paths$res <- "results"

usethis::use_git_ignore(paths$dat$src)
