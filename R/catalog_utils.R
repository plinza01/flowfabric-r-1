#' Auto-populate streamflow query params from catalog
#'
#' @param dataset_id Dataset identifier
#' @return List of recommended params for flowfabric_streamflow_query
#' @export
auto_streamflow_params <- function(dataset_id) {
  catalog_url <- "https://flowfabric.lynker-spatial.com/catalog"
  resp <- httr2::request(catalog_url) |> httr2::req_perform()
  catalog <- httr2::resp_body_json(resp)
  # Flatten all datasets from all provider_groups
  all_datasets <- unlist(lapply(catalog$provider_groups, function(pg) pg$datasets), recursive = FALSE)
  idx <- which(vapply(all_datasets, function(x) x$id == dataset_id, logical(1)))
  if (length(idx) != 1) stop("Dataset not found in catalog")
  info <- all_datasets[[idx]]
  # Detect dataset type and auto-populate params accordingly
  # Heuristic: if query_mode is 'absolute' or type is 'reanalysis', use absolute params
  is_reanalysis <- FALSE
  if (!is.null(info$query_mode) && info$query_mode == "absolute") is_reanalysis <- TRUE
  if (!is.null(info$type) && grepl("reanalysis", tolower(info$type))) is_reanalysis <- TRUE

  if (is_reanalysis) {
    # Use a recent default window if available, else min/max
    start_time <- if (!is.null(info$default_start_time)) info$default_start_time else if (!is.null(info$min_time)) info$min_time else "2018-01-01T00:00:00Z"
    end_time <- if (!is.null(info$default_end_time)) info$default_end_time else if (!is.null(info$max_time)) info$max_time else "2018-01-31T23:59:59Z"
    list(
      query_mode = "absolute",
      start_time = start_time,
      end_time = end_time,
      scope = if (!is.null(info$default_scope)) info$default_scope else "all",
      format = if (!is.null(info$default_format)) info$default_format else "arrow",
      mode = if (!is.null(info$recommended_mode)) info$recommended_mode else "sync"
    )
  } else {
    list(
      query_mode = "run",
      issue_time = if (!is.null(info$latest_issue_time)) info$latest_issue_time else "latest",
      scope = if (!is.null(info$default_scope)) info$default_scope else "all",
      lead_start = if (!is.null(info$lead_min)) info$lead_min else 0,
      lead_end = if (!is.null(info$lead_max)) info$lead_max else 0,
      format = if (!is.null(info$default_format)) info$default_format else "arrow",
      mode = if (!is.null(info$recommended_mode)) info$recommended_mode else "sync"
    )
  }
}
