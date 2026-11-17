#' run top model
#'
#' simulate catchment streamflow with TOPMODEL, tracking the mean saturation deficit and splitting rain into overland flow and infiltration, root zone and evaporation
#'
#' @param rain value of rainfall in m each timestep
#' @param topidx topographic index with two columns, index and area
#' @param qs0 stream flow at the start, in m/h
#' @param lnTe log of the transmissivity of the saturated soil, ln(m^2/h)
#' @param dt timestep (hours)
#' @param m decay parameter for soil transmisitivty with deficit, in m
#' @param ETp potential evapotranspiration (m) used to calculate actual evapotranspiration
#' @param Sr0 inital mean soil moisture deficit in the root zone (m)
#' @param SrMax maximum mean soil moisture deficit in the root zone (m)
#' @returns returns data frame of baseflow (m), overland flow (m), total discharge (m) and catchment mean saturation deficit (m), actual evaporation and root zone deficit
#' @export
run_topmodel <- function(rain, topidx, qs0, lnTe, dt, m, ETp, Sr0, SrMax, td){

  n_steps <- length(rain)
  n_class <- nrow(topidx)

  Srz <- rep(Sr0, n_class)
  Suz <- rep(0, n_class)

  qb      <- numeric(n_steps)
  qof     <- numeric(n_steps)
  ea      <- numeric(n_steps)
  sbar    <- numeric(n_steps)
  srz     <- numeric(n_steps)
  suz     <- numeric(n_steps)

  lambda <- mean_index(topidx = topidx)
  Sbar <- init_sbar(qs0 = qs0, lnTe = lnTe, lambda = lambda, m = m)

  for (t in 1:n_steps) {
    S     <- local_deficit(Sbar = Sbar, m = m, lambda = lambda, index = topidx$index)
    rz <- root_zone(Srz = Srz, infil = rain[t], ETp = ETp[t], SrMax = SrMax)
    uz <- unsat_zone(Suz = Suz, drain = rz$drain, S = S, td = td, dt = dt)

    recharge <- sum(uz$quz * topidx$area)
    qb[t]  <- baseflow(Sbar = Sbar, m = m, lnTe = lnTe, lambda = lambda, dt = dt)
    Sbar   <- Sbar + qb[t] - recharge

    Srz <- rz$Srz
    Suz <- uz$Suz

    qof[t] <- sum(uz$excess * topidx$area)
    ea[t] <- sum(rz$Ea * topidx$area)
    sbar[t] <- Sbar
    srz[t] <- sum(Srz * topidx$area)
    suz[t] <- sum(Suz * topidx$area)
  }

  data.frame(qb = qb,
             qof = qof,
             qtot = qb + qof,
             sbar = sbar,
             ea = ea,
             srz = srz,
             suz = suz)
}
