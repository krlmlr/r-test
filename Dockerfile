## Emacs, make this -*- mode: sh; -*-

## start with the rocker daily image
FROM rocker/drd:latest

## This handle reaches Kirill
MAINTAINER "Kirill Müller" krlmlr+github@mailbox.org

## Copy configuration to keep this Dockerfile generic
COPY PACKAGES /pkg-src/

## Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates openssh-client git \
                libcurl4-openssl-dev libxml2-dev && \
	rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
	rm -rf /var/lib/apt/lists/* && \
        Rscript -e 'read.dcf("pkg-src/PACKAGES")[1,]' && \
        Rscript -e 'install.packages("devtools")' && \
        Rscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages)' && \
        RDscript -e 'install.packages("devtools")' && \
        RDscript -e 'deps <- strsplit(gsub("^\n", "", read.dcf("pkg-src/PACKAGES")[1,]), "\n"); devtools::install_github(deps$deps, dependencies = TRUE); devtools::install_github(deps$gh_packages); if (length(deps$cran_packages) > 0) install.packages(deps$cran_packages)'

## End
