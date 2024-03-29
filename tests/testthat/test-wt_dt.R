test_that("as.wt_dt", {
  skip_on_cran()
  data("testdt_tracking")
  class(testdt_tracking) <- "data.frame"
  testdt_tracking$timestamp <- as.character(testdt_tracking$timestamp)
  # testing timestamp parsing
  wt_aswt <- as.wt_dt(testdt_tracking, timestamp_format = "%Y-%m-%d %H:%M:%OS")
  expect_true(nrow(wt_aswt[is.na(timestamp)]) == 0)
  wt_aswt <- as.wt_dt(testdt_tracking, timestamp_format = "%Y %m %d")
  expect_true(nrow(wt_aswt[!is.na(timestamp)]) == 0)
  # test naming argument
  names(testdt_tracking) <- c("panelist", "wave", "time", "urladdress", "device")
  wt_aswt <- as.wt_dt(testdt_tracking, varnames = c(panelist_id = "panelist", timestamp = "time", url = "urladdress"))
  expect_true(c("panelist_id") %in% names(wt_aswt))
  expect_true(c("url") %in% names(wt_aswt))
  expect_true(c("timestamp") %in% names(wt_aswt))
})

test_that("as.wt_dt errors", {
  skip_on_cran()
  data("testdt_tracking")
  expect_no_error(as.wt_dt(testdt_tracking))
  names(testdt_tracking)[1] <- "wrong"
  expect_error(as.wt_dt(testdt_tracking))
})

test_that("is.wt_dt", {
  skip_on_cran()
  data("testdt_tracking")
  wt <- as.wt_dt(testdt_tracking)
  expect_true(is.wt_dt(wt))
  expect_false(is.wt_dt(testdt_tracking))
})

test_that("summary", {
  skip_on_cran()
  data("testdt_tracking")
  wt <- as.wt_dt(testdt_tracking)
  sum <- utils::capture.output(summary(wt))
  expect_true(any(grepl("Overview", sum)))
  expect_true(any(grepl("DATA", sum)))
})

test_that("print", {
  skip_on_cran()
  data("testdt_tracking")
  wt <- as.wt_dt(testdt_tracking)
  sum <- utils::capture.output(print(wt))
  expect_true(any(grepl("webtrack data", sum)))
})
