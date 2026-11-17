#' initial mean saturation deficit at the start
#'
#' Calculates the initial mean saturation deficit from the streamflow at the start, assuming all flow at that moment is baseflow
#' @param qs0 stream flow at the start, in m/h
#' @param lnTe log of saturated soil transmissivity, ln(m^2/h)
#' @param lambda area weighted mean topographic index, in ln(m)
#' @param m numeric value for decay of transmissivity as the soil dries, in m
#' @return numeric value of mean saturation deficit at the start, in m
#' @export
init_sbar <- function(qs0, lnTe, lambda, m){
  Sbar0 <- -m * log(qs0/ exp(lnTe - lambda))
  Sbar0
}

