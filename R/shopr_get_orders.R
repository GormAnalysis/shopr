#' Get Orders
#'
#' Retrieve orders and related data for a shop
#'
#' An order is a customer's completed request to purchase one or more products from a shop. An order is created when a
#' customer completes the checkout process, during which time they provide an email address or phone number, billing
#' address and payment information.
#'
#' @export
#'
#' @references \url{https://help.shopify.com/en/api/reference/orders/order#index}
#'
#' @param shopURL shop URL (e.g. 'https://superstore-1.myshopify.com')
#' @param APIKey API key
#' @param APIPassword API password
#' @param APIVersion API version (default = \code{NULL} -> use the latest version)
#' @param max_pages maximum pages of records to return (i.e. the maximum number of HTTP GET requests to make). (default
#'   = \code{Inf})
#' @param limit_per_page maximum number of records to return per page (i.e. per HTTP GET request). Should be in the
#'   range [1, 250]. (default = 250)
#' @param ids vector of order ids like c(123, 456) (default = \code{NULL})
#' @param since_id only return orders with id > since_id (default = 0)
#' @param created_at_min POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param created_at_max POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param updated_at_min POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param updated_at_max POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param processed_at_min POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param processed_at_max POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
#'   \code{NULL})
#' @param status order status. Should be \code{NULL} or one of \{'open', 'closed', 'any'\}. (default = \code{NULL})
#' @param financial_status financial status. Should be \code{NULL} or one of \{'any', 'authorized', 'pending', 'paid',
#'   'refunded', 'voided'\}. (default = \code{NULL})
#' @param fulfillment_status fulfillment status. Should be \code{NULL} or one of \{'any', 'shipped', 'partial',
#'   'unshipped'\}. (default = \code{NULL})
#' @param fields fields to return. Common fields include:
#'
#'   \{'id', 'email', 'created_at', 'updated_at', 'total_price', 'currency', 'total_discounts', 'name',
#'   'referring_site', 'cancelled_at', 'cancel_reason', 'user_id', 'processed_at', 'order_number', 'tags', 'line_items',
#'   'client_details', 'payment_details', 'customer'\}
#'
#'   Only top-level fields are supported. (I.e. you can't subset nested fields. For example, you can select 'line_items'
#'   but not line_items' subfields like 'variant_id' or 'title'.) (default = \code{NULL})
#' @param verbose should progress messages be printed? (default = \code{FALSE})
#' @return list of data.tables. If \code{fields} is \code{NULL}, all of the following will be returned:
#'
#'   \itemize{ \item orders \item discount_applications \item discount_codes \item note_attributes \item tax_lines \item
#'   line_items \item shipping_lines \item fulfillments \item refunds }

