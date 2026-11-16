#' split rain
#'
#' Calculates infiltration and overland flow given rain input
#'
#' @param rain value of rainfall in meters each timestep
#' @param S local soil water deficit in meters per class
#' @param area area fraction
#' @returns list of two values for overland and infiltration in meters
#' @export
split_rain <- function(rain, S, area){
  sat_frac <- sum(area[S <= 0])
  Q_of <- rain * sat_frac
  infil <- rain - Q_of
  list(overland = Q_of,
       infiltration = infil)
}
