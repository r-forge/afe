#' Convenience wrappers for car::Anova using either a formula or SPSS like interface.
#'
#' These functions allow convenient access to \code{\link{car::Anova}} for data in the \strong{long} format (i.e., one observation per row), possibly aggregating the data before running the analysis if there is more than one datapoint per individuum and cell. That is repated-measures ANOVAs can be calculated conveniently without using the rather unhandy format of \code{car::Anova}. \code{aov.car} can be called using a formula similar to \code{\link{aov}} specifying an error strata for the within-subject factor(s). \code{spss.glm} is called specifying the factors as character vectors.

#' @export
aov.car <- function(formula, data, fun.aggregate = NULL, type = 3, ...) {
	#browser()
	vars <- all.vars(formula)
	dv <- vars[1]
	vars <- vars[-1]
	parts <- attr(terms(formula, "Error", data = data), "term.labels")
	error.term <- parts[str_detect(parts, "^Error\\(")]
	id <- all.vars(parse(text = error.term))[1]
	within <- all.vars(parse(text = error.term))[-1]
	between <- vars[!(vars %in% c(id, within))]
	effect.parts <- parts[!str_detect(parts, "^Error\\(")]
	effect.parts.no.within <- effect.parts[!str_detect(effect.parts, str_c("\\<",within,"\\>", collapse = "|"))]
	rh2 <- str_c(effect.parts.no.within, collapse = "+")
	lh1 <- str_c(id, str_c(between, collapse = "+"), sep = "+")
	rh1 <- str_c(within, collapse = "+")
	rh3 <- str_c(within, collapse = "*")
	if (is.null(fun.aggregate)) {
		if (any(xtabs(as.formula(str_c("~", id, "+", rh1)), data = data) > 1)) {
			warning("More than one observation per cell, aggregating the data using mean (i.e, fun.aggregate = mean)!")
			fun.aggregate <- mean
		}
	}
	tmp.dat <- dcast(data, formula = as.formula(str_c(lh1, rh1, sep = "~")), fun.aggregate = fun.aggregate, ..., value.var = dv)
	if (length(within) > 1) {
		within.levels <- lapply(lapply(data[,within], levels), factor)
		idata <- rev(expand.grid(rev(within.levels)))
	} else {
		idata <- data.frame(levels(data[,within]))
		colnames(idata) <- within
	}
	
	tmp.lm <- lm(as.formula(str_c("cbind(",str_c(colnames(tmp.dat[-(seq_along(c(id, between)))]), collapse = ", "), ") ~ ", rh2)), data = tmp.dat)
	Anova(tmp.lm, idata = idata, idesign = as.formula(str_c("~", rh3)), type = type)
}

#' @export


spss.glm <- function(id, between, within, dv, covariate, data, fun.aggregate = NULL, type = 3, ..., print.formula = FALSE) {
	if (missing(covariate)) {
		covariate <- NULL
		covariates <- NULL
	} else covariates <- str_c(covariate, collapse = "+")
	rh <- str_c(str_c(between, collapse = " * "), covariates, sep = " + ")
	error <- str_c("+ Error(", id, "/", str_c(within, collapse = " * "), ")")
	formula <- str_c(dv, " ~ ", rh, error)
	if (print.formula) message(str_c("Formula send to aov.car: ", formula))
	aov.car(formula = as.formula(formula), data = data, fun.aggregate = fun.aggregate, type = type, ...)
}



