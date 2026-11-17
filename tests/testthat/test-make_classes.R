test_that("classes are valid", {
  m  <- matrix(c(5, 6, 7, 8, 9, 10, 11, 12, 13), nrow = 3)
  ti <- terra::rast(m)
  cl <- make_classes(ti, n = 4)

  expect_equal(sum(cl$area), 1)
  expect_equal(nrow(cl), 4)
})
