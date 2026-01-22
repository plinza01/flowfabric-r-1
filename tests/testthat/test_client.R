library(testthat)
library(flowfabricr)

# Test for flowfabric_list_datasets

test_that("flowfabric_list_datasets returns a data frame", {
  result <- flowfabric_list_datasets()
  expect_s3_class(result, "data.frame")
})

# Test for flowfabric_streamflow_estimate

test_that("flowfabric_streamflow_estimate returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  params <- list(param1 = "value1", param2 = "value2")
  result <- flowfabric_streamflow_estimate(dataset_id, params, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_streamflow_query

test_that("flowfabric_streamflow_query returns an Arrow Table", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  params <- list(query_mode = "run", issue_time = "2026010514")
  result <- flowfabric_streamflow_query(dataset_id, params, token = token)
  expect_s3_class(result, "ArrowTable")
})

# Test for flowfabric_ratings_query

test_that("flowfabric_ratings_query returns a list", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  params <- list(param1 = "value1")
  result <- flowfabric_ratings_query(dataset_id, params, token = token)
  expect_type(result, "list")
})

# Test for flowfabric_stage_query

test_that("flowfabric_stage_query returns an Arrow Table", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_analysis"
  params <- list(param1 = "value1")
  expect_error(flowfabric_stage_query(dataset_id, params, token = token), "HTTP 404 Not Found.")
})

# Test for get_bearer_token

test_that("get_bearer_token returns a string", {
  token <- get_bearer_token()
  expect_type(token, "character")
})