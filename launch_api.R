library(plumber)
library(dplyr)
library(parsnip)

pr <- plumb("plumber.R")
pr$run()
