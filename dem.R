library(terra)
library(topmodelR)

## --- Synthetic V-shaped valley -----------------------------------
cs    <- 50                    # cell size, m
nrow_ <- 60                    # 3 km long
ncol_ <- 41                    # 2 km wide, odd so there's a centre column

x <- (seq_len(ncol_) - 21) * cs          # distance from the valley centre, m
y <- (nrow_ - seq_len(nrow_)) * cs       # distance up-valley from the outlet, m

# Sides slope towards the centre at 10%; the valley floor slopes to the outlet at 2%
elev <- outer(y, x, function(y, x) 300 + 0.10 * abs(x) + 0.02 * y)

dem_test <- rast(elev, extent = c(0, ncol_ * cs, 0, nrow_ * cs))
plot(dem_test)

## --- Where is the river? -----------------------------------------
fdir_test  <- terrain(dem_test, v = "flowdir")
acc_test   <- flowAccumulation(fdir_test)
river_test <- acc_test > 100
plot(river_test)

river_na  <- ifel(river_test, 1, NA)
dist_test <- distance(river_na)
plot(dist_test)
global(dist_test, "max", na.rm = TRUE)

band_test <- floor(dist_test / 250) + 1
band_test <- clamp(band_test, upper = 4)
plot(band_test)
freq(band_test)

ti_test <- compute_ti(dem_test)

n_ti   <- 4
ti_min <- global(ti_test, "min", na.rm = TRUE)[1, 1]
ti_max <- global(ti_test, "max", na.rm = TRUE)[1, 1]
width  <- (ti_max - ti_min) / n_ti

class_test <- floor((ti_test - ti_min) / width) + 1
class_test <- clamp(class_test, upper = n_ti)
plot(class_test)

unit_test <- (band_test - 1) * n_ti + class_test
plot(unit_test)
freq(unit_test)

units <- zonal(ti_test, unit_test, fun = "mean", na.rm = TRUE)
names(units) <- c("unit", "index")
units

cnt <- freq(unit_test)
units$area <- cnt$count[match(units$unit, cnt$value)] / sum(cnt$count)

## 2. Band and class: worked back from the unit number
units$band  <- ceiling(units$unit / n_ti)
units$class <- (units$unit - 1) %% n_ti + 1

## 3. Mean slope per unit
tanb_test <- tan(terrain(dem_test, v = "slope", unit = "radians"))
sl <- zonal(tanb_test, unit_test, fun = "mean", na.rm = TRUE)
units$tanb <- sl[match(units$unit, sl[, 1]), 2]

units
sum(units$area)


fd <- values(fdir_test)[, 1]        # flow direction code of every cell
u  <- values(unit_test)[, 1]        # unit of every cell
rv <- values(river_test)[, 1]       # TRUE for river cells

codes <- c(1, 2, 4, 8, 16, 32, 64, 128)
drow  <- c(0, 1, 1, 1, 0, -1, -1, -1)
dcol  <- c(1, 1, 0, -1, -1, -1, 0, 1)

rc <- rowColFromCell(fdir_test, seq_len(ncell(fdir_test)))   # row and column of every cell
k  <- match(fd, codes)                                         # which direction each cell uses
down <- cellFromRowCol(fdir_test, rc[, 1] + drow[k], rc[, 2] + dcol[k])   # the cell it drains to

dest <- u[down]                            # unit of the downhill cell
dest[rv[down] %in% TRUE] <- 0              # draining into a river cell: send to the river (0)
dest[rv %in% TRUE]       <- 0              # river cells themselves drain to the river
dest[is.na(down)]        <- 0              # draining off the map at the outlet

keep <- !is.na(u) & !is.na(dest) & dest != u     # cells inside a unit, draining out of it
table(from = u[keep], to = dest[keep])

freq(unit_test)
for (i in c(6, 7, 8, 10, 11)) {
  cat("unit", i, ":\n")
  print(table(dest[u %in% i], useNA = "ifany"))
}

W <- prop.table(table(from = u[keep], to = dest[keep]), margin = 1)
round(W, 3)
rowSums(W)

cnt   <- freq(unit_test)
n_out <- rowSums(table(from = u[keep], to = dest[keep]))

units$cells <- cnt$count[match(units$unit, cnt$value)]
units$n_out <- n_out[match(units$unit, as.numeric(names(n_out)))]
units$L     <- units$cells / units$n_out * cs

units[, c("unit", "band", "cells", "n_out", "L")]

W_tab <- prop.table(table(from = u[keep], to = dest[keep]), margin = 1)

ids <- as.character(units$unit)
n_u <- nrow(units)

W_units <- matrix(0, n_u, n_u, dimnames = list(ids, ids))   # unit to unit
W_river <- setNames(numeric(n_u), ids)                       # unit to river

for (i in rownames(W_tab)) {
  for (j in colnames(W_tab)) {
    if (j == "0") {
      W_river[i] <- W_tab[i, j]
    } else {
      W_units[i, j] <- W_tab[i, j]
    }
  }
}

round(W_units, 3)
W_river
rowSums(W_units) + W_river

vol_out <- qout * units$area                          # volume each unit sends
qin     <- as.vector(t(W_units) %*% vol_out) / units$area   # depth arriving in each unit
