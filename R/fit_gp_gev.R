
#' @title Helper Function to Fit Extracted Observations
#' @description This function allows the user to fit a Generalized Extreme Value
#' (GEV) or a Generalized Pareto (GP) distribution to the
#'  extracted observations. the function does not fit Measurement locations
#' with less than 30.
#' @param list A list object of extracted observations.
#' @param type The type of distribution (GEV or GP) to fit to the observations.
#' The default is GEV.
#' @return A fit summary with measurement location metadata , MRIs and Annual
#' MRI ratios

fit_gp_gev <- function(list, type = "GEV") {

  # if GP is specified, fit a GP distribution to the observations
  if (type == "GP") {
    if (list[[1]][, .N] < 30) {

      # return an empty data table when number of observations is less than 30
      df <- data.table(
        ID = character(),
        NAME = character(),
        STATE = character(),
        LONGITUDE = numeric(),
        LATITUDE = numeric(),
        NO_OF_OBSERVATIONS = numeric(),
        DAY_CHANGE = numeric(),
        EVENT50 = numeric(),
        ANNUAL_RATIO50 = numeric(),
        EVENT100 = numeric(),
        ANNUAL_RATIO100 = numeric(),
        EVENT500 = numeric(),
        ANNUAL_RATIO500 = numeric()
      )

      return(df)
    } else {
      # fit GP distribution to annual and daily change observations
      fit_gp1 <- extremefit::hill.adapt(list[[1]]$DIFF)
      fit_gp2 <- extremefit::hill.adapt(list[[2]]$ANNUAL)


      # estimate the 50-year,100-year,and 500-year MRI for annual and
      # daily change observations
      y1 <- extremefit::predict.hill.adapt(fit_gp1,
        newdata = c(0.98, 0.99, 0.998),
        type = "quantile"
      )$y
      y2 <- extremefit::predict.hill.adapt(fit_gp2,
        newdata = c(0.98, 0.99, 0.998),
        type = "quantile"
      )$y

      # get station metadata
      ID <- unique(list[[1]]$ID)
      NAME <- unique(list[[1]]$NAME)
      STATE <- unique(list[[1]]$STATE)
      LONGITUDE <- unique(list[[1]]$LONGITUDE)
      LATITUDE <- unique(list[[1]]$LATITUDE)

      # create fit summary
      df <- data.table(
        ID = ID,
        NAME = NAME,
        STATE = STATE,
        LONGITUDE = LONGITUDE,
        LATITUDE = LATITUDE,
        NO_OF_OBSERVATIONS = nrow(list[[1]]),
        DAY_CHANGE = as.numeric(gsub("[^0-9.]", "", names(list)[[1]])),
        EVENT50 = y1[1] * 20.88543 * 0.00980665, # convert from mm to psf
        ANNUAL_RATIO50 = y1[1] / y2[1],
        EVENT100 = y1[2] * 20.88543 * 0.00980665,
        ANNUAL_RATIO100 = y1[2] / y2[2],
        EVENT500 = y1[3] * 20.88543 * 0.00980665,
        ANNUAL_RATIO500 = y1[3] / y2[3]
      )

      return(df)
    }
  } else if (type == "GEV") {

    # if GEV is specified, fit a GEV distribution to the observations
    if (list[[1]][, .N] < 30) {

      # return an empty data table when number of observations is less than 30
      df <- data.table(
        ID = character(),
        NAME = character(),
        STATE = character(),
        LONGITUDE = numeric(),
        LATITUDE = numeric(),
        NO_OF_OBSERVATIONS = numeric(),
        DAY_CHANGE = numeric(),
        EVENT50 = numeric(),
        ANNUAL_RATIO50 = numeric(),
        EVENT100 = numeric(),
        ANNUAL_RATIO100 = numeric(),
        EVENT500 = numeric(),
        ANNUAL_RATIO500 = numeric()
      )

      return(df)
    } else {
      # fit GEV distribution to annual and daily change observations
      fit_gev1 <- extRemes::fevd(
        x = list[[1]]$DIFF, type = "GEV",
        method = "Lmoments", time.units = "days"
      )

      fit_gev2 <- extRemes::fevd(
        x = list[[2]]$ANNUAL, type = "GEV",
        method = "Lmoments", time.units = "days"
      )

      # estimate the 50-year,100-year,and 500-year MRI for annual and
      # daily change observations
      y1 <- extRemes::return.level(fit_gev1, return.period = c(50, 100, 500))

      y2 <- extRemes::return.level(fit_gev2, return.period = c(50, 100, 500))

      # get station metadata
      ID <- unique(list[[1]]$ID)
      NAME <- unique(list[[1]]$NAME)
      STATE <- unique(list[[1]]$STATE)
      LONGITUDE <- unique(list[[1]]$LONGITUDE)
      LATITUDE <- unique(list[[1]]$LATITUDE)


      # create fit summary
      df <- data.table(
        ID = ID,
        NAME = NAME,
        STATE = STATE,
        LONGITUDE = LONGITUDE,
        LATITUDE = LATITUDE,
        NO_OF_OBSERVATIONS = nrow(list[[1]]),
        DAY_CHANGE = as.numeric(gsub("[^0-9.]", "", names(list)[[1]])),
        EVENT50 = y1[1] * 20.88543 * 0.00980665, # convert from mm to psf
        ANNUAL_RATIO50 = y1[1] / y2[1],
        EVENT100 = y1[2] * 20.88543 * 0.00980665,
        ANNUAL_RATIO100 = y1[2] / y2[2],
        EVENT500 = y1[3] * 20.88543 * 0.00980665,
        ANNUAL_RATIO500 = y1[3] / y2[3]
      )

      return(df)
    }
  }
}
