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
