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
CMD_ARGS <- commandArgs(TRUE)

## read in shared package list
setwd(DIR_START)
x <- normalizePath(CMD_ARGS[1], mustWork = TRUE)
xp <- x
x <- readLines(x)
x <- x[!(substr(x, 1, 1) %in% c("#", ""))]
x <- unique(x)

## normalize library location
y <- normalizePath(CMD_ARGS[2], mustWork = TRUE)
setwd(DIR_ROOT)

## fetch list of installed packages
z <- as.data.frame(installed.packages(), stringsAsFactors = FALSE)[c("Package", "LibPath")]
z <- z[z$LibPath == y, "Package"]
z <- unique(z)

## feedback
cat(sprintf("----- The file of package names to check is: %s", xp), sep = "\n")
cat(sprintf("----- The number of unique package names to check is: %s", length(x)), sep = "\n")
cat(sprintf("----- The directory of installed packages to check is: %s", y), sep = "\n")
cat(sprintf("----- The number of unique packages installed there is: %s", length(z)), sep = "\n")
cat(sprintf("----- The number of desired packages found installed there is: %s / %s", sum(x %in% z), length(x)), sep = "\n")
