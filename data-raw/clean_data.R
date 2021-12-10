
# ============================================================================#
# Step 0: load required packages and data set
# ============================================================================#
library(data.table)


# The raw data and station data can be download from ....
raw_data <- data.table::fread("data-raw/fos_data.csv")
stations <- data.table::fread("data-raw/stations.csv")

raw_data$QFLAG <- as.character(raw_data$QFLAG)
raw_data$MFLAG <- as.character(raw_data$MFLAG)

# ============================================================================#
# Step 1:  Remove all measurements from the dataset that fail  MFLAG & QFLAG
#          checks
# ============================================================================#

# remove  "missing presumed zero" measurements and any fail quality checks
raw_data <- raw_data[!(MFLAG %chin% c("P"))][!(QFLAG %chin% c(
  "D", "G", "I", "K", "L", "M", "N", "O", "R", "S", "T", "W", "X", "Z"
))]


# ============================================================================#
# Step 2: Filter date range of dataset and convert into list by ID
# ============================================================================#

raw_data <- raw_data[, .(ID, DATE, ELEMENT, VALUE)][DATE >=
  "1950-10-01" & DATE <= "2020-06-30"]

ls_fos <- split(raw_data, by = "ID")



# ============================================================================#
# Step 3: Create a function to extract SWE for consecutive days within
#         the specified date range. If snow depth is available for a particular
#         day while snow water equivalent is not available, the SWE is imputed
#          using the Hill's method. Else the SWE value is imputed as zero.
# ============================================================================#

wesd_conversion <- function(station_data) {

  # get station ID
  id <- unique(station_data$ID)

  # deep copy station data
  swe <- data.table::copy(station_data)
  snwd <- data.table::copy(station_data)

  # filter SWE values and convert to mm
  swe <- swe[ELEMENT == "WESD"][, .(DATE, VALUE)][, VALUE := VALUE / 10]
  data.table::setnames(swe, "VALUE", "SWE")


  # filter SNWD values
  snwd <- snwd[ELEMENT == "SNWD"][, .(DATE, VALUE)]
  data.table::setnames(snwd, "VALUE", "SNWD")



  # create a new data table with specified date range and station ID
  DT <- data.table(
    DATE = seq(
      from = as.Date("1950-10-01"),
      to = as.Date("2020-06-30"), by = "day"
    ),
    ID = id
  )



  # combine SWE AND SNWD into the newly created data table

  DT <- merge.data.table(DT, stations, by = "ID", all.x = TRUE)
  DT <- DT[, .(ID, NAME, LONGITUDE, LATITUDE, DATE)]

  DT <- merge.data.table(DT, snwd, by = "DATE", all.x = TRUE)

  DT <- merge.data.table(DT, swe, by = "DATE", all.x = TRUE)





  # R1: replace zero wesd with NA when snwd is positive
  DT[, SWE := ifelse(SNWD > 0 & SWE == 0, NA, SWE)]


  # remove outlier not detected by 2020 National Snow study
  DT[, SWE := ifelse(SWE == 2291.10000 & ID == "USW00014735", NA, SWE)]



  # impute the missing SWE values with SNWD using the Hill's method
  DT[, SWE_HILL := hill_conversion(
    h = snwd, lon = LONGITUDE,
    lat = LATITUDE, date = DATE
  )]


  DT[, SWE := ifelse(is.na(SWE) & SNWD > 0, SWE_HILL, SWE)]



  # replace na with zero
  DT[, SWE := ifelse(is.na(SWE), 0, SWE)]



  return(DT)
}


# ============================================================================#
# Step 4: Apply wesd_conversion function to list of station data to get
#         a full coverage of SWE for specified date range
# ============================================================================#


clean_dataset <- lapply(ls_fos, FUN = wesd_conversion)



# ============================================================================#
# Step 6: Write data into data folder
# ============================================================================#

usethis::use_data(clean_dataset, overwrite = TRUE)
