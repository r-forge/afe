
context("ANOVAs: replicating published results")

test_that("purely within ANOVA, return='univ': Maxell & Delaney (2004), Table 12.5 and 12.6, p. 578", {
  ### replicate results from Table 12.6
  data(md_12.1)
  # valus from table:
  f <- c(40.72, 33.77, 45.31)
  ss_num <- c(289920, 285660, 105120)
  ss_error <- c(64080, 76140, 20880)
  num_df <- c(2, 1, 2)
  den_df <- c(18, 9, 18)
  
  suppressWarnings(md_ez_r <- ez.glm("id", "rt", md_12.1, within = c("angle", "noise"), return = "univ"))
  suppressWarnings(md_car_r <- aov.car(rt ~ 1 + Error(id/angle*noise), md_12.1, return = "univ"))
  suppressWarnings(md_aov4_r <- aov4(rt ~ 1 + (angle*noise|id), md_12.1, return = "univ"))
  
  expect_that(md_ez_r, is_equivalent_to(md_car_r))
  expect_that(md_ez_r, is_equivalent_to(md_aov4_r))
  expect_that(round(md_ez_r$univariate.tests[,"F"][-1], 2), is_equivalent_to(f))
  expect_that(md_ez_r$univariate.tests[,"SS"][-1], is_equivalent_to(ss_num))  
  expect_that(md_ez_r$univariate.tests[,"Error SS"][-1], is_equivalent_to(ss_error))
  expect_that(md_ez_r$univariate.tests[,"num Df"][-1], is_equivalent_to(num_df))
  expect_that(md_ez_r$univariate.tests[,"den Df"][-1], is_equivalent_to(den_df))
})



test_that("Analysis of Singmann & Klauer (2011, Exp. 1)", {
  data(sk2011.1, package = "afex")

  out1 <-  ez.glm("id", "response", sk2011.1[ sk2011.1$what == "affirmation",], within = c("inference", "type"), between = "instruction", args.return=(es = "pes"), fun.aggregate = mean, return = "afex_aov")
  
  df_num <- rep(1, 7)
  df_den <- rep(38, 7)
  MSE <- c(1072.42, 1007.21, 1007.21, 187.9, 187.9, 498.48, 498.48)
  F <- c(0.13, 13.01, 12.44, 0.06, 3.09, 29.62, 10.73)
  pes <- c(0, 0.26, 0.25, 0, 0.08, 0.44, 0.22)
  p <- c(0.72, 0.0009, 0.001, 0.81, 0.09, 0.001, 0.002)
  
  expect_that(out1$anova_table[["num Df"]], is_equivalent_to(df_num))
  expect_that(out1$anova_table[["den Df"]], is_equivalent_to(df_den))
  expect_that(out1$anova_table[["MSE"]], equals(MSE, tolerance = 0.001))
  expect_that(out1$anova_table[["F"]], equals(F, tolerance = 0.001))
  expect_that(out1$anova_table[["pes"]], equals(pes, tolerance = 0.02))
  expect_that(out1$anova_table[["Pr(>F)"]], equals(p, tolerance = 0.01))
  
})


test_that("Data from O'Brien & Kaiser replicates their paper (p. 328, Table 8, column 'average'", {
  data(obk.long, package = "afex")
  out1 <- aov.car(value ~ treatment * gender + Error(id/(phase*hour)), data = obk.long, observed = "gender", return = "afex_aov", args.return = list(correction = "none"))
  nice.anova(anova(out1, correction = "none"))

  expect_that(unname(unlist(out1[["anova_table"]]["treatment", c("num Df", "den Df", "F")])), equals(c(2, 10, 3.94), tolerance = 0.001))
  expect_that(unname(unlist(out1[["anova_table"]]["gender", c("num Df", "den Df", "F")])), equals(c(1, 10, 3.66), tolerance = 0.001))
  expect_that(round(unname(unlist(out1[["anova_table"]]["treatment:gender", c("num Df", "den Df", "F")])), 2), equals(c(2, 10, 2.86), tolerance = 0.001))
})

