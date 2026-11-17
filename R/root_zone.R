#' root zone water balance for one time step
#'
#'Fills the root zone with infiltration, drains any water beyond capacity to the saturated zone, water removed via evaporation.
#'
#'@param Srz Root zone storage deficit at the start of the time step (m). 0 means full; `SrMax` means completely dry.
#' @param infil Infiltration reaching the root zone this time step (m).
#' @param ETp Potential evapotranspiration this time step (m).
#' @param SrMax Maximum root zone storage deficit, the root zone's capacity (m).
#' @return A list with three elements, all in m per time step:
#'   \describe{
#'     \item{Srz}{Root zone deficit at the end of the time step.}
#'     \item{Ea}{Actual evapotranspiration.}
#'     \item{drain}{Water draining to the saturated zone.}
#'   }
#' @export
root_zone <- function(Srz, infil, ETp, SrMax){
  Srz <- Srz - infil
  drain <- max(0, -Srz)
  Srz <- max(0, Srz)

  Ea <- ETp * (1 - Srz/ SrMax)
  Srz <- Srz + Ea

  list(Srz = Srz, Ea = Ea, drain = drain)
}
