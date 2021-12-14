#' @title split_across_n_m
#' @param x A sequential change of SWE values. This is a vector object.
#' @param n This represents the zeros to split a vector. The default is 2, if
#' there are two consecutive zeros, the vector will be split at that point.
#' @param m This represents the value when encountered will serve as a
#' a splitting point.
#' @description This function takes a vector x of raw snow observations and
#' split the vector across n or more m's into a list of vectors.
#'
#' @examples x <- c(1, 2, 0, 0, 0, 4, 5, 0, 3, 0, 0, 2, 1, 3)
#' split_across_n_m(x)

split_across_n_m <- function(x, n = 2, m = 0) {
  r <- rle(x == m)
  r$values <- cumsum(r$values & r$lengths > n - 1)
  result <- lapply(split(x, inverse.rle(r)), function(r) r[cummax(r) > m])
  return(result)
}

#' @title d1_method_from_vector
#' @param x A sequential change of SWE values. This is a vector object.
#' @description Helper Function 2 works in the same manner as Helper Function 1
#' but this time time the vector x has no consecutive 0's. This function takes
#' raw observations, make sure there is enough data to perform the D1 Method
#' (if not, it will return NULL), and then calculate the D1 Method.

d1_method_from_vector <- function(x) {
  if (length(x) < 1) {
    return(NULL)
  }

  x <- append(0, x) # made change
  dx <- x[-1] - x[-length(x)]
  result <- dx[dx > 0]
  result <- unlist(result) # made change
  result <- result[!(is.na(result))]
  return(result)
}

#' Calculate D1 Method for Snow Loads
#'
#' @description This function calculates the D1 Method.
#'
#' @param df The dataframe containing snow observations.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list of numeric vectors containing the observations
#'   for the D1 Method (list split across 2 or more raw observations of 0).

d1_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d1_method_from_vector)
  result <- unlist(result) # made change
  return(result)
}

#' @title Extract Day-1 method observations
#' @description This function allows the user to extract sequential daily
#'  changes
#' (Day-1 method) in SWE.
#' @param station_data A data table of a measurement location/station.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list with two elements. The first element is the Day-1
#' method observations, while the second element is the annual maximum load
#' for each snow year.

day1 <- function(station_data, col_name) {

  # set data frame as data.table
  station_data <- data.table::setDT(station_data)


  # deep copy main_matrix to avoid modification by reference
  annual <- data.table::copy(station_data)


  # get station meta data
  ID <- unique(station_data$ID)
  NAME <- unique(station_data$NAME)
  STATE <- unique(station_data$STATE)
  LONGITUDE <- unique(station_data$LONGITUDE)
  LATITUDE <- unique(station_data$LATITUDE)


  DIFF <- d1_method(station_data, col_name)


  d1 <- data.table(ID, NAME, STATE, LONGITUDE, LATITUDE, DIFF)

  # modification by reference
  annual[, MONTH := as.numeric(format(as.Date(DATE), "%m"))]
  annual[, YEAR := as.numeric(format(as.Date(DATE), "%Y"))]
  annual[, YEAR := ifelse(MONTH > 07, YEAR + 1, YEAR)]


  annual <- annual[, .SD[, max(SWE)], by = .(
    ID, NAME, STATE, LONGITUDE,
    LATITUDE, YEAR
  )][, ANNUAL := V1][, V1 := NULL]

  output <- list("d1" = d1, "annual" = annual)
  return(output)
}
