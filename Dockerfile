## Emacs, make this -*- mode: sh; -*-

## start with the rocker r-base image
FROM rocker/r-base:latest

## This handle reaches Kirill
MAINTAINER "Kirill Müller" krlmlr+github@mailbox.org

## Copy configuration to keep this Dockerfile generic
COPY PACKAGES /pkg-src/

## Install dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		openssh-client \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/* \
        && cd /pkg-src \
        && Rscript -e 'install.packages("devtools"); deps <- strsplit(gsub("^\n", "", read.dcf("PACKAGES")[1,]), "\n"); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages)'

## End
