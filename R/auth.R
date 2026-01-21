#' Get a JWT Bearer Token for FlowFabric API
#'
#' Uses improved authentication from hfutils to obtain a valid JWT token for API requests.
#' @return A character string containing the JWT Bearer token
#' @examples
#' \dontrun{
#' token <- flowfabric_get_token()
#' }
#' @export
##' Get a JWT Bearer Token for FlowFabric API
##'
##' Uses improved authentication from hfutils to obtain a valid JWT token for API requests.
##' @return A character string containing the JWT Bearer token
##' @examples
##' \dontrun{
##' token <- flowfabric_get_token()
##' }
##' @export
flowfabric_get_token <- function(force_refresh = FALSE) {
  # Try exported version first, fall back to ::: if needed
  token_fun <- tryCatch(get("lynker_spatial_token", asNamespace("hfutils")), error = function(e) NULL)
  refresh_fun <- tryCatch(get("lynker_spatial_refresh", asNamespace("hfutils")), error = function(e) NULL)
  if (is.null(token_fun)) token_fun <- hfutils:::lynker_spatial_token
  if (is.null(refresh_fun)) refresh_fun <- hfutils:::lynker_spatial_refresh
  token <- token_fun()
  if (inherits(token, "httr2_token")) {
    if (force_refresh || ("expires_at" %in% names(token) && Sys.time() >= as.POSIXct(token$expires_at))) {
      token <- refresh_fun(token)
    }
    return(token$access_token)
  } else if (is.character(token)) {
    return(token)
  } else {
    stop("Failed to obtain a valid JWT token.")
  }
}

#' Manage global FlowFabric API token
#'
#' Set or get the global token used for authentication. If not set, will attempt to obtain one using flowfabric_get_token().

flowfabric_token <- function(refresh = FALSE) {
    token_path <- file.path(Sys.getenv("HOME"), ".flowfabric_token")
    is_expired <- function(token) {
      parts <- strsplit(token, "\\.")[[1]]
      if (length(parts) < 2) return(TRUE)
      payload <- rawToChar(base64enc::base64decode(parts[2]))
      exp <- tryCatch(jsonlite::fromJSON(payload)$exp, error = function(e) NA)
      if (is.na(exp)) return(TRUE)
      now <- as.numeric(Sys.time())
      return(now > exp)
    }
    if (!refresh && file.exists(token_path)) {
      token <- readLines(token_path, warn = FALSE)
      if (nzchar(token) && !is_expired(token)) {
        message("[flowfabric] Using cached token.")
        return(token)
      } else if (nzchar(token)) {
        message("[flowfabric] Cached token expired. Refreshing...")
      }
    }
    message("[flowfabric] No valid cached token. Prompting for login...")
    x <- hfutils::lynker_spatial_auth()
    token <- x$id_token
    writeLines(token, token_path)
    return(token)
  }

  flowfabric_refresh_token <- function() {
    flowfabric_token(refresh = TRUE)
  }

#' @export
# flowfabric_token <- local({
#   .token <- NULL
#   function(token = NULL, force_refresh = FALSE) {
#     if (!is.null(token)) {
#       .token <<- token
#       invisible(.token)
#     } else {
#       if (is.null(.token) || force_refresh) {
#         .token <<- flowfabric_get_token(force_refresh = force_refresh)
#       }
#       .token
#     }
#   }
# })
