#' Obtain p-values for a mixed-model from lmer().
#'
#' Fits and calculates p-values for all effects in a mixed model fitted with \code{\link[lme4]{lmer}}. The default behavior (currently the only behavior implemented) calculates type 3 like p-values using the Kenward-Rogers approximation for degrees-of-freedom implemented in \code{\link[pbkrtest]{KRmodcomp}}. \code{print}, \code{summary}, and \code{anova} methods for the returned object of class \code{"mixed"} are available (all return the same data.frame).
#'
#' @usage mixed(fixed, random, dv, data, type = 3, method = c("KR", "PB"), ...)
#'
#' @param fixed character vector specifying the fixed part of the model.
#' @param random character vector specifying the random part of the model (in the current implementation this random part is fit with all models).
#' @param dv character vector specifying the dependent variable
#' @param data data.frame containing the data. Should have all the variables present in \code{fixed}, \code{random}, and \code{dv} as columns.
#' @param type type of sums of squares on which effects are based. Currently only type 3 (\code{3} or \code{"III"}) is implemented.
#' @param method character vector indicating which methods for obtaining p-values should be used. Currently only \code{"KR"} is implemented corresponding to the Kenward-Rogers approximation for degrees-of-freedom.
#' @param ... further arguments passed to \code{lmer}.
#'
#' @return An object of class \code{"mixed"} (i.e., a list) with the following elements:
#'
#' \enumerate{
#' \item \code{anova.table} a data.frame containing the statistics returned from \code{\link[pbkrtest]{KRmodcomp}}.
#' \item \code{full.model} the \code{"mer"} object returned from fitting the full mixed model.
#' \item \code{restricted.models} a list of \code{"mer"} objects from fitting the restricted models (i.e., each model lacks the corresponding effect)
#' \item \code{tests} a list of objects returned by the function for obtaining the p-values (objects are of class \code{"KRmodcomp"} when \code{method = "KR"}).
#' \item \code{type} The \code{type} argument used when calling this function.
#' \item \code{method} The \code{method} argument used when calling this function.
#' }
#'
#' The following methods exist for objects of class \code{"mixed"}: \code{print}, \code{summary}, and \code{anova} (all return the same data.frame).
#'
#' @details Type 3 sums of squares are obtained by fitting a model in which only the corresponding effect is missing.
#'
#' See Judd, Westfall, and Kenny (2012) for examples of how to specify the random effects structure for factorial experiments.
#'
#' @note This functions may take some time especially with complex random structures.
#'
#' @author Henrik Singmann with contributions from \href{http://stackoverflow.com/q/11335923/289572}{Ben Bolker and Joshua Wiley}.
#'
#' @references Judd, C. M., Westfall, J., & Kenny, D. A. (2012). Treating stimuli as a random factor in social psychology: A new and comprehensive solution to a pervasive but largely ignored problem. \emph{Journal of Personality and Social Psychology}, 103(1), 54–69. doi:10.1037/a0028347
#'
#' @export mixed
#' @S3method print mixed
#' @S3method summary mixed
#' @S3method anova mixed
#'
#' @examples
#' \dontrun{
#' # example data from package languageR:
#' # Lexical decision latencies elicited from 21 subjects for 79 English concrete nouns, with variables linked to subject or word. 
#' data(lexdec, package = "languageR")
#' 
#' # using the simplest model
#' m1 <- mixed("Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length",  "(1|Subject) + (1|Word)", "RT", data = lexdec)
#' 
#' anova(m1)
#' # gives:
#' ##                   Effect df1     df2      Fstat p.value
#' ## 1            (Intercept)   1   96.64 13573.0985   0.000
#' ## 2                Correct   1 1627.73     8.1452   0.004
#' ## 3                  Trial   1 1592.43     7.5738   0.006
#' ## 4               PrevType   1 1605.39     0.1700   0.680
#' ## 5             meanWeight   1   75.39    14.8545   0.000
#' ## 6              Frequency   1   76.08    56.5348   0.000
#' ## 7         NativeLanguage   1   27.12     0.6953   0.412
#' ## 8                 Length   1   75.83     8.6959   0.004
#' ## 9    PrevType:meanWeight   1 1601.18     6.1823   0.013
#' ## 10 NativeLanguage:Length   1 1555.49    14.2445   0.000
#' }

mixed <- function(fixed, random, dv, data, type = 3, method = c("KR", "PB"), ...) {
	if (any(missing(fixed), missing(random), missing(dv), missing(data))) stop("fixed, random, dv, and data must be specified")
	if ((type == 3 | type == "III") & options("contrasts")[[1]][1] != "contr.sum") warning(str_c("Calculating Type 3 sums with contrasts = ", options("contrasts")[[1]][1], ".\n  Use options(contrasts=c('contr.sum','contr.poly')) instead"))
	# browser()
	# prepare fitting
	m.matrix <- model.matrix(as.formula(str_c("~", fixed)), data = data)
	fixed.effects <- attr(terms(as.formula(str_c("~", fixed)), data = data), "term.labels")
	fixed.effects <- c("(Intercept)", fixed.effects)
	mapping <- attr(m.matrix, "assign")
	# obtain the lmer fits
	if (type == 3 | type == "III") {
		full.model <- lmer(as.formula(str_c(dv, "~", fixed, "+", random)), data = data, ...)
		fits <- vector("list", length(fixed.effects))
		for (c in c(seq_along(fixed.effects))) {
			tmp.columns <- str_c(deparse(which(mapping != (c-1))), collapse = "")
			fits[[c]] <- lmer(as.formula(str_c(dv, "~ 0 + m.matrix[,", tmp.columns, "] +", random)), data = data, ...)
		}
	} else stop('Only type 3 tests currently implemented.')
	names(fits) <- fixed.effects
	# obtain Kenward-Roger tests:
	if (method[1] == "KR") {
		tests <- lapply(fits, function(x) KRmodcomp(full.model, x))
		names(tests) <- fixed.effects
		df.out <- data.frame(Effect = fixed.effects, stringsAsFactors = FALSE)
		df.out <- cbind(df.out, t(vapply(tests, "[[", tests[[1]][[1]], i =1)))
		rownames(df.out) <- NULL
	} else stop('Only method "KR" currently implemented.')
	list.out <- list(anova.table = df.out, full.model = full.model, restricted.models = fits, tests = tests, type = type, method = method[[1]])
	class(list.out) <- "mixed"
	list.out
}

print.mixed <- function(x, ...) print(x[[1]][,1:5])

summary.mixed <- function(object, ...) object[[1]][,1:5]

anova.mixed <- function(object, ...) object[[1]][,1:5]

# is.mixed <- function(x) inherits(x, "mixed")
