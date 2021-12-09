# HELPER FUNCTION 1 #####
# This function will take a vector x of raw snow observations. It will then
# split the vector across n or more m's into a list of vectors.
# > x <- c(1, 2, 0, 0, 0, 4, 5, 0, 3, 0, 0, 2, 1, 3)
# > split_across_n_m(x)
# $`0`
# [1] 1 2
# $`1`
# [1] 4 5 0 3
# $`2`
# [1] 2 1 3
split_across_n_m <- function(x, n = 2, m = 0) {
  r <- rle(x == m)
  r$values <- cumsum(r$values & r$lengths > n - 1)
  result <- lapply(split(x, inverse.rle(r)), function(r) r[cummax(r) > m])
  return(result)
}

# HELPER FUNCTION 2 #####
# Because of HELPER FUNCTION 1, the HELPER FUNCTION 2 assumes to work with
# d2_cands which is derived from raw observations with no consecutive 0's.

# This function will take the indices where the i'th and (i+1)'th dx is positive.
# It will then falsify TRUEs following TRUEs (since we cannot reuse dx values
# in the D2 Method).
Rcpp::cppFunction('LogicalVector purge_d2_cands(LogicalVector d2_cands) {
  int skip = 1;
  for (int i = 0; i < d2_cands.size(); i++) {
    if (d2_cands[i] == true) {
      d2_cands[i + skip] = false;
    }
  }
  return d2_cands;
}')

# HELPER FUNCTION 3 #####
# Because of HELPER FUNCTION 1, the HELPER FUNCTION 3 assumes to work with
# raw observations with no consecutive 0's.

# This function will take raw observations, make sure there is enough data to
# perform the D2 Method (if not, it will return NULL), and then calculate
# the D2 Method.
d2_method_from_vector <- function(x) {
  n <- 2
  if (length(x) < n + 1) {
    return(NULL)
  }
  dx <- x[-1] - x[-length(x)]
  d2_cands <- dx[1:(length(dx) - (n - 1))] > 0 & dx[n:length(dx)] > 0
  d2_cands <- purge_d2_cands(d2_cands)
  indices <- which(d2_cands == TRUE)
  result <- dx[indices] + dx[indices + (n - 1)]
  return(result)
}

#' Calculate D2 Method for Snow Loads
#'
#' @description Given a dataframe, a column of which includes snow observations,
#'   this function will calculate the D2 Method.
#'
#' @param df The dataframe containing snow observations.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list of numeric vectors containing the observations
#'   for the D2 Method (list split across 2 or more raw observations of 0).
#'
#' @export
d2_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d2_method_from_vector)
  return(result)
}
