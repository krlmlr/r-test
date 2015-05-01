## Emacs, make this -*- mode: sh; -*-

## start with the rocker daily image
FROM rwercker/base:latest

## This handle reaches Kirill
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
  RDscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages)'

## End
