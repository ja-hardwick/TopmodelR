test_that("water balance closes", {
  rain   <- c(0, 0.005, 0.01, 0, 0, 0.002, 0, 0)
  topidx <- data.frame(index = c(4, 8, 12), area = c(0.5, 0.3, 0.2))
  Sbar0  <- 0.05

  out <- run_topmodel(rain = rain, topidx = topidx, Sbar0 = Sbar0,
                      m = 0.03, lnTe = 1, dt = 1)

  expect_equal(sum(rain) - sum(out$qtot),
               Sbar0 - tail(out$sbar, 1))
})
