
## DAY3: COMPUTE STATION PARAMETERS

# extract 3 consecutive days of  values
group_every_3days = function(group_days) {

  leng =  nrow(group_days)
  group_days = group_days%>%
    mutate(counter = rep(1:20, each = 3, len = leng))

  group_days = group_days[as.logical(ave(1:nrow(group_days),
              group_days$counter, FUN=function(x) length(x) > 2)), ]

  group_days = group_days %>%
    group_by(counter) %>%
    mutate(sum_changes = sum_of_3(diff))

  group_days = group_days[!duplicated(group_days$counter), ]

  return(group_days)
}









group_every_3days_main1 <- function(station_data) {


  station_data = station_data %>%
    dplyr::select(ID, NAME, DATE, SWE)

  ID = unique(station_data$ID)

  station_data = station_data %>%
    mutate(diff = c(NA, diff(SWE))) %>%
    mutate(increase = ifelse(diff > 0, SWE, NA))%>%
    mutate(decrease = ifelse( diff < 0, SWE, NA)) %>%
    dplyr::select(ID, NAME, DATE, SWE, diff, increase, decrease)

  station_data = station_data %>%
    filter(SWE != 0)



  if ( nrow(station_data) == 0 ) {
    # rm(my.data[[1]])
  }
  else {




    exceedance_info <- station_data %>%
      exceedance(x = DATE, y=diff, threshold = -200, minDuration = 3, maxGap=0)

    group_days = exceedance_info[["threshold"]]
    group_days = Remove_na_cols(group_days, "exceedance_no")
    group_days = group_days %>%
      dplyr::select(DATE, diff, exceedance_no) %>%
      mutate(ID = ID)

    group_days = group_days[with(group_days,
    ave(diff, list(exceedance_no, rev(cumsum(!(rev(diff) < 0)))),
        FUN=length) < 2 ),] # remove two or more consecutive negative numbers

    return(group_days)
  }
}












group_every_3days_main2 <- function(station_data) {
  if (nrow(station_data) == 0) {
    #rm(t)
  }
  else {

    ID = unique(station_data$ID)

    exceedance_info2 <- station_data %>%
      exceedance(x = DATE, y= diff, threshold = -200, minDuration = 3, maxGap=0)

    group_days = exceedance_info2[["threshold"]]
    group_days = Remove_na_cols(group_days, "exceedance_no")
    group_days = group_days %>%
      dplyr::select(DATE, diff, exceedance_no) %>%
      mutate(ID = ID)

    group_days = group_days %>%
      group_by(exceedance_no) %>%
      filter(any(row_number() > 2))

    group_days = group_days %>%
      ungroup() %>%
      group_split(exceedance_no)




    out =lapply(group_days, group_every_3days)

    return(out)
  }
}




station_parameterization_day3 = function(x) {


  df =  rbindlist(x) %>%
    ungroup() %>%
    dplyr::select(ID, DATE, sum_changes) %>%
    filter(sum_changes > 0)

  ID = unique(df$ID)

  if (nrow(df) < 30 ) {
    rm(df)
  }
  else {

    fit_gev = extRemes::fevd(x = df$sum_changes, type = "GEV", method = "Lmoments", time.units = "days")

    y = return.level(fit_gev, return.period = c(50, 100, 500))

    df_parameters <- data.frame(ID = ID,
                     NO_OF_OBSERVATIONS = nrow(df),
                     DAY_CHANGE = 3,
                     EVENT50 = y[1]* 0.00980665 * 20.88543,
                     EVENT100 = y[2]* 0.00980665* 20.88543,
                     EVENT500 = y[3]* 0.00980665* 20.88543)
    return(df_parameters)
  }
}


