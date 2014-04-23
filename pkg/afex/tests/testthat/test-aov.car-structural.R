
context("ANOVAs: structural tests")

test_that("dv is numeric", {  
  expect_that(aov.car(treatment ~ gender + Error(id/phase*hour), data = obk.long, observed = "gender"), throws_error("numeric"))
})
