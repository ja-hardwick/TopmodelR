#' run top model
#'
#' simulate catchment streamflow with TOPMODEL, tracking the mean saturation deficit and splitting rain into overland flow and infiltration, root zone and evaporation
#'
#' @param rain value of rainfall in m each timestep
#' @param topidx topographic index with two columns, index and area
#' @param Sbar0 initial mean soil moisture deficit, in m
#' @param lnTe log of the transmissivity of the saturated soil, ln(m^2/h)
#' @param dt timestep (hours)
#' @param m decay parameter for soil transmisitivty with deficit, in m
#' @param ETp potential evapotranspiration (m) used to calculate actual evapotranspiration
#' @param Sr0 inital mean soil moisture deficit in the root zone (m)
#' @param SrMax maximum mean soil moisture deficit in the root zone (m)
#' @returns returns data frame of baseflow (m), overland flow (m), total discharge (m) and catchment mean saturation deficit (m), actual evaporation and root zone deficit
#' @export
run_topmodel <- function(rain, topidx, Sbar0, lnTe, dt, m, ETp, Sr0, SrMax){

  n_steps <- length(rain)
  Sbar    <- Sbar0
  Srz <- Sr0
  qb      <- numeric(n_steps)
  qof     <- numeric(n_steps)
  sbar    <- numeric(n_steps)
  ea      <- numeric(n_steps)
  srz     <- numeric(n_steps)

  lambda <- mean_index(topidx = topidx)

  for (t in 1:n_steps) {
    S     <- local_deficit(Sbar = Sbar, m = m, lambda = lambda, index = topidx$index)
    split <- split_rain(rain = rain[t], S = S, area = topidx$area)
    qof[t] <- split$overland
    rz <- root_zone(Srz = Srz, infil = split$infiltration, ETp = ETp[t], SrMax = SrMax)
    qb[t]  <- baseflow(Sbar = Sbar, m = m, lnTe = lnTe, lambda = lambda, dt = dt)
    Sbar   <- Sbar + qb[t] - rz$drain
    sbar[t] <- Sbar
    Srz   <- rz$Srz
    ea[t] <- rz$Ea
    srz[t] <- Srz
  }
  data.frame(qb = qb,
             qof = qof,
             qtot = qb + qof,
             sbar = sbar,
             ea = ea,
             srz = srz)
}
