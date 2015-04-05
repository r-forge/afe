#' Set global afex options
#' 
#' Global afex options are used, for example, by \code{\link{aov.car}} (et al.) and \code{\link{mixed}}.
#' 
#' @param ... One of three: (1) nothing, then returns all options; (2) a name of an option element, then returns its' value; (3) a name-value pair which sets the corresponding option to the new value.
#' 
#' @details The following arguments are currently set:
#' \enumerate{
#' \item \code{return.aov} the return value of the ANOVA functions (see \code{\link{aov.car}}), default is \code{"nice"}.
# \item \code{es.aov} effect size reported for ANOVAs (see \code{\link{aov.car}}), default is \code{"ges"} (generalized eta-squared).
#' \item \code{method.mixed} the method used to obtain p-values in \code{\link{mixed}}, default is \code{"KR"} (which will change to \code{"LRT"} soon).
#' \item \code{check.contrasts} should contrasts be checked and changed to sum-to-zero contrasts? Default is \code{TRUE}.
#' \item \code{type} type of sums-of-squares to be used for testing effects, default is 3 which reports Type 3 tests.
#' }
#' 
#' @return depends on input, see above.
#'
#' @examples
#' afex.options()
#' 
#' afex.options("return.aov")
#' 
#' afex.options("return.aov", "check.contrasts")  # returns only first value!
#' 
#' \dontrun{
#' afex.options(return.aov = "nice")
#' }
#' 
#' @export 
#' 

afex.options <- function(...)
{
  dots <- list(...)
  if (length(dots) == 0) return(ls.str(envir = .afexEnv))
  else {
    if (!is.null(names(dots))) {
      if (length(dots) > 1) stop("afex.options can only return a single element.")
      for (i in seq_along(dots)) {
        assign(names(dots)[i], dots[[i]], envir = .afexEnv)
      }
    } else return(get(dots[[1]], envir = .afexEnv))
  }
}
