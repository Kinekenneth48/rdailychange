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
# dx which is derived from raw observations with no consecutive 0's.

# For the D4 Method, we need to have four consecutive changes, the ends of
# which are positive, and at most one of the two middles is negative. This
# function takes the changes and returns a logical vector of TRUEs when
# at most one of the two middles is negative.
middle_negative_test <- function(dx) { # n = 2 only
  negs <- (dx[2:(length(dx) - 2)] < 0) + # First middle < 0 PLUS
    (dx[3:(length(dx) - 1)] < 0) # Second middle < 0
  return(negs <= 1) # Only first middle or second middle can be < 0.
}

# HELPER FUNCTION 3 #####
# Because of HELPER FUNCTION 1, the HELPER FUNCTION 3 assumes to work with
# d4_cands and dx which is derived from raw observations with no consecutive 0's.

# This function will take the TRUE d4_cands, sum up four consecutive days for
# the D4 Method. If that sum is positive, it will add it to the result, and
# falsify the four days used. If that sum is not positive it will do nothing.
# Looping through it will return the result.
Rcpp::cppFunction('NumericVector calc_d4_method(LogicalVector d4_cands,
                                                NumericVector dx) {
  int n = 4;
  NumericVector result;
  for (int i = 0; i < d4_cands.size(); i++) {
    if (d4_cands[i] == true) {
      int sum = 0;
      for (int j = i; j < i + n; j++) {
        sum += dx[j];
      }
      if (sum > 0) {
        result.push_back(sum);
        for (int j = i + 1; j < i + n; j++) {
          d4_cands[j] = false;
        }
      }
    }
  }
  return result;
}')

# HELPER FUNCTION 4 #####
# Because of HELPER FUNCTION 1, the HELPER FUNCTION 4 assumes to work with
# raw observations with no consecutive 0's.

# This function will take raw observations, make sure there is enough data to
# perform the D4 Method (if not, it will return NULL), and then calculate
# the D4 Method.
d4_method_from_vector <- function(x) {
  n <- 4
  if (length(x) < n + 1) {
    return(NULL)
  }
  dx <- x[-1] - x[-length(x)]
  d4_cands <- (dx[1:(length(dx) - (n - 1))] > 0 & dx[n:length(dx)] > 0) &
    middle_negative_test(dx)
  result <- calc_d4_method(d4_cands, dx)
  return(result)
}

#' Calculate D4 Method for Snow Loads
#'
#' @description Given a dataframe, a column of which includes snow observations,
#'   this function will calculate the D4 Method.
#'
#' @param df The dataframe containing snow observations.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list of numeric vectors containing the observations
#'   for the D4 Method (list split across 2 or more raw observations of 0).
#'
#' @export
d4_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d4_method_from_vector)
  return(result)
}
