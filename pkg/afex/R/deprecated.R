#' Deprecated functions
#'
#' These functions have been renamed and deprecated in \pkg{afex}:
#' \code{aov.car()} (use \code{\link{aov_car}()}), 
#' \code{ez.glm()} (use \code{\link{aov_ez}()}).
#' @rdname deprecated
#' @keywords internal
#' @aliases afex-deprecated
#' @param ... arguments passed from the old functions of the style
#'   \code{foo.bar()} to the new functions \code{foo_bar()}
#' @export
aov.car <- function(...) {
  .Deprecated("aov_car", "afex", "aov.car was renamed to aov_car and is now deprecated.")
  aov_car(...)
}
#' @rdname deprecated
#' @export
ez.glm <- function(...) {
  .Deprecated("aov_ez", "afex", "ez.glm was renamed to aov_ez and is now deprecated.")
  aov_ez(...)
}
#' @rdname deprecated
#' @export
aov4 <- function(...) {
  .Deprecated("aov_4", "afex", "aov4 was renamed to aov_4 and is now deprecated.")
  aov_4(...)
}
#' @rdname deprecated
#' @export
nice.anova <- function(...) {
  .Deprecated("nice_anova", "afex", "nice.anova was renamed to nice_anova and is now deprecated.")
  nice_anova(...)
}
