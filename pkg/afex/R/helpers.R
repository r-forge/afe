#' Set/get global afex options
#' 
#' Global afex options are used, for example, by \code{\link{aov.car}} (et al.) and \code{\link{mixed}}. But can be changed in each functions directly using an argument (which has precedence over the global options).
#' 
#' @param ... One of three: (1) nothing, then returns all options; (2) a name of an option element, then returns its' value; (3) a name-value pair which sets the corresponding option to the new value.
#' 
#' @details The following arguments are currently set:
#' \enumerate{
#' \item \code{return_aov} the return value of the ANOVA functions (see \code{\link{aov.car}}), default is \code{"nice"}. 
#' \item \code{es_aov} effect size reported for ANOVAs (see \code{\link{aov.car}}), default is \code{"ges"} (generalized eta-squared).
#' \item \code{correction_aov} correction used for within-subjects factors with more than two levels for ANOVAs  (see \code{\link{aov.car}} or \code{\link{nice.anova}}), default is \code{"GG"} (Greenhouse-Geisser correction).
#' \item \code{method_mixed} the method used to obtain p-values in \code{\link{mixed}}, default is \code{"KR"} (which will change to \code{"LRT"} soon).
#' \item \code{check.contrasts} should contrasts be checked and changed to sum-to-zero contrasts? Default is \code{TRUE}.
#' \item \code{type} type of sums-of-squares to be used for testing effects, default is 3 which reports Type 3 tests.
#' }
#' 
#' @return depends on input, see above.
#'
#' @examples
#' afex_options()
#' 
#' afex_options("return_aov")
#' 
#' afex_options("return_aov", "check.contrasts")  # returns only first value!
#' 
#' \dontrun{
#' afex_options(return_aov = "nice")
#' }
#' 
#' @export 
#' 

afex_options <- function(...)
{
  dots <- list(...)
  if (length(dots) == 0) return(ls.str(envir = .afexEnv))
  else {
    if (!is.null(names(dots))) {
      if (length(dots) > 1) stop("afex_options can only return a single element.")
      for (i in seq_along(dots)) {
        assign(names(dots)[i], dots[[i]], envir = .afexEnv)
      }
    } else return(get(dots[[1]], envir = .afexEnv))
  }
}
