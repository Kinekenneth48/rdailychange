#' @title Fit Extracted Observations
#' @description This function allows the user to fit a Generalized Extreme Value
#' (GEV) or a Generalized Pareto (GP) distribution to the
#'  extracted observations. The function does not fit Measurement locations
#' with less than 30.
#' @param list A list object of extracted observations.
#' @param type The type of distribution (GEV or GP) to fit to the observations.
#' The default is GEV.
#' @return A fit summary with measurement location metadata , MRIs and Annual
#' MRI ratios.
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
#' t <- extract_observations(sample_data, day = 2)
#' fit_observations(t)
#'
#' @export fit_observations
#' @export
fit_observations <- function(list, type = "GEV") {
  fit_summary <- rbindlist(lapply(X = list, FUN = fit_gp_gev, type))

  fit_summary <- structure(fit_summary, class = c(
    "dailychange", "data.table",
    "data.frame"
  ))
  return(fit_summary)
}
