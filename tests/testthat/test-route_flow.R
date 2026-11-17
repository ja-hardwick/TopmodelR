test_that("routing matches hand calculation", {
  h <- c(0.2, 0.5, 0.3)
  expect_equal(route_flow(gen = c(10, 10, 0, 0), h = h), c(2, 7, 8, 3))
  expect_equal(route_flow(gen = c(10, 0, 10, 0, 0), h = h), c(2, 5, 5, 5, 3))
})
