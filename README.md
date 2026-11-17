## TOPMODEL in R

An R implementation of TOPMODEL, the rainfall-runoff model originally written in Fortran by [Beven (1995)](https://hess.copernicus.org/articles/25/527/2021/). 
Whilst [others](https://github.com/ICHydro/topmodel/tree/master/topmodel) have converted the original Fortran code to R; I'm writing my own for two reasons:

- **To try and learn:** I want to understand how R packages are built and how they develop over time.
- **To use it in my work:** I work with TOPMODEL, so an easily accessible version is helpful.

 ## Installation
```r
# install.packages("remotes")
remotes::install_github("ja-hardwick/TopmodelR")
```
See `?topmodelR` for a glossary of every variable and parameter.

## Example

```r
library(topmodelR)

ti     <- compute_ti(dem)          # dem: a SpatRaster
topidx <- make_classes(ti, n = 16)

out <- run_topmodel(rain = rain, ETp = ETp, topidx = topidx,
                    qs0 = 0.0001, Sr0 = 0.01, SrMax = 0.05,
                    m = 0.02, lnTe = 2, td = 20, dt = 1)
```

## Licence
GPL-3

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->
