
context("ANOVAs: structural tests")

test_that("dv is numeric", {
  data(obk.long)
  expect_that(aov.car(treatment ~ gender + Error(id/phase*hour), data = obk.long, observed = "gender"), throws_error("dv needs to be numeric."))
})

test_that("non Type 3 sums give warning", {
  data(obk.long)
  expect_that(aov4(value ~ treatment * gender + (phase*hour|id), data = obk.long, observed = "gender", check.contrasts = FALSE), gives_warning("contrasts"))
})