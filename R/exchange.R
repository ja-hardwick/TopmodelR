exchange <- function(qout, area, W_units, W_river){
  vol_out <- qout * area
  qin     <- as.vector(t(W_units) %*% vol_out) / area
  q_river <- sum(vol_out * W_river)
  list(qin = qin, q_river = q_river)
}
