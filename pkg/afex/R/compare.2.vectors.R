#' Compare two vectors using various tests.
#'
#' Compares two vectors \code{x} and \code{y} using t-test, Welch-test (also known as Statterwaithe), Wilcoxon-test, and a permutation test implemented in \pkg{coin}.
#'
#' @usage compare.2.vectors(x, y, paired = FALSE, na.rm = FALSE, permutation = TRUE, perm.distribution = if (!paired) "exact" else approximate(100000), wilcox.exact = NULL, wilcox.correct = TRUE)
#'
#' @param x a (non-empty) numeric vector of data values.
#' @param y a (non-empty) numeric vector of data values.
#' @param paired a logical whether the data is paired. Default is \code{FALSE}.
#' @param na.rm logical. Should \code{NA} be removed?  Default is \code{FALSE}.
#' @param permutation logical. Should a permutation test be calculated using \code{\link[coin]{oneway_test}}? Default is \code{TRUE}.
#' @param perm.distribution \code{distribution} argument to \code{\link[coin]{oneway_test}}, see there. Defaults to the exact distribution for non-paired data and an approximated distribution with 100.000 samples for paired data.
#' @param wilcox.exact \code{exact} argument to \code{\link{wilcox.test}}.
#' @param wilcox.correct \code{correct} argument to \code{\link{wilcox.test}}.
#'
#' @return a \code{data.frame} containing the following columns: \code{test}, \code{test.statistic}, \code{test.value}, \code{test.df}, \code{p}.
#'
#' @export compare.2.vectors
#' @examples
#' with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2]))
#'
#' # gives:
#' ##          test test.statistic test.value  test.df          p
#' ## 1           t              t  -1.860813 18.00000 0.07918671
#' ## 2       welch              t  -1.860813 17.77647 0.07939414
#' ## 3    wilcoxon              W  25.500000       NA 0.06932758
#' ## A permutation              Z  -1.750807       NA 0.08144796
#'

compare.2.vectors <- function(x, y, paired = FALSE, na.rm = FALSE, permutation = TRUE, perm.distribution = if (!paired) "exact" else approximate(100000), wilcox.exact = NULL, wilcox.correct = TRUE) {
	#browser()
	if (na.rm) {
		x <- x[!is.na(x)]
		y <- y[!is.na(y)]
	} else if (any(is.na(x), is.na(y))) stop("NAs in data, use na.rm = TRUE.")
	if (paired) if (!length(x) == length(y)) stop("length(x) needs to be equal to length(y) when paired is TRUE!")
	res.t <- t.test(x, y, paired = paired, var.equal = TRUE)
	res.welch <- t.test(x, y, paired = paired, var.equal = FALSE)
	res.wilcox <- wilcox.test(x, y, paired = paired, exact = wilcox.exact, correct = wilcox.correct)
	res.out <- data.frame(test = c("t", "welch", "wilcoxon"), test.statistic = c("t", "t", "W"), test.value = c(res.t[["statistic"]], res.welch[["statistic"]], res.wilcox[["statistic"]]), test.df = c(res.t[["parameter"]], res.welch[["parameter"]], NA), p = c(res.t[["p.value"]], res.welch[["p.value"]], res.wilcox[["p.value"]]), stringsAsFactors = FALSE)
	if (permutation) {
		dv <- c(x, y)
		iv <- factor(rep(c("A", "B"), c(length(x), length(y))))
		if (paired) {
			id <- factor(rep(1:length(x), 2))
			res.perm <- oneway_test(dv ~ iv | id, distribution=perm.distribution)
		} else res.perm <- oneway_test(dv ~ iv, distribution=perm.distribution)
		res.out <- rbind(res.out, data.frame(test = "permutation", test.statistic = "Z", test.value = statistic(res.perm), test.df = NA, p = pvalue(res.perm), stringsAsFactors = FALSE))
	}
	res.out
}
