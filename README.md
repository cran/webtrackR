
<!-- README.md is generated from README.Rmd. Please edit that file -->

# webtrackR <img src="man/figures/logo.png" width="120px" align="right"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/webtrackR)](https://CRAN.R-project.org/package=webtrackR)
[![R-CMD-check](https://github.com/schochastics/webtrackR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/schochastics/webtrackR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/schochastics/webtrackR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/schochastics/webtrackR?branch=main)
<!-- badges: end -->

webtrackR is an R package to preprocess and analyse web tracking data in
conjunction with survey data of panelists. The package is built on top
of data.table and can thus comfortably handle very large web tracking
datasets

## Installation

You can install the development version of webtrackR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("schochastics/webtrackR")
```

## S3 class

The package adds a S3 class called `wt_dt` which inherits most of the
functionality from the data.table class A `summary` and `print` method
are included in the package

## Preprocessing

raw web tracking data is assumed to have (at least) the following
variables:

- **panelist_id**: person who’s data is tracked
- **url**: the website the person is visiting
- **timestamp**: when the website was visited

All preprocessing functions check if these are present. Otherwise an
error is thrown.

Several other variables can be derived from these with the package:

- **duration**: how much time was spend on a website (use
  `add_duration()` and `aggregate_duration()` to summarize consecutive
  visits to the same website)
- **domain**: the toplevel domain of a URL (use `extract_domain()`)
- **type** and **prev_type**: using a domain dictionary to classify
  domains and previously visited domains (use `classify_domains()`)
- url dummy variables: add a dummy variable if a URL falls into a
  category or not (e.g. political website) (use `create_urldummy()`)
- panelist data: add e.g. survey data to the webtrack data (use
  `add_panelist_data()`)

A typical workflow looks like this:

``` r
# load webtrack data as data.table
library(data.table)
library(webtrackR)

# webtrack data
wt <- fread("<path/to/file>")

# domain dictionary (there is also an inbuilt dictionary)
domain_dict <- fread("<path/to/file>")

# dummy file (should just be a vecor of urls)
political_urls <- c("...")

# survey data
survey <- fread("<path/to/file>")

# convert to wt_dt object
wt <- as.wt_dt(wt)

wt <- add_duration(wt)
wt <- extract_domain(wt)

# classify domains and only return rows with type news
wt <- classify_domains(wt, domain_classes = domain_dict, return.only = "news")

# create a dummy variable for political news
wt <- create_urldummy(wt, dummy = political_urls, name = "political")

# add survey data
wt <- add_panelist_data(wt, data = survey)
```

## Analysis

### Ideology

Top 500 Bakshy scores are available in the package

``` r
data("bakshy")
```

### Audience Networks

Create audiences network

``` r
audience_network(wt, cutoff = 3, type = "pmi")
```

- `cutoff` indicates minimal duration to count as visit.
- `type` can be one of “pmi”, “phi”, “disparity”, “sdsm”, or “fdsm”
