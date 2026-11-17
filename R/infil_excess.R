#' Infiltration excess overland flow for one time step
#'
#' Splits rainfall into infiltration excess overland flow and water that
#' infiltrates. Rain falling faster than the surface can absorb it runs
#' off; the rest soaks in. Uses a constant infiltration capacity, k0,
#' which does not depend on how wet the soil is.
#'
#' @param rain Rainfall this time step (m).
#' @param k0 Surface hydraulic conductivity, the infiltration capacity (m/h).
#' @param dt Time step length (hours).
#' @return A list with two elements, both in m per time step:
#'   \describe{
#'     \item{fex}{Infiltration excess overland flow.}
#'     \item{infil}{Water that infiltrates, passed on to the root zone.}
#'   }
#' @export
infil_excess <- function(rain, k0, dt){
  capacity <- k0 * dt
  fex <- pmax(0, rain - capacity)
  infil <- rain - fex
  list(fex = fex, infil = infil)

}
