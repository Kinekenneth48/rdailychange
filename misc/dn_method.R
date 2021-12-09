#' Calculate the Dn Method for Snow Loads for n = 1, 2, 3, 4, 5
#'
#' @description Given a dataframe, a column of which includes snow observations,
#'   this function will calculate the Dn Method for n = 1, 2, 3, 4, 5.
#'
#' @param df The dataframe containing snow observations.
#' @param n The n for which to calculate the Dn method.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list of numeric vectors containing the observations
#'   for the Dn Method (list split across 2 or more raw observations of 0).
#'
#' @export
dn_method <- function(df, n, col_name = "SWE") {
  if (n == 1) {
    return(d1_method(df, col_name))
  }
  if (n == 2) {
    return(d2_method(df, col_name))
  }
  if (n == 3) {
    return(d3_method(df, col_name))
  }
  if (n == 4) {
    return(d4_method(df, col_name))
  }
  if (n == 5) {
    return(d5_method(df, col_name))
  } else {
    stop("Error.")
  }
}




