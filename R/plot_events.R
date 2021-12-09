#' @title Map of MRIs or Annual MRIs Ratio
#' @description This function plots the MRIs or Annual MRIs Ratio on a USA map.
#'
#' @param df  A data frame of a fit summary object.
#' The fit summary includes MRIs or Annual MRIs Ratio of the respective
#' measurement locations.
#' @param event  MRI/event values to map. The default is 50, which maps the
#' 50-year.
#' MRI/event values. If the user specifies the value 100 or 500, the map will
#' show the 100-year or 500-year MRI/event values respectively.
#' @param annual Annual MRI Ratios of the respective measurement locations
#' are mapped. the default is FALSE.
#' @param size Size of points on the map. This is an integer value that
#' corresponds to the diameter of the points.
#' @return USA map of MRIs or Annual MRIs Ratio.
#' @export


plot_events <- function(df, size = 2.5, event = 50, annual = FALSE) {
  if (annual == FALSE & event == 50) {
    point_sf <- sf::st_as_sf(df,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          x = EVENT50,
          breaks = c(1, 5, 8, 10, 20, 60)
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
          "(1, 5]", "(5, 8]", "(8, 10]", "(10, 20]",
          "(20, 55]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 50) {
    point_sf <- sf::st_as_sf(df,
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
    point_sf <- sf::st_as_sf(df,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          X = EVENT100,
          breaks = c(1, 5, 8, 10, 20, 60)
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
          "(1, 5]", "(5, 8]", "(8, 10]", "(10, 20]",
          "(20, 55]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 100) {
    point_sf <- sf::st_as_sf(df,
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
    point_sf <- sf::st_as_sf(df,
      coords = c("LONGITUDE", "LATITUDE"),
      crs = 4326
    )


    ggplot2::ggplot() +
      ggplot2::geom_sf(data = usa) +
      ggplot2::geom_sf(data = point_sf, mapping = ggplot2::aes(
        colour = cut(
          x = EVENT500,
          breaks = c(1, 5, 8, 10, 20, 60)
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
          "(1, 5]", "(5, 8]", "(8, 10]", "(10, 20]",
          "(20, 55]"
        )
      ) +
      ggplot2::labs(x = "")
  } else if (annual == TRUE & event == 500) {
    point_sf <- sf::st_as_sf(df,
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
