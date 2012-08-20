\name{compare.2.vectors}
\alias{compare.2.vectors}
\title{Compare two vectors using various tests.}
\usage{
  compare.2.vectors(x, y, paired = FALSE, na.rm = FALSE,
    permutation = TRUE, perm.distribution = if (!paired)
    "exact" else approximate(100000), wilcox.exact = NULL,
    wilcox.correct = TRUE)
}
\arguments{
  \item{x}{a (non-empty) numeric vector of data values.}

  \item{y}{a (non-empty) numeric vector of data values.}

  \item{paired}{a logical whether the data is paired.
  Default is \code{FALSE}.}

  \item{na.rm}{logical. Should \code{NA} be removed?
  Default is \code{FALSE}.}

  \item{permutation}{logical. Should a permutation test be
  calculated using \code{\link[coin]{oneway_test}}? Default
  is \code{TRUE}.}

  \item{perm.distribution}{\code{distribution} argument to
  \code{\link[coin]{oneway_test}}, see there. Defaults to
  the exact distribution for non-paired data and an
  approximated distribution with 100.000 samples for paired
  data.}

  \item{wilcox.exact}{\code{exact} argument to
  \code{\link{wilcox.test}}.}

  \item{wilcox.correct}{\code{correct} argument to
  \code{\link{wilcox.test}}.}
}
\value{
  a \code{data.frame} containing the following columns:
  \code{test}, \code{test.statistic}, \code{test.value},
  \code{test.df}, \code{p}.
}
\description{
  Compares two vectors \code{x} and \code{y} using t-test,
  Welch-test (also known as Statterwaithe), Wilcoxon-test,
  and a permutation test implemented in \pkg{coin}.
}
\examples{
with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2]))

# gives:
##          test test.statistic test.value  test.df          p
## 1           t              t  -1.860813 18.00000 0.07918671
## 2       welch              t  -1.860813 17.77647 0.07939414
## 3    wilcoxon              W  25.500000       NA 0.06932758
## A permutation              Z  -1.750807       NA 0.08144796
}

