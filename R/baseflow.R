#' baseflow
#'
#' Calculates base flow
#'
#' @param Sbar description
#' @param m description
#' @param lnTe description
#' @param lambda description
#' @param dt description
#' @return description
#' @export
baseflow <- function(Sbar, m, lnTe, lambda, dt){
  Q_0 <- exp(lnTe - lambda) * dt
  Q_b <- Q_0 * exp(-Sbar/m)
  Q_b
}
