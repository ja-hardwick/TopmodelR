unsat_zone <- function(Suz, drain, S, td, dt) {
  Suz <- Suz + drain

  room   <- pmax(0, S)
  excess <- pmax(0, Suz - room)
  Suz    <- Suz - excess

  quz <- ifelse(S > 0, Suz / (S * td) * dt, 0)
  quz <- pmin(quz, Suz)
  Suz <- Suz - quz

  list(Suz = Suz, quz = quz, excess = excess)
}
