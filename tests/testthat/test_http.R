library(testthat)
library(flowfabricr)

# Test flowfabric_get() for response type

test_that("flowfabric_get returns a httr2 response object", {
  token <- get_bearer_token()
  endpoint <- "/v1/datasets"
  result <- flowfabric_get(endpoint, token = token)
  expect_s3_class(result, "httr2_response")
})

# Test flowfabric_get() for response type

test_that("flowfabric_get returns a httr2 response object", {
  token <- get_bearer_token()
  endpoint <- "/v1/datasets/nws_owp_nwm_short_range"
  result <- flowfabric_get(endpoint, token = token)
  expect_s3_class(result, "httr2_response")
})

# Test flowfabric_post() for response type

test_that("flowfabric_post returns a httr2 response object", {
  token <- get_bearer_token()
  dataset_id <- "nws_owp_nwm_short_range"
  endpoint <- "/v1/ratings/"
  auto_params <- auto_streamflow_params(dataset_id)
  result <- flowfabric_post(endpoint, body = auto_params, token = token)
  expect_s3_class(result, "httr2_response")
})
