lateral_flow <- function(S, tanb, L, lnTe, m, dt){
  T0 <- exp(lnTe)
  lat_fow <- ((T0 * tanb/L) * exp(-S/m)) * dt
  lat_fow
}
