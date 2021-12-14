#' Daily snow water equivalent (SWE) of 7 weather stations across the US.
#'
#' @description This data contains 158,627 daily snow water equivalent (SWE) of
#' 7 weather stations across the US from October 1, 1950, to June 30, 2020.
#' The snow load values are measured in millimeters (mm). For each station,
#' the data contains a complete coverage of the 70 snow seasons.
#'
#' @format A data frame with 158,627 rows and 7 variables:
#' \describe{
#'   \item{ID}{This represents the station's ID.}
#'   \item{NAME}{Weather Station Name.}
#'   \item{STATE}{The state of the weather station.}
#'   \item{LATITUDE}{The angular distance of the station north or south of the
#'   earth's equator. This is expressed in degrees.}
#'   \item{LONGITUDE}{The angular distance of the weather east or west of the
#'   meridian at Greenwich, England, or west of the standard meridian of a
#'   celestial object. This is expressed in degrees.}
#'   \item{DATE}{This is the date the snow water equivalent was recorded.}
#'   \item{SWE}{This is the snow water equivalent value recorded.}
#' }
#' @source \url{https://www.ncei.noaa.gov/data/global-historical-climatology-network-daily/doc/GHCND_documentation.pdf}
"sample_data"



#' Daily snow water equivalent (SWE) of 100 weather stations across the US.
#'
#' @description This data contains 2,547,600 daily snow water equivalent (SWE)
#' of 100 weather stations across the US from October 1, 1950, to June 30, 2020.
#' The snow load values are measured in millimeters (mm). For each station,
#' the data contains a complete coverage of the 70 snow seasons.
#'
#' @format A data frame with 2,547,600 rows and 7 variables:
#' \describe{
#'   \item{ID}{This represents the station's ID.}
#'   \item{NAME}{Weather Station Name.}
#'   \item{STATE}{The state of the weather station.}
#'   \item{LATITUDE}{The angular distance of the station north or south of the
#'   earth's equator. This is expressed in degrees.}
#'   \item{LONGITUDE}{The angular distance of the weather east or west of the
#'   meridian at Greenwich, England, or west of the standard meridian of a
#'   celestial object. This is expressed in degrees.}
#'   \item{DATE}{This is the date the snow water equivalent was recorded.}
#'   \item{SWE}{This is the snow water equivalent value recorded.}
#' }
#' @source \url{https://www.ncei.noaa.gov/data/global-historical-climatology-network-daily/doc/GHCND_documentation.pdf}
"snow_daily"
