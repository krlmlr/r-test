## Emacs, make this -*- mode: sh; -*-

########################################################
##                                                    ##
## If creating your own image, edit the two entries   ##
## below, and the PACKAGES file                       ##
##                                                    ##
########################################################

## Choose your base image, e.g., rocker/drd:latest or rwercker/base:latest
FROM rwercker/base:latest

## Edit maintainer information as appropritate
MAINTAINER "Kirill Müller" krlmlr+github@mailbox.org

########################################################
##                                                    ##
## If creating your own image, do not edit below here ##
##                                                    ##
########################################################

## Copy configuration to keep this Dockerfile generic
COPY PACKAGES /pkg-src/

## Install dependencies
RUN \
  Rscript -e 'read.dcf("pkg-src/PACKAGES")[1,]' && \
  Rscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); if (length(deps$apt) > 0) { system("apt-get update"); system(paste("apt-get install -y --no-install-recommends", paste(deps$apt, collapse = " "))); system("rm -rf /tmp/downloaded_packages/ /tmp/*.rds /var/lib/apt/lists/*") }' && \
  Rscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages)'

## End
