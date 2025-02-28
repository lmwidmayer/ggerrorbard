#' @title GeomErrorBarD
#'
#' @description `GeomErrorBarD` proto type definition based on `ggplot2::GeomSegment`.
#'
#'
#' @export
GeomErrorbarD <- ggplot2::ggproto("GeomErrorbarD", ggplot2::GeomSegment,
  required_aes = c("x", "y", "latitude", "angle"),
  setup_data = function(data, params) {
    # rotate start and end points around center points
    transform(data,
      xend = x + (cos(angle * pi / 180)) * latitude / 2,
      yend = y + (sin(angle * pi / 180)) * latitude / 2,
      x = x - (cos(angle * pi / 180)) * latitude / 2,
      y = y - (sin(angle * pi / 180)) * latitude / 2
    )
  }
)

#' @title Diagonal error bar
#'
#' @inheritParams ggplot2::geom_segment
#'
#' @description
#' Draw a diagonal (or arbitrarily oriented) error bar in a `ggplot2`, inherits from [ggplot2::geom_segment].
#'
#' The error bar is defined by aesthetic mappings for the center x coordinate (`x`), center y coordinate (`y`), total breadth of the error interval (`latitude`), and angle of the error bar in degrees (`angle`).
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
