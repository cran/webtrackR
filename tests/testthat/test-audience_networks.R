test_that("audience_incidence", {
  skip_on_cran()
  data("testdt_tracking")
  wt <- as.wt_dt(testdt_tracking)
  wt <- add_duration(wt)
  wt <- suppressWarnings(extract_domain(wt))
  A <- audience_incidence(wt)
  expect_equal(dim(A)[1], 1288)
  expect_equal(dim(A)[2], 5)
})

test_that("audience_networks", {
  skip_on_cran()
  library(igraph)
  data("testdt_tracking")
  wt <- as.wt_dt(testdt_tracking)
  wt[, device := "desktop"] # delete this with new example data
  wt <- add_duration(wt)
  wt <- suppressWarnings(extract_domain(wt))
  pmi <- audience_network(wt, type = "pmi", cutoff = 120)
  expect_equal(ecount(pmi), 23486)
})
