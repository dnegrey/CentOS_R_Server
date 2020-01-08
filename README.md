# CentOS_R_Server

*Tools for configuring a Linux (CentOS) based server for R data science work*

**version 0.1.0**

----------

## Overview

This repo houses tools and documentation related to the *configuration* of a Linux server intended for data science work using R. This includes the setup of the following:

* Linux server environment ([CentOS](https://www.centos.org/))
* [R](https://www.r-project.org), [RStudio](https://www.rstudio.com/products/rstudio/) and [Shiny](https://www.rstudio.com/products/shiny/)
* ODBC access to Microsoft SQL Server via [unixODBC](http://www.unixodbc.org/) and [FreeTDS](http://www.freetds.org/)
* Access to an internal CIFS shared drive

----------

## Linux Server Environment

Use the following as a guide to spin up a Linux server environment for doing data science work using R.

1. As an initial preparation step, you will want to clone this repository and make the following changes. Note, if you do not intend to mount and access a CIFS share from this server, you may skip editing `./etc/cifs-mount-users` and can comment out line 68 of `./bin/server-playbook` to avoid unnecessary manipulation of certain native files on the server. Likewise, if you do not intend to access Microsoft SQL Server through ODBC from this server, you may skip editing `./etc/freetds.conf` and `./etc/odbc.ini` and can comment out lines 63-65 of `./bin/server-playbook`.
    * `./etc/`
        * `cifs-mount-users`: replace the generic username entries with the actual user names for your server
        * `freetds.conf`: replace the bottom section (lines 43-49) with an entry that accurately reflects your SQL Server environment; if you have more than one database server, add a corresponding entry for each server
        * `odbc.ini`: replace the entry with one that accurately reflects the database from your database server; if you have more than one database, add a corresponding entry for each database
    * `./bin/`
        * `fstab-entry-append.R`: replace "DomainName" on line 40 with your actual domain name; replace "PathToShare" on line 40 with your actual path to the CIFS share; replace "UserMountPoint" on line 41 with the relative path where each user will mount access to the share; replace "UserCredFile" on line 43 with the file name that users will use to store their CIFS credentials (this file must contain key=value pairs for both the "username" and "password" keys; for this reason it should be a hidden/dot file with mode 600)
2. Download and install the [CentOS Minimal ISO](https://www.centos.org/download/)
3. Copy your edited version of this repository into `/root/` (requires `sudo` access)
4. Log in to the server and execute the following command as **root**:
    `nohup /root/CentOS_R_Server/bin/server-playbook &`
5. The playbook script takes approximately 45 minutes and does the following:
    * Installs the OS packages found in `./etc/packages_centOS` of this repo (includes **R**) via `yum -y install`
    * Installs the R packages found in `./etc/packages_R` of this repo using **R** and the `install.packages()` function
        * R will also install dependent packages that these packages require
        * These packages (along with their dependencies) will be installed in `/usr/share/R/library/`; base packages that come with **R** are installed in `/usr/lib64/R/library/`
    * Downloads the RPM file for RStudio Server and installs it via `yum -y install`
        * Opens port 8787 via `firewall -cmd` for access to RStudio Server through a web browser
    * Downloads the RPM file for Shiny Server and installs it via `yum -y install`
        * Opens port 3838 via `firewall -cmd` for access to Shiny Server through a web browser
    * Creates a symbolic link to the `./etc/freetds.conf` file from this repo at `/etc/freetds.conf` on the file system
        * This file should include your applicable Microsoft SQL Server database server configuration(s)
    * Creates a symbolic link to the `./etc/odbc.ini` file from this repo at `/etc/odbc.ini` on the file system
        * This file should include your applicable ODBC DSN definitions (i.e. definitions for the databases on your Microsoft SQL Server instance(s))
    * Configures the environment for users to access an internal CIFS shared drive
        * Changes the mode of `/usr/sbin/mount.cifs` to **4755**
        * Ensures that `/etc/mtab` is a file (not a symbolic link)
        * Adds the appropriate entries to `/etc/fstab` to permit specified users (`./etc/cifs-mount-users`) to mount/unmount network shares

----------

## Release Notes

### **0.1.0**

* Foundational tools and documentation for setting up a Linux server environment
    * Built using CentOS Linux release 7.7.1908 (Core)
* Installs the latest stable versions of R, RStudio Server and Shiny Server
    * R (3.6.0)
    * RStudio Server (1.2.5033)
    * Shiny Server (1.5.12.933)
* Installs several commonly used R packages and their necessary OS packages
    * Includes OS and R packages to support the latest htmlwidgets, predictive modeling and machine learning techniques
    * Includes OS and R packages to support Tensorflow/Keras via Python3.6 virtual environments
* Initial ODBC configuration for connecting to Microsoft SQL Server databases
* Configuration for accessing an internal CIFS shared drive
