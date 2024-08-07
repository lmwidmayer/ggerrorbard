#' @title GeomErrorBarD
#'
#' @description `GeomErrorBarD` proto type definition based on `ggplot2::GeomSegment`.
#'
#' @export
GeomErrorbarD <- ggplot2::ggproto("GeomErrorbarD", ggplot2::GeomSegment,
  required_aes = c("xcenter", "ycenter", "latitude", "angle"),
  setup_data = function(data, params) {
    # rotate start and end points around center points
    transform(data,
      xend = xcenter + (cos(angle * pi / 180)) * latitude / 2,
      yend = ycenter + (sin(angle * pi / 180)) * latitude / 2,
      x = xcenter - (cos(angle * pi / 180)) * latitude / 2,
      y = ycenter - (sin(angle * pi / 180)) * latitude / 2
    )
  }
)

#' @title Diagonal error bar
#'

#' @param xcenter Aesthetic mapping for the center x coordinate of error bar. Use this instead of `x`.
#' @param ycenter Aesthetic mapping for the center y coordinate of error bar. Use this instead of `y`.
#' @param latitude Aesthetic mapping for the total breadth of the error interval. Use this instead of `xmin`, `xmax`, `ymin`, `ymax`.
#' @param angle Angle of error bars in degrees
#'
#' @description
#' Draw a diagonal (or arbitrarily oriented) error bar in a `ggplot2`, inherits from [ggplot2::geom_segment].
#'
#' @seealso [[ggplot2::geom_segment]]
#'
#' @export
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
