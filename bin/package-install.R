#!/usr/bin/env Rscript

#####~~~~~ reusable generic components ~~~~~#####

## capture starting working directory and script directory
DIR_START <- getwd()
DIR_SCRIPT <- commandArgs()[grepl("--file=", commandArgs())]
DIR_SCRIPT <- dirname(substr(DIR_SCRIPT, 8, nchar(DIR_SCRIPT)))
DIR_SCRIPT <- setwd(DIR_SCRIPT)
DIR_SCRIPT <- getwd()


#####~~~~~ project specific components ~~~~~#####

## project scripts stored in <project-root>/bin
## change working directory to project root
setwd(paste0(DIR_SCRIPT, "/.."))
DIR_ROOT <- getwd()


#####~~~~~ script specific components ~~~~~#####

## command line arguments
# 1: file containing package names
# 2: library location on file system
# 3: CRAN mirror repository URL
CMD_ARGS <- commandArgs(TRUE)

## read in shared package list
setwd(DIR_START)
x <- normalizePath(CMD_ARGS[1], mustWork = TRUE)
x <- readLines(x)
x <- x[!(substr(x, 1, 1) %in% c("#", ""))]
x <- unique(x)

## normalize library location
y <- normalizePath(CMD_ARGS[2], mustWork = TRUE)
setwd(DIR_ROOT)

## install packages
install.packages(
    pkgs = x,
    lib = y,
    repos = CMD_ARGS[3]
)
