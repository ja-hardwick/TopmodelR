run_dynamic <- function(rain, ETp, unit_tab, W_units, W_river,
                        S0, Sr0, SrMax, m, lnTe, td, dt, k0 = Inf) {

  n_steps <- length(rain)
  n_u     <- nrow(unit_tab)
  area    <- unit_tab$area

  # Working values: one per unit
  S   <- rep(S0,  length.out = n_u)     # saturated zone deficit
  Srz <- rep(Sr0, length.out = n_u)     # root zone deficit
  Suz <- rep(0,   n_u)                  # unsaturated zone storage

  # Records: one per time step
  qb  <- numeric(n_steps)   # subsurface flow reaching the river
  qof <- numeric(n_steps)   # overland flow: infiltration excess + saturation excess + return flow
  ea  <- numeric(n_steps)
  s   <- numeric(n_steps)   # area-weighted saturated deficit
  srz <- numeric(n_steps)
  suz <- numeric(n_steps)

  for (t in 1:n_steps) {
    ie <- infil_excess(rain = rain[t], k0 = k0, dt = dt)
    rz <- root_zone(Srz = Srz, infil = ie$infil, ETp = ETp[t], SrMax = SrMax)
    uz <- unsat_zone(Suz = Suz, drain = rz$drain, S = S, td = td, dt = dt)

    qout <- lateral_flow(S = S, tanb = unit_tab$tanb, L = unit_tab$L,
                         lnTe = lnTe, m = m, dt = dt)
    ex   <- exchange(qout = qout, area = area, W_units = W_units, W_river = W_river)

    S  <- S + qout - uz$quz - ex$qin
    rf <- pmax(0, -S)
    S  <- pmax(0, S)

    Srz <- rz$Srz
    Suz <- uz$Suz

    qb[t]  <- ex$q_river
    qof[t] <- ie$fex + sum((uz$excess + rf) * area)
    ea[t]  <- sum(rz$Ea * area)
    s[t]   <- sum(S * area)
    srz[t] <- sum(Srz * area)
    suz[t] <- sum(Suz * area)
  }

  data.frame(qb = qb, qof = qof, qtot = qb + qof,
             ea = ea, s = s, srz = srz, suz = suz)
}
