#' @title GeomErrorBarD
#'
#' @description `GeomErrorBarD` proto type definition based on `ggplot2::GeomSegment`.
GeomErrorbarD <- ggplot2::ggproto("GeomErrorbarD", ggplot2::GeomSegment,
  required_aes = c("xcenter", "ycenter", "latitude", "angle"),
  setup_data = function(data, params) {
    transform(data,
      xend = xcenter + (cos(angle)) * latitude / 2,
      yend = ycenter + (sin(angle)) * latitude / 2,
      x = xcenter - (cos(angle)) * latitude / 2,
      y = ycenter - (sin(angle)) * latitude / 2
    )
  }
)

#' @title Diagonal error bar
#'
#' @inheritParams [ggplot2::geom_segment]
#' @param xcenter Aesthetic mapping for the center x coordinate of error bar. Use it instead of `x`.
#' @param ycenter Aesthetic mapping for the center y coordinate of error bar. Use it instead of `y`.
#' @param latitude Aesthetic mapping for the total breadth of the error interval. Use this instead of `xmin`, `xmax`, `ymin`, `ymax`.
#' @param angle Angle of error bars in radians.
#'
#' @description
#' Draw a diagonal (or arbitrarily oriented) error bar in a `ggplot2`.
#'
geom_errorbard <- function(mapping = NULL, data = NULL,
                           stat = "identity", position = "identity",
                           ...,
                           arrow = NULL,
                           na.rm = FALSE, show.legend = NA,
                           inherit.aes = TRUE) {
  ggplot2::layer(
    data = data,
    mapping = mapping,
    geom = GeomErrorbarD,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, arrow = arrow, ...)
  )
}
