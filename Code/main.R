library(glmnet)
library(doParallel)
library(Metrics)
library(som)
library(readr)
library(data.table)
library(Matrix)
library(igraph)
library(psych)
library(WGCNA)
library(reshape2)
require(gtools)
library(data.table)

# Fetching current file directory
mainDir <- dirname(parent.frame(2)$ofile)

# Setting current directory as working directory
setwd(mainDir)

d <- function(...) {
  return (
    paste(..., sep = '/')
  )
}

# Creating the result folders
dir.create(d(mainDir, "Results"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "BiCorr"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "Communities"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "Communities", "L1"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "Communities", "L2"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "LASSO"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "PartialCorrelation"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "SelectedGenes"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "SelectedGenes", "L1"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "SelectedGenes", "L2"), showWarnings = FALSE)
dir.create(d(mainDir, "Results", "SpearmanCorrelation"), showWarnings = FALSE)

# Sourcing steps 0a, 0b and 0c
# source("0a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("0b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("0c.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("1a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("1b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("1c.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("2a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("2b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("2c.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("3a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("3b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("3c.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("4a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("4b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("5a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("5b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("6a.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("6b.R", echo=TRUE)
# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# 
# opt <- 'N'
# while (opt == 'N') {
#   t1 <- readline("Enter the threshold (default: 0.10) ")
#   if (t1 != '') tval <- as.numeric(t1)
#   else tval <- 0.10
#   
#   val_str <- paste0(as.character(tval * 100), "per")
#   save(tval, val_str, opt, file = 'dims7.Rdata')
#   
#   source("7a.R", echo=TRUE)
#   rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
#   gc()
#   
#   load('dims7.Rdata')
#   source("7b.R", echo=TRUE)
#   rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
#   gc()
#   
#   load('dims7.Rdata')
#   
#   opt <- as.character(readline("Do you wish to proceed? (Y/N)"))
# }

# rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
# gc()
# source("8.R", echo=TRUE)
rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc()
source("9.R", echo=TRUE)
