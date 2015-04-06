
context("ANOVAs: check that afex_aov return value works")

test_that("split-plot produces an afex_aov object without error", {
  data(obk.long, package = "afex")
  split_plot1 <- aov.car(value ~ treatment * gender + Error(id/(phase*hour)), data = obk.long, observed = "gender", return = "afex_aov")
  split_plot2 <- aov4(value ~ treatment * gender + (phase*hour|id), data = obk.long, observed = "gender", return = "afex_aov")
  split_plot3 <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender", return = "afex_aov")
  
  expect_that(split_plot1, is_equivalent_to(split_plot2))
  expect_that(split_plot1, is_equivalent_to(split_plot3))
  expect_that(split_plot1, is_a("afex_aov"))
  
  ## is same with numeric factor:
  obk.long$hour <- as.numeric(as.character(obk.long$hour))
  split_plot4 <- aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long,observed = c("gender"), return = "afex_aov")
  expect_that(split_plot1, is_equivalent_to(split_plot4))  
})

test_that("purely-between produces afex_aov objects without error", {
  data(obk.long, package = "afex")
  out1 <- aov.car(value ~ treatment * gender + Error(id), data = obk.long, observed = "gender", return = "afex_aov", fun.aggregate = mean)
  out2 <- aov4(value ~ treatment * gender + (1|id), data = obk.long, observed = "gender", return = "afex_aov", fun.aggregate = mean)
  out3 <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), observed = "gender", return = "afex_aov", fun.aggregate = mean)
  
  expect_that(out1, is_equivalent_to(out2))
  expect_that(out1, is_equivalent_to(out3))
  expect_that(out1, is_a("afex_aov"))
})

test_that("purely-within produces afex_aov objects without error", {
  data(obk.long, package = "afex")
  out1 <- aov.car(value ~ Error(id/(phase*hour)), data = obk.long, return = "afex_aov")
  out2 <- aov4(value ~ 1 +  (phase*hour|id), data = obk.long, return = "afex_aov")
  out3 <- ez.glm("id", "value", obk.long, within = c("phase", "hour"), return = "afex_aov")
  
  expect_that(out1, is_equivalent_to(out2))
  expect_that(out1, is_equivalent_to(out3))
  expect_that(out1, is_a("afex_aov"))
})