shopr_get_orders <- function(shopURL, APIKey, APIPassword, APIVersion = NULL, max_pages = Inf, limit_per_page = 250L,
                             ids = NULL, since_id = 0L, created_at_min = NULL, created_at_max = NULL,
                             updated_at_min = NULL, updated_at_max = NULL, processed_at_min = NULL,
                             processed_at_max = NULL, status = NULL, financial_status = NULL, fulfillment_status = NULL,
                             fields = NULL, verbose = FALSE){

  #--- Validate Inputs --------------------------------------

  # Validate and clean fields
  created_at_min_ <- shopr_clean_datetime(created_at_min)
  created_at_max_ <- shopr_clean_datetime(created_at_max)
  updated_at_min_ <- shopr_clean_datetime(updated_at_min)
  updated_at_max_ <- shopr_clean_datetime(updated_at_max)
  processed_at_min_ = shopr_clean_datetime(processed_at_min)
  processed_at_max_ = shopr_clean_datetime(processed_at_max)
  ids_ <- shopr_clean_ids(ids = ids, resource = "orders")
  since_id_ <- since_id
  fields_ <- shopr_clean_fields(fields = fields, resource = "orders")
  status_ <- shopr_clean_order_status(status)
  financial_status_ <- shopr_clean_financial_status(financial_status)
  fulfillment_status_ <- shopr_clean_fulfillment_status(fulfillment_status)

  # Validate limit_per_page
  if(limit_per_page < 1L | limit_per_page > 250L) stop("'limit_per_page' should be in the range [1, 250]")

  # Clean some inputs
  if(length(ids_) > max_pages * limit_per_page){
    warning("Requesting more ids than max_pages * limit_per_page. Some ids may not be included in the result")
  }

  #--- API Version --------------------------------------
  # If APIVersion is NULL, use the latest
  # TODO: make this more dynamic

  APIVersion_ <- if(is.null(APIVersion)) "2019-04" else APIVersion

  #--- Pagination --------------------------------------
  # Get the number of total orders for the query parameters

  ordersN <- shopr_get_orders_count(
    shopURL = shopURL,
    APIKey = APIKey,
    APIPassword = APIPassword,
    APIVersion = APIVersion_,
    ids = ids_,
    since_id = since_id_,
    created_at_min = created_at_min_,
    created_at_max = created_at_max_,
    updated_at_min = updated_at_min_,
    updated_at_max = updated_at_max_,
    processed_at_min = processed_at_min_,
    processed_at_max = processed_at_max_,
    status = status_,
    financial_status = financial_status_,
    fulfillment_status = fulfillment_status_
  )

  # Number of pages required to get all the data
  pagesRequired <- ceiling(ordersN/limit_per_page)

  # Determine how many pages to query
  pagesN <- min(pagesRequired, max_pages)

  #--- Request --------------------------------------

  # List to store requests & results
  resultList <- vector(mode = "list", length = pagesN)

  # Build request
  requestURL <- paste0(shopURL, "/admin/api/", APIVersion_, "/orders.json")
  queryParams <- list(
    ids = if(is.null(ids_)) NULL else paste(ids_, collapse = ","),
    limit = limit_per_page,
    since_id = since_id_,
    created_at_min = created_at_min_,
    created_at_max = created_at_max_,
    updated_at_min = updated_at_min_,
    updated_at_max = updated_at_max_,
    processed_at_min = processed_at_min_,
    processed_at_max = processed_at_max_,
    status = status_,
    financial_status = financial_status_,
    fulfillment_status = fulfillment_status_,
    fields = fields_
  )

  # Make requests and generate responses
  for(i in seq_len(pagesN)){
    if(verbose) print(paste0("Requesting page: ", i, " of ", pagesN))
    response_i <- httr::RETRY(
      verb = "GET",
      url = requestURL,
      encode = "json",
      httr::authenticate(user = APIKey, password = APIPassword),
      query = queryParams,
      quiet = !verbose
    )
    resultList[[i]] <- jsonlite::fromJSON(
      txt = httr::content(response_i, "text", encoding = "UTF-8"),
      flatten = TRUE
    )$orders

    # Update since_id
    queryParams$since_id <- tail(resultList[[i]]$id, 1)

    # Update ids
    if(!is.null(ids_)){
      ids_ <- ids_[ids_ > queryParams$since_id]
      if(length(ids_) == 0) break
      queryParams$ids <- paste(ids_, collapse = ",")
    }

    # Check the current API call limit status. If the leaky call bucket is full, sleep for a bit
    callLimit <- shopr_parse_call_limit(response_i$headers$`x-shopify-shop-api-call-limit`)
    if(callLimit$bucketCalls == callLimit$bucketSize) Sys.sleep(0.5)  # Sleep for 0.5 seconds
  }

  # Check API version (but only if the user requested a specific version)
  if(!is.null(APIVersion) && response_i$headers$`x-shopify-api-version` != APIVersion){
    warning(paste0(
      "Shopify processed this request with a different API version than the one you requested. ",
      "Requested: ", APIVersion, ", used: ", response_i$headers$`x-shopify-api-version`
    ))
  }

  #--- Clean up --------------------------------------

  # Collapse list of data.frames into a single data.table
  orders <- data.table::rbindlist(resultList, use.names = TRUE, fill = TRUE)

  # Extract internal data.frames (e.g. line_items) into into standalone data.tables
  colz <- data.frame(Col = colnames(orders))
  colz$IsList <- sapply(colnames(orders), FUN = function(x) is.list(orders[[x]]), simplify = TRUE)
  result <- vector(mode = "list", length = sum(colz$IsList) + 1L)
  names(result) <- c("orders", colz$Col[colz$IsList == TRUE])
  result$orders <- orders
  for(listCol in colz$Col[colz$IsList == TRUE]){
    tryCatch(expr = {
      result[[listCol]] <- rbindlist(orders[[listCol]], use.names = TRUE, fill = TRUE, idcol = "order_id")
      result[[listCol]][, order_id := orders[, id[order_id]]]
      data.table::set(x = result$orders, j = listCol, value = NULL)
    }, error = function(x) return())
  }
  result <- Filter(f = Negate(is.null), x = result)

  # Return the result
  return(result[])
}