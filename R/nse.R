#' Nash-Sutcliffe efficiency
#'
#' Measures how well simulated flow matches observed flow, relative to
#' simply predicting the mean of the observations.
#'
#' @param obs Observed flow, one value per time step.
#' @param sim Simulated flow, the same length and units as `obs`.
#' @return A single number. 1 is a perfect match; 0 is no better than
#'   predicting the mean of `obs`; below 0 is worse than the mean.
#' @export
nse <- function(obs, sim){
  nse <- 1 - sum((obs - sim)^2) /sum((obs - mean(obs))^2)
  nse
}
