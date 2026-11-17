#' Unsaturated zone
#'
#' water is routed from the root zone through the unsaturated zone store.
#' @param Suz Numeric vector. Unsaturated zone storage at the start of the
#'   time step \[L\].
#' @param drain Numeric vector. Drainage into the unsaturated zone from the
#'   root zone during the time step \[L\].
#' @param S Numeric vector. Local saturation deficit \[L\]. Where `S <= 0` the
#'   location is saturated: no recharge occurs and all unsaturated storage
#'   becomes excess.
#' @param td Numeric. Unsaturated zone time delay per unit deficit \[T/L\].
#' @param dt Numeric. Time step length \[T\], in the same time units as `td`.
#'
#' @return A named list of numeric vectors, each the same length as `Suz`:
#'   \describe{
#'     \item{Suz}{Updated unsaturated zone storage at the end of the time
#'       step \[L\].}
#'     \item{quz}{Recharge from the unsaturated zone to the saturated zone
#'       \[L per time step\]. Never larger than the available storage.}
#'     \item{excess}{Storage above the local deficit, removed from the store
#'       \[L\]. Usually routed as saturation-excess overland flow.}
#'   }
#'   @export
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
