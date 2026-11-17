#' Route flow
#'
#' route flow using time-area histogram from distance in time to outlet and fraction of the area.
#'
#' @param gen water generated each time step before routing, in m per time step
#' @param h time-area histogram, the fraction of flow arriving after hour 0
#' @return flow at the outlet each time step, in m per time step
#' @export
route_flow <- function(gen, h){
  n <- length(gen)
  out <- numeric(n)

  for (t in 1:n){
    for (k in seq_along(h)) {
      arrive <- t + k - 1
      if (arrive <= n){
        out[arrive] <- out[arrive] + h[k] * gen[t]
      }
    }
  }
  out
}
