#' @title middle_negative_test
#' @param dx A sequential change of SWE values. This is a vector object.
#' @description For the D4 Method, we need to have five consecutive changes,
#' the ends of which are positive, and at most one of the three middles is
#' negative. This function takes the changes and returns a logical vector of
#' TRUEs when at most one of the three middles is negative.
middle_negative_test <- function(dx) {
  negs <- (dx[2:(length(dx) - 3)] < 0) + # First middle < 0 PLUS
    (dx[3:(length(dx) - 2)] < 0) + # Second middle < 0 PLUS
    (dx[4:(length(dx) - 1)] < 0) # Third middle < 0
  return(negs <= 1) # Only first, second, or third middle can be < 0.
}

#' @title d5_method_from_vector
#' @param x A sequential change of SWE values. This is a vector object.
#' @description This function will take raw observations, make sure there is
#' enough data to perform the D5 Method (if not, it will return NULL), and then
#' calculate the D5 Method.
d5_method_from_vector <- function(x) {
  n <- 5
  if (length(x) < n) {
    return(NULL)
  }

  x <- append(0, x) # made change
  dx <- x[-1] - x[-length(x)]
  d5_cands <- (dx[1:(length(dx) - (n - 1))] > 0 & dx[n:length(dx)] > 0) &
    middle_negative_test(dx)
  result <- calc_d5_method(d5_cands, dx)
  result <- unlist(result) # made change
  result <- result[!(is.na(result))]
  return(result)
}

#' @ title Calculate D5 Method for Snow Loads
#' @description Given a dataframe, a column of which includes snow
#' observations, this function will calculate the D4 Method.
#' @param df The dataframe containing snow observations.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#' @return A list of numeric vectors containing the observations
#'   for the D5 Method (list split across 2 or more raw observations of 0).
d5_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d5_method_from_vector)
  return(result)
}

#' @title Extract Day-5 method observations
#' @description This function allows the user to extract sequential daily
#' changes (Day-1 method) in SWE.
#' @param station_data A data table of a measurement location/station.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#' @return A list with two elements. The first element is the Day-5
#' method observations, while the second element is the annual maximum load
#' for each snow year.
day5 <- function(station_data, col_name) {

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


  DIFF <- d5_method(station_data, col_name)


  d5 <- data.table(ID, NAME, STATE, LONGITUDE, LATITUDE, DIFF)

  # modification by reference
  annual[, MONTH := as.numeric(format(as.Date(DATE), "%m"))]
  annual[, YEAR := as.numeric(format(as.Date(DATE), "%Y"))]
  annual[, YEAR := ifelse(MONTH > 07, YEAR + 1, YEAR)]


  annual <- annual[, .SD[, max(SWE)], by = .(
    ID, NAME, STATE, LONGITUDE,
    LATITUDE, YEAR
  )][, ANNUAL := V1][, V1 := NULL]

  output <- list("d5" = d5, "annual" = annual)
  return(output)
}
