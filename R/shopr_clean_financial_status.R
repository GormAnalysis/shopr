#' Clean financial status
#'
#' Helper function to validate and clean financial status parameter
#'
#' @param financial_status one of {'any', 'authorized', 'pending', 'paid', 'refunded', 'voided'}
#' @return string of clean financial_status

shopr_clean_financial_status <- function(financial_status){

  if(is.null(financial_status)){
    return(NULL)
  } else{
    financial_statuses <- c("any", "authorized", "pending", "paid", "refunded", "voided")
    if(!financial_status %in% financial_statuses){
      stop(paste0(
        "financial_status = '", financial_status, "', is not one of the allowed values {",
        paste(financial_status, collapse = ','), "}"
      ))
    } else{
      return(financial_status)
    }
  }
}
