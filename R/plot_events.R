#' @title Map of MRIs or Annual MRIs Ratio
#' @description This function plots the MRIs or Annual MRIs Ratio on a USA map.
#'
#' @param x A data frame of a fit summary object.
#' The fit summary includes MRIs or Annual MRIs Ratio of the respective
#' measurement locations.
#' @param y Ignore for this implementation
#' @param event  MRI/event values to map. The default is 50, which maps the
#' 50-year.
#' MRI/event values. If the user specifies the value 100 or 500, the map will
#' show the 100-year or 500-year MRI/event values respectively.
#' @param annual Annual MRI Ratios of the respective measurement locations
#' are mapped. the default is FALSE.
#' @param size Size of points on the map. This is an integer value that
#' corresponds to the diameter of the points.
#' @param ...  Additional arguments passed to optim as necessary.
#' @return USA map of MRIs or Annual MRIs Ratio.
#' @examples
#' sample_data <- rdailychange::sample_data
#' sample_data <- sample_data[ID == "USW00023062"]
#' x <- extract_observations(sample_data, day = 2)
#' y <- fit_observations(x)
#' rdailychange:::plot.dailychange(y)
#'
#' @export
plot.dailychange <- function(x, y, size = 2.5, event = 50,
                             annual = FALSE, ...) {
  if (annual == FALSE & event == 50) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          x = EVENT50,
          breaks = c(1, 5, 10, 15, 20, 90)
        )
      ), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "MRI",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(1, 5]", "(5, 10]", "(10, 15]", "(15, 20]",
          "(20, 90]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 50) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )

    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, ggplot2::aes(colour = cut(
        x = ANNUAL_RATIO50,
        breaks = c(0, .2, .4, .6, 0.8, 1)
      )), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "RATIO",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(0, 0.2]", "(0.2, 0.4]", "(0.4, 0.6]",
          "(0.6, 0.8]", "(0.8, 1]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == FALSE & event == 100) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          X = EVENT100,
          breaks = c(1, 5, 10, 15, 20, 90)
        )
      ), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "MRI",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(1, 5]", "(5, 10]", "(10, 15]", "(15, 20]",
          "(20, 90]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 100) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )

    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, ggplot2::aes(colour = cut(
        x = ANNUAL_RATIO100,
        breaks = c(0, .2, .4, .6, 0.8, 1)
      )), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "RATIO",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(0, 0.2]", "(0.2, 0.4]", "(0.4, 0.6]",
          "(0.6, 0.8]", "(0.8, 1]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == FALSE & event == 500) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          x = EVENT500,
          breaks = c(1, 5, 10, 15, 20, 90)
        )
      ), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "MRI",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(1, 5]", "(5, 10]", "(10, 15]", "(15, 20]",
          "(20, 90]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 500) {
    point_sf <- sf::st_as_sf(x,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )

    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, ggplot2::aes(colour = cut(
        x = ANNUAL_RATIO500,
        breaks = c(0, .2, .4, .6, 0.8, 1)
      )), alpha = 1, size = size) +
      ggplot2::coord_sf(xlim = c(-125, -67), ylim = c(20, 50)) +
      ggplot2::scale_color_manual(
        name = "RATIO",
        values = c(
          "#440154FF",
          "#3B528BFF",
          "#21908CFF",
          "#5DC863FF",
          "#FDE725FF"
        ),
        labels = c(
          "(0, 0.2]", "(0.2, 0.4]", "(0.4, 0.6]",
          "(0.6, 0.8]", "(0.8, 1]"
        )
      ) +
      ggplot2::labs(x = "")
  }
}
