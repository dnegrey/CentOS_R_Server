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
# 1: file to append entries (typically /etc/fstab)
CMD_ARGS <- commandArgs(TRUE)

## read in user list
x <- unique(readLines("etc/cifs-mount-users"))

## normalize append file
setwd(DIR_START)
y <- normalizePath(CMD_ARGS[1], mustWork = TRUE)
setwd(DIR_ROOT)

## define main function
main <- function(u, f) {
    z <- list()
    for (user in u) {
        z[[user]] <- data.frame(
            V1 = "//DomainName/PathToShare",
            V2 = sprintf("/home/%s/UserMountPoint", user),
            V3 = "cifs",
            V4 = sprintf("user,credentials=/home/%s/UserCredFile,noauto", user),
            V5 = "0 0",
            stringsAsFactors = FALSE
        )
    }
    z <- do.call(rbind, z)
    row.names(z) <- NULL
    write.table(
        x = z,
        file = f,
        append = TRUE,
        quote = FALSE,
        sep = "\t",
        na = "",
        row.names = FALSE,
        col.names = FALSE
    )
}

## call main function
main(x, y)
