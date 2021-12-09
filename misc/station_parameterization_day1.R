
## DAY1: STATION PARAMETERS

station_parameterization_day1 <- function(station_data) {
  station_data <- station_data %>%
    dplyr::select(ID, NAME, DATE, SWE)

  station_data <- station_data %>%
    mutate(diff = c(NA, diff(SWE))) %>%
    mutate(increase = ifelse(diff > 0, SWE, NA)) %>%
    mutate(decrease = ifelse(diff < 0, SWE, NA)) %>%
    dplyr::select(ID, NAME, DATE, SWE, diff, increase, decrease)



  station_data <- Remove_na_cols(station_data, "increase")


  if (nrow(station_data) < 30) {
    rm(station_data)
  } else {
    fit_gev <- extRemes::fevd(
      x = station_data$diff, type = "GEV",
      method = "Lmoments", time.units = "days"
    )

    y <- return.level(fit_gev, return.period = c(50, 100, 500))



    ID <- unique(station_data$ID)
    NAME <- unique(station_data$NAME)


    df <- data.frame(
      ID = ID,
      Station = NAME,
      NO_OF_OBSERVATIONS = nrow(station_data),
      DAY_CHANGE = 1,
      EVENT50 = y[1] * 20.88543 * 0.00980665, # convert from mm to psf
      EVENT100 = y[2] * 20.88543 * 0.00980665,
      EVENT500 = y[3] * 20.88543 * 0.00980665
    )

    return(df)
  }
}
