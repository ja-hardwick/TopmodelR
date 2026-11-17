#' Topographic index classes
#'
#' Bins a topographic index map into evenly spaced classes and works out
#' the fraction of the catchment in each, giving the table that
#' run_topmodel() needs.
#'
#' @param ti A `SpatRaster` of topographic index values, with `NA`
#'   outside the catchment.
#' @param n Number of classes. Default 16.
#' @return A data frame with one row per class and two columns:
#'   \describe{
#'     \item{index}{Topographic index value at the middle of the class.}
#'     \item{area}{Fraction of the catchment in the class. Sums to 1.}
#'   }
#' @export
make_classes <- function(ti, n = 16) {
  v      <- terra::values(ti, na.rm = TRUE)
  breaks <- seq(min(v), max(v), length.out = n + 1)
  h      <- graphics::hist(v, breaks = breaks, plot = FALSE)

  data.frame(index = h$mids,
             area  = h$counts / sum(h$counts))
}

