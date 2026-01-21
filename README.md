# flowfabricr: R Client for flowfabric-api

This package provides an R interface to the flowfabric-api REST API, including JWT authentication using methods from hfutils. It is designed for expert R users and includes documentation and tests.

## Features

## Installation
```r
# Not yet on CRAN. Install from source:
# devtools::install_github('your-org/flowfabric-r')
```

## Usage
```r
library(flowfabricr)
# Authenticate and call an endpoint
```
## Authentication

The client will automatically cache your authentication token after your first login. On subsequent API calls, it will reuse the cached token and avoid repeated browser prompts.

**First-time use:**

```r
result <- flowfabric_streamflow_query("nws_owp_nwm_analysis", feature_ids = c("101"))
# This will prompt you to log in via browser and cache your token.
```

**Subsequent use:**

```r
result <- flowfabric_streamflow_query("nws_owp_nwm_analysis", feature_ids = c("101"))
# Uses cached token, no browser popup.
```

**Manual token refresh:**

```r
flowfabric_refresh_token() # Forces re-authentication and updates cached token
```

**Advanced:**

You can always pass a token explicitly:

```r
token <- hfutils::lynker_spatial_auth()$id_token
result <- flowfabric_streamflow_query("nws_owp_nwm_analysis", feature_ids = c("101"), token = token)
```

**Troubleshooting:**
- If you see repeated browser prompts, call `flowfabric_refresh_token()` once, then retry your queries.
- If you switch users, manually refresh the token.
- See R/ for main client code
