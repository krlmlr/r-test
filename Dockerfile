## Emacs, make this -*- mode: sh; -*-

## start with the rocker r-base image
FROM rocker/r-base:latest

## This handle reaches Kirill
MAINTAINER "Kirill Müller" krlmlr+github@mailbox.org

## Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates openssh-client libcurl4-openssl-dev && \
	rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
	rm -rf /var/lib/apt/lists/*

## Copy configuration to keep this Dockerfile generic
COPY PACKAGES /pkg-src/

RUN \
  MAKE="make -j 4 -k" Rscript -e 'read.dcf("pkg-src/PACKAGES")[1,]' && \
  MAKE="make -j 4 -k" Rscript -e 'install.packages("devtools")' && \
  MAKE="make -j 4 -k" Rscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages)'

## End
