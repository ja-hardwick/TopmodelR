#' Compute topographic index
#'
#' takes a regularly grided digital elevation model and minimum slope to calculate topographic index ready for run_topmodel
#'
#' @param dem a SpatRaster digital elevation model with puts filled and NA outside the catchment, in m
#' @param min_slope minimum slope for allowed to avoid dividing by zero on flat cells, default is 0.001
compute_ti <- function(dem, min_slope = 0.001) {
  cs   <- terra::res(dem)[1]

  fdir <- terra::terrain(dem, v = "flowdir")
  acc  <- terra::flowAccumulation(fdir)
  a    <- acc * cs

  tanb <- tan(terra::terrain(dem, v = "slope", unit = "radians"))
  tanb <- terra::clamp(tanb, lower = min_slope)

  log(a/tanb)
}
