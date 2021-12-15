#' @title middle_negative_test
#' @param dx  A sequential change of SWE values. This is a vector object.
#' @description For the D4 Method, we need to have four consecutive changes,
#' the ends of which are positive, and at most one of the two middles is
#' negative. This function takes the changes and returns a logical vector of
#' TRUEs when at most one of the two middles is negative.
#' @examples
#' x <- c(1, -2, -1, 0, 0, -4, 5, 0, 3, -1, 0, -2, -1, 3)
#' rdailychange:::middle_negative_test(x)
middle_negative_test <- function(dx) { # n = 2 only
  negs <- (dx[2:(length(dx) - 2)] < 0) + # First middle < 0 PLUS
    (dx[3:(length(dx) - 1)] < 0) # Second middle < 0
  return(negs <= 1) # Only first middle or second middle can be < 0.
}

#' @title d4_method_from_vector
#' @param x A vector of SWE values
#' @description This function will take raw observations, make sure there is
#' enough data to perform the D4 Method (if not, it will return NULL), and
#' then calculate the D4 Method.
#' @examples
#' x <- c(1, -2, -1, 0, 0, -4, 5, 0, 3, -1, 0, -2, -1, 3)
#' rdailychange:::d4_method_from_vector(x)
d4_method_from_vector <- function(x) {
  n <- 4
  if (length(x) < n) {
    return(NULL)
  }

  x <- append(0, x) # made change
  dx <- x[-1] - x[-length(x)]
  d4_cands <- (dx[1:(length(dx) - (n - 1))] > 0 & dx[n:length(dx)] > 0) &
    middle_negative_test(dx)
  result <- calc_d4_method(d4_cands, dx)
  return(result)
}

#' @title D4 Method for Snow Loads
#' @description Given a dataframe, a column of which includes snow observations,
#'   this function will calculate the D4 Method.
#' @param df The dataframe containing snow observations.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#' @return A list of numeric vectors containing the observations
#' for the D4 Method (list split across 2 or more raw observations of 0).
#' @examples
#' ID <- rep("USW00023062", 13)
#' NAME <- rep("DENVER-STAPLETON", 13)
#' STATE <- rep("CO", 13)
#' LATITUDE <- rep(39.7633, 13)
#' LONGITUDE <- rep(-104.8694, 13)
#' DATE <- c(1950-11-08, 1950-11-09, 1950-11-10, 1950-11-11, 1950-11-12,
#'           1950-11-13, 1950-12-05, 1950-12-06, 1950-12-07, 1950-12-08,
#'           1951-01-06, 1951-01-07, 1951-01-08)
#' SWE <- c(22.553862, 29.897561, 15.685390, 11.953282, 8.247274, 4.224420,
#'          13.676186, 13.737334, 9.453138, 4.829772, 20.319270, 10.564117,
#'       10.595503)
#' sample_data <- data.frame(ID, NAME, STATE, LATITUDE, LONGITUDE, DATE, SWE)
#' rdailychange:::d4_method(sample_data)
#'
#' @export
d4_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d4_method_from_vector)
  result <- unlist(result) # made change
  result <- result[!(is.na(result))]
  return(result)
}

#' @title Extract Day-4 method observations
#' @description This function allows the user to extract sequential daily
#' changes (Day-1 method) in SWE.
#' @param station_data A data table of a measurement location/station.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#' @return A list with two elements. The first element is the Day-4
#' method observations, while the second element is the annual maximum load
#' for each snow year.
#'
#' @examples
#' sample_data <- rdailychange::sample_data
#' sample_data <- sample_data[ID == "USW00023062"]
#' rdailychange:::day4(sample_data, col_name = "SWE")
#'
day4 <- function(station_data, col_name) {

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


  DIFF <- d4_method(station_data, col_name)


  d4 <- data.table(ID, NAME, STATE, LONGITUDE, LATITUDE, DIFF)

  # modification by reference
  annual[, MONTH := as.numeric(format(as.Date(DATE), "%m"))]
  annual[, YEAR := as.numeric(format(as.Date(DATE), "%Y"))]
  annual[, YEAR := ifelse(MONTH > 07, YEAR + 1, YEAR)]


  annual <- annual[, .SD[, max(SWE)], by = .(
    ID, NAME, STATE, LONGITUDE,
    LATITUDE, YEAR
  )][, ANNUAL := V1][, V1 := NULL]

  output <- list("d4" = d4, "annual" = annual)
  return(output)
}
