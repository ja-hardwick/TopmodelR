test_that("index is highest on the valley floor", {
  x    <- (1:21 - 11) * 50
  y    <- (30:1 - 1) * 50
  elev <- outer(y, x, function(y, x) 300 + 0.10 * abs(x) + 0.02 * y)
  dem  <- terra::rast(elev, extent = c(0, 21 * 50, 0, 30 * 50))

  ti   <- compute_ti(dem)
  best <- terra::rowColFromCell(ti, which.max(terra::values(ti)))

  expect_equal(best[, 2], 11)                       # centre column
  expect_true(all(is.finite(terra::values(ti, na.rm = TRUE))))
})
