% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shopr_get_orders.R
\name{shopr_get_orders}
\alias{shopr_get_orders}
\title{Get Orders}
\usage{
shopr_get_orders(
  shopURL,
  APIKey,
  APIPassword,
  APIVersion = NULL,
  max_pages = Inf,
  limit_per_page = 250L,
  ids = NULL,
  since_id = 0L,
  created_at_min = NULL,
  created_at_max = NULL,
  updated_at_min = NULL,
  updated_at_max = NULL,
  processed_at_min = NULL,
  processed_at_max = NULL,
  status = "any",
  financial_status = NULL,
  fulfillment_status = NULL,
  fields = NULL,
  verbose = FALSE
)
}
\arguments{
\item{shopURL}{shop URL (e.g. 'https://superstore-1.myshopify.com')}

\item{APIKey}{API key}

\item{APIPassword}{API password}

\item{APIVersion}{API version (default = \code{NULL} -> use the latest version)}

\item{max_pages}{maximum pages of records to return (i.e. the maximum number of HTTP GET requests to make). (default
= \code{Inf})}

\item{limit_per_page}{maximum number of records to return per page (i.e. per HTTP GET request). Should be in the
range [1, 250]. (default = 250)}

\item{ids}{vector of order ids like c(123, 456) (default = \code{NULL})}

\item{since_id}{only return orders with id > since_id (default = 0)}

\item{created_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{created_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{updated_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{updated_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{processed_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{processed_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{status}{order status. Should be \code{NULL} or one of \{'open', 'closed', 'any'\}. (default = \code{'any'})}

\item{financial_status}{financial status. Should be \code{NULL} or one of \{'any', 'authorized', 'pending', 'paid',
'refunded', 'voided'\}. (default = \code{NULL})}

\item{fulfillment_status}{fulfillment status. Should be \code{NULL} or one of \{'any', 'shipped', 'partial',
'unshipped'\}. (default = \code{NULL})}

\item{fields}{fields to return. Common fields include:

  \{'id', 'email', 'created_at', 'updated_at', 'total_price', 'currency', 'total_discounts', 'name',
  'referring_site', 'cancelled_at', 'cancel_reason', 'user_id', 'processed_at', 'order_number', 'tags', 'line_items',
  'client_details', 'payment_details', 'customer'\}

  Only top-level fields are supported. (I.e. you can't subset nested fields. For example, you can select 'line_items'
  but not line_items' subfields like 'variant_id' or 'title'.) (default = \code{NULL})}

\item{verbose}{should progress messages be printed? (default = \code{FALSE})}
}
\value{
list of data.tables. If \code{fields} is \code{NULL}, all of the following will be returned:

  \itemize{ \item orders \item discount_applications \item discount_codes \item note_attributes \item tax_lines \item
  line_items \item shipping_lines \item fulfillments \item refunds }
}
\description{
Retrieve orders and related data for a shop
}
\details{
An order is a customer's completed request to purchase one or more products from a shop. An order is created when a
customer completes the checkout process, during which time they provide an email address or phone number, billing
address and payment information.
}
\references{
\url{https://help.shopify.com/en/api/reference/orders/order#index}
}
