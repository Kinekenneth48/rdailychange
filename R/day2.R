

# HELPER FUNCTION 3 #####
# Because of HELPER FUNCTION 1, the HELPER FUNCTION 3 assumes to work with
# raw observations with no consecutive 0's.

# This function will take raw observations, make sure there is enough data to
# perform the D2 Method (if not, it will return NULL), and then calculate
# the D2 Method.
d2_method_from_vector <- function(x) {
  n <- 2
  if (length(x) < n) {
    return(NULL)
  }

  x = append(0,x) #made change
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
d2_method <- function(df, col_name = "SWE") {
  x <- df[[col_name]]
  split_observations <- split_across_n_m(x)
  result <- lapply(split_observations, d2_method_from_vector)
  result = unlist(result) #made change
  result = result[!(is.na(result))]
  return(result)
}








#' @title Extract Day-2 method observations
#' @description This function allows the user to extract sequential daily changes
#' (Day-1 method) in SWE.
#' @param station_data A data table of a measurement location/station.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#'
#' @return A list with two elements. The first element is the Day-2
#' method observations, while the second element is the annual maximum load
#' for each snow year.

day2 <- function(station_data, col_name) {

  # set data frame as data.table
  station_data <- data.table::setDT(station_data)


  # deep copy main_matrix to avoid modification by reference
  annual <- data.table::copy(station_data)


  #get station meta data
  ID = unique(station_data$ID)
  NAME = unique(station_data$NAME)
  STATE = unique(station_data$STATE)
  LONGITUDE = unique(station_data$LONGITUDE)
  LATITUDE = unique(station_data$LATITUDE)


  DIFF = d2_method(station_data, col_name)


  d2 = data.table(ID,NAME,STATE,LONGITUDE,LATITUDE ,DIFF )

  # modification by reference
  annual[, MONTH := as.numeric(format(as.Date(DATE), "%m"))]
  annual[, YEAR := as.numeric(format(as.Date(DATE), "%Y"))]
  annual[, YEAR := ifelse(MONTH > 07, YEAR + 1, YEAR)]


  annual <- annual[, .SD[, max(SWE)], by = .(
    ID, NAME, STATE, LONGITUDE,
    LATITUDE, YEAR
  )][, ANNUAL := V1][, V1 := NULL]

  output <- list("d2" = d2, "annual" = annual)
  return(output)
}
