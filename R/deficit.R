
#' Mean topographic index
#'
#' Area-weighted mean of the topographic index over all classes
#'
#' @param topidx Data frame with columns 'index' and 'area'
#' @return a single decimal value of lambda
#' @export
mean_index <- function(topidx) {
  sum(topidx$index * topidx$area)
}

#' local deficit
#'
#' Local deficit calculation that takes the mean saturation deficit (Sbar) in meters, m (meters) controls decay of soil transmisitivty
#'
#' @param Sbar mean saturation deficit in m
#' @param m decay parameter for soil transmisitivty with deficit, in meters
#' @param lambda single value of lambda
#' @param index a vector of topographic index values one per class
#' @return a numeric vector of local deficits in meters, one per class
#' @export
local_deficit <- function(Sbar, m, lambda, index){
  Sbar + m * (lambda - index)
}



