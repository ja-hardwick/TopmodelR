#' run top model
#'
#' simulate catchment streamflow with TOPMODEL, tracking the mean saturation deficit and splitting rain into overland flow and infiltration
#'
#' @param rain value of rainfall in meters each timestep
#' @param topidx topographic index with two columns, index and area
#' @param Sbar0 initial mean soil moisture deficit, in meters
#' @param lnTe log of the transmissivity of the saturated soil, ln(m^2/h)
#' @param dt timestep (hours)
#' @param m decay parameter for soil transmisitivty with deficit, in meters
#' @returns returns data frame of baseflow (m), overland flow (m), total discharge (m) and local soil deficit (m)
#' @export
run_topmodel <- function(rain, topidx, Sbar0, lnTe, dt, m){

  n_steps <- length(rain)
  Sbar    <- Sbar0
  qb      <- numeric(n_steps)
  qof     <- numeric(n_steps)
  sbar    <- numeric(n_steps)

  lambda <- mean_index(topidx = topidx)

  for (t in 1:n_steps) {
    S     <- local_deficit(Sbar = Sbar, m = m, lambda = lambda, index = topidx$index)                     # 1. local deficits from the current Sbar
    split <- split_rain(rain = rain[t], S = S, area = topidx$area)
    qof[t] <- split$overland
    qb[t]  <- baseflow(Sbar = Sbar, m = m, lnTe = lnTe, lambda = lambda, dt = dt)                    # 3. baseflow from the current Sbar
    Sbar   <- Sbar + qb[t] - split$infiltration
    sbar[t] <- Sbar
  }
  data.frame(qb = qb,
             qof = qof,
             qtot = qb + qof,
             sbar = sbar)
}
