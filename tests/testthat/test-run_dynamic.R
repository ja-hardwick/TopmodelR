test_that("dynamic model conserves water", {
  unit_tab <- data.frame(area = c(0.6, 0.4), tanb = c(0.1, 0.05), L = c(200, 100))
  W_units  <- matrix(c(0, 1,
                       0, 0), nrow = 2, byrow = TRUE)   # unit 1 drains to unit 2
  W_river  <- c(0, 1)                                    # unit 2 drains to the river

  rain <- c(0, 0.005, 0.01, 0.002, 0, 0, 0, 0)
  ETp  <- rep(0.0001, 8)

  out <- run_dynamic(rain = rain, ETp = ETp, unit_tab = unit_tab,
                     W_units = W_units, W_river = W_river,
                     S0 = 0.02, Sr0 = 0.01, SrMax = 0.04,
                     m = 0.03, lnTe = 2, td = 50, dt = 1, k0 = 0.004)

  expect_equal(sum(rain) - sum(out$qtot) - sum(out$ea),
               (0.02 - tail(out$s, 1)) + (0.01 - tail(out$srz, 1)) + tail(out$suz, 1))
})
