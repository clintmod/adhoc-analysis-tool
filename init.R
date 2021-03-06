# init.R
#
# Used to install packages on heroku if not already installed.
#

my_packages = c("curl", "jsonlite", "rpivotTable", "shiny", "shinydashboard", "shinyjs")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))
