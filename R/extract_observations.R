#' @title Extraction of Daily Change Observations
#' @description This function allows the user to extract sequential daily
#' changes from Snow Water Equivalent (SWE) observations. Day-1 observations
#' are sequential daily changes in SWE.
#' Day-2 observations assume that the shedding phenomenon occurs after two days.
#' Hence, Day-2 observations are a sum of two consecutive days of positive
#' sequential changes. Day-3, Day-4 and Day-5 observations are a sum of three,
#' four and five consecutive sequential daily changes respectively. In addition,
#' they allow for at most one middle sequential change to be a negative value as
#' long as the sum of the other sequential daily changes are greater than the
#' negative change.
#' @param df data frame of SWE and other measurement location metadata.
#' @param day Daily change method. This is an integer parameter. Default is
#' 1 for Day-1 method.
#' @param col_name Character string of the column name containing the
#'   snow observations.
#' @return A data table of measurement location's metadata and specified
#' daily sequential observations.
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
#' extract_observations(sample_data, day = 2)
#'
#' @export
#' @import  data.table
extract_observations <- function(df, day = 1, col_name = "SWE") {

  # convert data frame to data table and split into list by ID
  df <- data.table::setDT(df)
  los <- split(df, by = "ID")

  if (day == 1) {
    seq_obs <- lapply(X = los, FUN = day1, col_name)


    return(seq_obs)
  } else if (day == 2) {
    seq_obs <- lapply(X = los, FUN = day2, col_name)


    return(seq_obs)
  } else if (day == 3) {
    seq_obs <- lapply(X = los, FUN = day3, col_name)

    return(seq_obs)
  } else if (day == 4) {
    seq_obs <- lapply(X = los, FUN = day4, col_name)

    return(seq_obs)
  } else if (day == 5) {
    seq_obs <- lapply(X = los, FUN = day5, col_name)

    return(seq_obs)
  } else {
    stop("Error: day must be between 0 and 6")
  }
}
