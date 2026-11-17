#' topmodelR: TOPMODEL in R
#'
#' A from-scratch implementation of TOPMODEL (Beven and Kirkby, 1979;
#' Beven et al., 1995), with tools for preparing topographic index
#' classes from a DEM and for comparing simulations with observations.
#'
#' @section Units and conventions:
#' * Depths of water are in metres, and fluxes are in metres per time step.
#' * Rates such as `k0` and `qs0` are per hour; `dt` converts them to per time step.
#' * **Deficits** are empty space and go up when water leaves.
#'   **Storage** is water held and goes up when water arrives.
#' * Capitals (`Sbar`, `Srz`, `Suz`) are working values inside the loop;
#'   lowercase (`sbar`, `srz`, `suz`) are the records returned.
#' * A trailing `0` (`Sr0`, `qs0`) means the value at the start.
#'
#' @section Inputs:
#' | Name | Meaning | Units |
#' |---|---|---|
#' | `rain` | Rainfall, one value per time step | m per time step |
#' | `ETp` | Potential evapotranspiration, one value per time step | m per time step |
#' | `topidx` | Topographic index classes: columns `index` and `area` | ln(m); fraction |
#' | `dt` | Length of each time step | h |
#'
#' @section Parameters:
#' | Name | Meaning | Units |
#' |---|---|---|
#' | `m` | Decay of transmissivity as the soil dries | m |
#' | `lnTe` | Log of saturated soil transmissivity | ln(m^2/h) |
#' | `SrMax` | Root zone capacity, its largest possible deficit | m |
#' | `Sr0` | Root zone deficit at the start | m |
#' | `td` | Unsaturated zone delay per metre of deficit | h/m |
#' | `qs0` | Streamflow at the start, used to find `Sbar0` | m/h |
#' | `k0` | Surface infiltration capacity; `Inf` turns infiltration excess off | m/h |
#' | `h` | Time-area histogram for routing; `1` means no routing | fractions summing to 1 |
#'
#' @section Internal state:
#' | Name | Meaning | Units | Shape | Measured as |
#' |---|---|---|---|---|
#' | `lambda` | Area-weighted mean topographic index | ln(m) | one value | - |
#' | `Sbar` | Mean saturation deficit | m | one value | deficit |
#' | `S` | Local saturation deficit | m | one per class | deficit |
#' | `Srz` | Root zone deficit | m | one per class | deficit |
#' | `Suz` | Water in the unsaturated zone | m | one per class | storage |
#'
#' @section Fluxes within a time step:
#' | Name | Meaning | From - to |
#' |---|---|---|
#' | `fex` | Infiltration excess overland flow | rain - stream |
#' | `drain` | Overflow from the root zone | root zone - unsaturated zone |
#' | `quz` | Drainage to the water table | unsaturated zone - saturated zone |
#' | `excess` | Water beyond a class's local deficit | unsaturated zone - stream |
#' | `Ea` | Actual evapotranspiration | root zone - air |
#' | `qb` | Baseflow | saturated zone - stream |
#'
#' @section Outputs of run_topmodel():
#' | Column | Meaning | Units |
#' |---|---|---|
#' | `qb` | Baseflow | m per time step |
#' | `qof` | Overland flow, saturation excess plus `fex` | m per time step |
#' | `fex` | Infiltration excess part of `qof` | m per time step |
#' | `qtot` | Flow entering the channel, `qb + qof` | m per time step |
#' | `q` | Flow at the outlet, after routing | m per time step |
#' | `ea` | Actual evapotranspiration | m per time step |
#' | `sbar` | Mean saturation deficit, end of step | m |
#' | `srz` | Root zone deficit, area-weighted, end of step | m |
#' | `suz` | Unsaturated zone storage, area-weighted, end of step | m |
#'
#' @section Terrain:
#' | Name | Meaning | Units |
#' |---|---|---|
#' | `a` | Upslope area per unit contour length | m |
#' | `tan β` | Local slope | m/m |
#' | `ti` | Topographic index, ln(a / tan β) | ln(m) |
#' | `min_slope` | Smallest slope allowed, to avoid dividing by zero | m/m |
#'
#' @section Functions:
#' * Terrain: [compute_ti()], [make_classes()]
#' * Model: [run_topmodel()], built from [mean_index()], [init_sbar()],
#'   [local_deficit()], [infil_excess()], [root_zone()], [unsat_zone()],
#'   [baseflow()] and [route_flow()]
#' * Evaluation: [nse()]
#'
#' @references
#' Beven, K. J. and Kirkby, M. J. (1979). A physically based, variable
#' contributing area model of basin hydrology. Hydrological Sciences
#' Bulletin, 24(1), 43-69.
#'
#' Beven, K., Lamb, R., Quinn, P., Romanowicz, R. and Freer, J. (1995).
#' TOPMODEL. In V. P. Singh (Ed.), Computer Models of Watershed Hydrology.
#' Water Resources Publications.
"_PACKAGE"
