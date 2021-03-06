% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shopr_get_products.R
\name{shopr_get_products}
\alias{shopr_get_products}
\title{Get Products}
\usage{
shopr_get_products(
  shopURL,
  APIKey,
  APIPassword,
  APIVersion = NULL,
  max_pages = Inf,
  limit_per_page = 250L,
  ids = NULL,
  since_id = 0L,
  title = NULL,
  vendor = NULL,
  handle = NULL,
  product_type = NULL,
  collection_id = NULL,
  created_at_min = NULL,
  created_at_max = NULL,
  updated_at_min = NULL,
  updated_at_max = NULL,
  published_at_min = NULL,
  published_at_max = NULL,
  published_status = NULL,
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

\item{ids}{vector of product ids like c(123, 456) (default = \code{NULL})}

\item{since_id}{only return orders with id > since_id (default = 0)}

\item{title}{product title (default = \code{NULL})}

\item{vendor}{product vendor (default = \code{NULL})}

\item{handle}{product handle (default = \code{NULL})}

\item{product_type}{product type (default = \code{NULL})}

\item{collection_id}{collection id (default = \code{NULL})}

\item{created_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{created_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{updated_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{updated_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{published_at_min}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{published_at_max}{POSIXct datetime or a string with format like '2014-04-25T16:15:47-04:00' (default =
\code{NULL})}

\item{published_status}{published status. Should be \code{NULL} or one of \{'published', 'unpublished', 'any'\}.
(default = \code{NULL})}

\item{fields}{fields to return. Common fields include:

  \{'id', 'title', 'body_html', 'vendor', 'product_type', created_at', 'variants', 'options', 'images'\}

  Only top-level fields are supported (i.e. you can't subset nested fields. For example, you can select 'variants'
  but not variants' subfields like 'price' or 'sku') (default = \code{NULL})}

\item{verbose}{should progress messages be printed? (default = \code{FALSE})}
}
\value{
list of data.tables. If \code{fields} is \code{NULL}, all of the following will be returned:

  \itemize{ \item products \item variants \item options \item images \item image.variant_ids }
}
\description{
Retrieve products and related data for a shop
}
\references{
\url{https://help.shopify.com/en/api/reference/products/product#index}
}
