

## DAY2: COMPUTE STATION PARAMETERS

# extract consecutive days of positive values
group_every_2days <- function(group_days) {
  length <- nrow(group_days)

  group_days <- group_days %>%
    group_by(exceedance_no) %>%
    mutate(counter = rep(1:20, each = 2, len = length))

  group_days <- group_days[as.logical(ave(1:nrow(group_days),
    group_days$counter,
    FUN = function(x) length(x) > 1
  )), ] %>%
    group_by(counter) %>%
    mutate(sum_changes = sum(diff))

  group_days <- group_days[!duplicated(group_days$counter), ] # remove duplicate after summing up


  return(group_days)
}





group_every_2days_main <- function(station_data) {
  station_data <- station_data %>%
    dplyr::select(ID, NAME, DATE, SWE)

  ID <- unique(station_data$ID)

  station_data <- station_data %>%
    mutate(diff = c(NA, diff(SWE))) %>%
    mutate(increase = ifelse(diff > 0, SWE, NA)) %>%
    mutate(decrease = ifelse(diff < 0, SWE, NA)) %>%
    dplyr::select(ID, NAME, DATE, SWE, diff, increase, decrease)

  station_data <- Remove_na_cols(station_data, "increase")


  if (nrow(station_data) == 0) {
    # rm(my.data[[1]])
  } else {
    exceedance_info <- station_data %>%
      exceedance(x = DATE, y = diff, threshold = 0, minDuration = 2, maxGap = 0)

    consecutive_days_id <- exceedance_info[["threshold"]]
    consecutive_days_id <- Remove_na_cols(consecutive_days_id, "exceedance_no")
    consecutive_days_id <- consecutive_days_id %>%
      dplyr::select(DATE, diff, exceedance_no) %>%
      mutate(ID = ID)

    group_days <- consecutive_days_id %>%
      group_split(exceedance_no)



    out <- lapply(group_days, group_every_2days)

    return(out)
  }
}




station_parameterization_day2 <- function(x) {
  df <- rbindlist(x) %>%
    ungroup() %>%
    dplyr::select(ID, DATE, sum_changes)

  ID <- unique(df$ID)

  if (nrow(df) < 30) {
    rm(df)
  } else {
    fit_gev <- extRemes::fevd(
      x = df$sum_changes, type = "GEV",
      method = "Lmoments", time.units = "days"
    )

    y <- return.level(fit_gev, return.period = c(50, 100, 500))

    df_parameters <- data.frame(
      ID = ID,
      NO_OF_OBSERVATIONS = nrow(df),
      DAY_CHANGE = 2,
      EVENT50 = y[1] * 0.00980665 * 20.88543,
      EVENT100 = y[2] * 0.00980665 * 20.88543,
      EVENT500 = y[3] * 0.00980665 * 20.88543
    )
    return(df_parameters)
  }
}
