#' Rotate a point around another point in 2D.
#'
#' @param x A numeric vector of x-coordinates.
#' @param y A numeric vector of y-coordinates.
#' @param cx A numeric values for the center x-coordinate.
#' @param cy A numeric values for the center y-coordinate.
#' @param angle_deg Rotation in degrees.
#'
#' @returns Matrix of rotated x and y.
#' @export
#'
#' @examples
#' rotate_around(3, 4, 1, 2, 90)
rotate_around <- function(x, y, cx, cy, angle_deg) {

  angle_rad <- angle_deg * (pi / 180)

  # Translate to the origin
  x0 <- x - cx
  y0 <- y - cy

  # Rotate
  xrot <- x0 * cos(angle_rad) - y0 * sin(angle_rad)
  yrot <- x0 * sin(angle_rad) + y0 * cos(angle_rad)

  # Translate back
  xnew <- xrot + cx
  ynew <- yrot + cy

  return(cbind(x = xnew, y = ynew))
}


#' @title GeomErrorBarD
#'
#' @description `GeomErrorBarD` proto type definition based on `ggplot2::GeomSegment`.
#'
#'
#' @export
GeomErrorbarD <- ggplot2::ggproto("GeomErrorbarD", ggplot2::GeomSegment,
  required_aes = c("x", "y", "radius", "angle_deg"),
  setup_data = function(data, params) {

    # center, start, and end
    data$cx <- data$x
    data$cy <- data$y
    data$xend <- data$x
    data <- transform(
      data,
      y = y - radius,
      yend = y + radius
    )

    # rotate
    rotated_start <- rotate_around(data$x, data$y, data$cx, data$cy, data$angle_deg)
    colnames(rotated_start) <- c("x", "y")
    rotated_end <- rotate_around(data$xend, data$yend, data$cx, data$cy, data$angle_deg)
    colnames(rotated_end) <- c("x", "y")

    # update
    data[, c("x", "y")] <- data.frame(rotated_start)
    data[, c("xend", "yend")] <- data.frame(rotated_end)

    return(data)
  }
)

#' @title Diagonal error bar
#'
#' @inheritParams ggplot2::geom_segment
#'
#' @description
#' Draw a diagonal (or arbitrarily oriented) error bar in a `ggplot2`, inherits from [ggplot2::geom_segment].
#'
#' The error bar is defined by aesthetic mappings for the center x coordinate (`x`), center y coordinate (`y`), breadth of the error interval (`radius`) on either side of the center, and angle of the error bar in degrees (`angle_deg`).
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
