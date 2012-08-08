#' Analysis of Factorial Experiments.
#'
#' \tabular{ll}{
#' Package: \tab afex\cr
#' Type: \tab Package\cr
#' Version: \tab 0.2-19\cr
#' Date: \tab 2012-08-08\cr
#' Depends: \tab R (>= 2.14.0), car, reshape2, stringr\cr
#' Encoding: \tab UTF-8\cr
#' License: \tab GPL (>=3)\cr
#' URL: \tab http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex\cr
#' }
#'
#' Provides convenience functions for analyzing factorial experiments with ANOVA or ANCOVA replicating the behavior of commercial statisical packages (i.e., Type 3 sums of squares are the default). Specifically, afex provides the two functions aov.car and ez.glm for pure-between, pure-within (i.e., repeated-measures), and mixed between-within (i.e., split-plot) ANOVAs and ANCOVAs with type 2 and type 3 sums of squares for data in the long format (i.e., one obersvation per row) wrapping car::Anova(). If there is more than one obersvation per cell and subject, afex aggregates the data. Finally, function nice.anova produces publication ready ANOVA tables.
#'
#' @aliases afex-package afex
#' @name afex-package
#' @docType package
#' @title Analysis of Factorial Experiments.
#' @author Henrik Singmann \email{henrik.singmann@@psychologie.uni-freiburg.de}
#' @keywords package
NULL
