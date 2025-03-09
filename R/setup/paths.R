## paths
path     <- list()
path$dat <- list()
path$R   <- list()
path$res <- list()

path$dat$parent <- "data"
path$dat$src    <- file.path(path$dat$parent, "data-source")
path$dat$harmo  <- file.path(path$dat$parent, "data-harmo")
path$dat$clean  <- file.path(path$dat$parent, "data-clean")

path$R$parents  <- "R"
path$R$setup    <- file.path(path$R$parent, "setup")
path$R$sampling <- file.path(path$R$parent, "sampling")
path$R$user     <- file.path(path$R$parent, "user")
path$R$report   <- file.path(path$R$parent, "reporting")

path$res$parent <- "results"
path$res$test   <- file.path(path$res$parent, "tests")
path$res$fig    <- file.path(path$res$parent, "figures")
path$res$tab    <- file.path(path$res$parent, "tables")
path$res$html   <- file.path(path$res$parent, "html")
path$res$report <- file.path(path$res$parent, "reports")

walk(path$dat, dir.create, showWarning = F)
walk(path$R  , dir.create, showWarning = F)
walk(path$res, dir.create, showWarning = F)

usethis::use_git_ignore(path$dat$parent)
usethis::use_git_ignore(path$res$parent)

usethis::use_git_ignore(".DS_Store")
