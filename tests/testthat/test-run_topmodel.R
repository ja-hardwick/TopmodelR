test_that("water balance closes", {
  rain   <- c(0, 0.005, 0.01, 0, 0, 0.002, 0, 0)
  topidx <- data.frame(index = c(4, 8, 12), area = c(0.5, 0.3, 0.2))
  Sbar0  <- 0.05
  ETp <- rep(0.0001, 8)
  Sr0 <- 0.01
  SrMax <- 0.04

  out <- run_topmodel(rain = rain, ETp = ETp, topidx = topidx,
                      Sbar0 = Sbar0, Sr0 = Sr0, SrMax = SrMax,
                      m = 0.03, lnTe = 1, dt = 1)

  expect_equal(sum(rain) - sum(out$qtot) - sum(out$ea),
               (Sbar0 - tail(out$sbar, 1)) + (Sr0 - tail(out$srz, 1)))
})
