## Emacs, make this -*- mode: sh; -*-

## start with the rocker 'daily' R-devel image
FROM rocker/hadleyverse:latest

## This handle reaches Kirill
MAINTAINER "Kirill Müller" krlmlr+github@mailbox.org

## Copy configuration to keep this Dockerfile generic
COPY PACKAGES /pkg-src/

## Install dependencies
RUN cd /pkg-src && \
  Rscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("PACKAGES")[1,]), "\n"); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages)'
