#' Convenience wrappers for car::Anova using either a formula or factor based interface.
#'
#' These functions allow convenient access to \code{\link[car]{Anova}} (from the \pkg{car} package) for data in the \strong{long} format (i.e., one observation per row), possibly aggregating the data if there is more than one obersvation per individuum and cell. Hence, mixed between-within ANOVAs can be calculated conveniently without using the rather unhandy format of \code{car::Anova}. \code{aov.car} can be called using a formula similar to \code{\link{aov}} specifying an error strata for the within-subject factor(s). \code{ez.glm} is called specifying the factors as character vectors.
#'
#' @usage aov.car(formula, data, fun.aggregate = NULL, type = 3, ...)
#'
#' ez.glm(id, between, within, dv, covariate, data, fun.aggregate = NULL, type = 3, ..., print.formula = FALSE)
#' 
#'
#' @param formula A formula specifying the ANOVA model similar to \code{\link{aov}}. Should include an error term (i.e., \code{Error( / )}). Note that the within-subject factors do not need to be outside the Error term (this contrasts with \code{aov}).
#' @param id \code{character} vector (of length 1) indicating the subject identifier column in \code{data}.
#' @param between \code{character} vector indicating the \strong{between}-subject(s) factor(s)/column(s) in \code{data}.
#' @param within \code{character} vector indicating the \strong{within}-subject(s) factor(s)/column(s) in \code{data}.
#' @param dv \code{character} vector (of length 1) indicating the column containing the \strong{dependent variable} in \code{data}.
#' @param covariate \code{character} vector indicating the between-subject(s) covariate(s) (i.e., column(s)) in \code{data}.
#' @param data A \code{data.frame} containing the data. Mandatory.
#' @param fun.aggregate The function for aggregating the data before running the ANOVA if there is more than one obervation per individuum and cell of the design. The default \code{NULL} issues a warning if aggregation is necessary and uses \code{\link{mean}}.
#' @param type The type of sums of squares for the ANOVA. \strong{Defaults to 3}. Passed to \code{\link[car]{Anova}}. Possible values are \code{"II"}, \code{"III"}, \code{2}, or \code{3}.
#' @param print.formula \code{ez.glm} is a wrapper for \code{aov.car}. This boolean argument indicates whether the formula in the call to \code{car.aov} should be printed. 
#' @param ... Further arguments passed to fun.aggregate.
#'
#' @return Same as \code{\link[car]{Anova}}. Usually an object of class \code{"Anova.mlm"}.
#' 
#' To obtain univariate results, the \code{summary} of the returned object with \code{multivariate = FALSE}, \cr e.g. \code{summary(aov.car(...), multivriate = FALSE)}.
#' 
#' @details Type 3 sums of squares are said to be dangerous and/or problematic. On the other side they are the default in in SPSS and SAS and recommended by e.g. Maxwell and Delaney (2003). For a brief discussion see \href{http://stats.stackexchange.com/q/6208/442}{here}. Type 3 sums of squares are the default in \pkg{afe}.
#'
#' However, note that Type 3 ANOVAs with interactions are only meaningful with \href{http://www.ats.ucla.edu/stat/mult_pkg/faq/general/effect.htm}{effects coding}. That is, contrasts should be set to \code{\link{contr.sum}} via \code{options(contrasts=c('contr.sum','contr.poly'))}. This should be done automatically when loading \pkg{afe} and \pkg{afe} will issue a warning when running type 3 SS and \href{http://www.ats.ucla.edu/stat/r/library/contrast_coding.htm}{other coding schemes}. You can check the coding with \code{options("contrasts")}. 
#' 
#' Currently these functions are not very well tested for models with \strong{only} between or \strong{only} within subject factors.
#'
#' \code{ez.glm} will concatante all between-subject factors using \code{*} (i.e., producing all main effects and interactions) and all covariates by \code{+} (i.e., adding only the main effects to the existing between-subject factors). The within-subject factors do fully interact with all between-subject factors and covariates. This is essentially identical to the behavior of SPSS's \code{glm} function.
#'
#' @note Factors are silently converted to factors and unused levels dropped.
#'
#' @name aov.car
#' @aliases aov.car ez.glm
#' @export aov.car ez.glm
#' @examples
#' 
#' # exampel using OBrienKaiser dataset from package car (see ?OBrienKaiser)
#' 
#' # first step, convert OBrienKaiser from wide to long format and add a (random) covariate age.
#' set.seed(1)
#' OBrienKaiser2 <- within(OBrienKaiser, {
#' 		id <- factor(1:nrow(OBrienKaiser))
#' 		age <- scale(sample(18:35, nrow(OBrienKaiser), replace = TRUE), scale = FALSE)})
#' attributes(OBrienKaiser2$age) <- NULL # needed or resahpe2::melt throws an error.
#' OBrienKaiser2$age <- as.numeric(OBrienKaiser2$age)
#' obk.long <- melt(OBrienKaiser2, id.vars = c("id", "treatment", "gender", "age"))
#' obk.long[,c("phase", "hour")] <- lapply(as.data.frame(do.call(rbind,strsplit(as.character(obk.long$variable), "\\."),)), factor)
#' str(obk.long)
#' ## 'data.frame':   240 obs. of  8 variables:
#' ##  $ id       : Factor w/ 16 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
#' ##  $ treatment: Factor w/ 3 levels "control","A",..: 1 1 1 1 1 2 2 2 2 3 ...
#' ##  $ gender   : Factor w/ 2 levels "F","M": 2 2 2 1 1 2 2 1 1 2 ...
#' ##  $ age      : num  -4.75 -2.75 1.25 7.25 -5.75 7.25 8.25 2.25 2.25 -7.75 ...
#' ##  $ variable : Factor w/ 15 levels "pre.1","pre.2",..: 1 1 1 1 1 1 1 1 1 1 ...
#' ##  $ value    : num  1 4 5 5 3 7 5 2 3 4 ...
#' ##  $ phase    : Factor w/ 3 levels "fup","post","pre": 3 3 3 3 3 3 3 3 3 3 ...
#' ##  $ hour     : Factor w/ 5 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
#' 
#' # run univariate mixed ANCOVA for the full design:
#' summary(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long), multivariate = FALSE)
#' summary(ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", data = obk.long), multivariate = FALSE)
#' # both calls return the same:
#' 
#' ## Univariate Type III Repeated-Measures ANOVA Assuming Sphericity
#' ## 
#' ##                               SS num Df Error SS den Df      F      Pr(>F)    
#' ## (Intercept)                 6454      1    215.7      9 269.35 0.000000052 ***
#' ## treatment                    171      2    215.7      9   3.58      0.0719 .  
#' ## gender                        95      1    215.7      9   3.95      0.0782 .  
#' ## age                           12      1    215.7      9   0.52      0.4902    
#' ## treatment:gender              62      2    215.7      9   1.28      0.3232    
#' ## phase                        135      2     59.7     18  20.28 0.000024485 ***
#' ## treatment:phase               81      4     59.7     18   6.07      0.0028 ** 
#' ## gender:phase                   2      2     59.7     18   0.25      0.7843    
#' ## age:phase                     21      2     59.7     18   3.10      0.0698 .  
#' ## treatment:gender:phase        21      4     59.7     18   1.60      0.2171    
#' ## hour                         109      4     47.6     36  20.52 0.000000007 ***
#' ## treatment:hour                 8      8     47.6     36   0.71      0.6779    
#' ## gender:hour                    4      4     47.6     36   0.71      0.5915    
#' ## age:hour                      15      4     47.6     36   2.82      0.0393 *  
#' ## treatment:gender:hour          6      8     47.6     36   0.59      0.7798    
#' ## phase:hour                    10      8     88.6     72   0.99      0.4501    
#' ## treatment:phase:hour           7     16     88.6     72   0.33      0.9915    
#' ## gender:phase:hour              9      8     88.6     72   0.90      0.5222    
#' ## age:phase:hour                 8      8     88.6     72   0.77      0.6339    
#' ## treatment:gender:phase:hour   13     16     88.6     72   0.65      0.8308    
#' ## ---
#' ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#' ## 
#' ## 
#' ## Mauchly Tests for Sphericity
#' ## 
#' ##                             Test statistic p-value
#' ## phase                                0.822   0.456
#' ## treatment:phase                      0.822   0.456
#' ## gender:phase                         0.822   0.456
#' ## age:phase                            0.822   0.456
#' ## treatment:gender:phase               0.822   0.456
#' ## hour                                 0.097   0.049
#' ## treatment:hour                       0.097   0.049
#' ## gender:hour                          0.097   0.049
#' ## age:hour                             0.097   0.049
#' ## treatment:gender:hour                0.097   0.049
#' ## phase:hour                           0.000   0.087
#' ## treatment:phase:hour                 0.000   0.087
#' ## gender:phase:hour                    0.000   0.087
#' ## age:phase:hour                       0.000   0.087
#' ## treatment:gender:phase:hour          0.000   0.087
#' ## 
#' ## 
#' ## Greenhouse-Geisser and Huynh-Feldt Corrections
#' ##  for Departure from Sphericity
#' ## 
#' ##                             GG eps Pr(>F[GG])    
#' ## phase                        0.849   0.000084 ***
#' ## treatment:phase              0.849     0.0052 ** 
#' ## gender:phase                 0.849     0.7494    
#' ## age:phase                    0.849     0.0807 .  
#' ## treatment:gender:phase       0.849     0.2280    
#' ## hour                         0.534   0.000013 ***
#' ## treatment:hour               0.534     0.6011    
#' ## gender:hour                  0.534     0.5137    
#' ## age:hour                     0.534     0.0816 .  
#' ## treatment:gender:hour        0.534     0.6844    
#' ## phase:hour                   0.436     0.4187    
#' ## treatment:phase:hour         0.436     0.9318    
#' ## gender:phase:hour            0.436     0.4652    
#' ## age:phase:hour               0.436     0.5395    
#' ## treatment:gender:phase:hour  0.436     0.7101    
#' ## ---
#' ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#' ## 
#' ##                             HF eps Pr(>F[HF])    
#' ## phase                        1.025  0.0000245 ***
#' ## treatment:phase              1.025     0.0028 ** 
#' ## gender:phase                 1.025     0.7843    
#' ## age:phase                    1.025     0.0698 .  
#' ## treatment:gender:phase       1.025     0.2171    
#' ## hour                         0.705  0.0000008 ***
#' ## treatment:hour               0.705     0.6343    
#' ## gender:hour                  0.705     0.5478    
#' ## age:hour                     0.705     0.0621 .  
#' ## treatment:gender:hour        0.705     0.7264    
#' ## phase:hour                   0.744     0.4402    
#' ## treatment:phase:hour         0.744     0.9788    
#' ## gender:phase:hour            0.744     0.5021    
#' ## age:phase:hour               0.744     0.5993    
#' ## treatment:gender:phase:hour  0.744     0.7878    
#' ## ---
#' ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#' ## Warnmeldung:
#' ## In summary.Anova.mlm(aov.car(value ~ treatment * gender + age +  :
#' ##   HF eps > 1 treated as 1
#' ## 
#' 
#' # replicating ?Anova using aov.car:
#' aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, type = 2)
#' # in contrast to aov you do not need the within-subject factors outside Error()
#' 
#' # replicating ?Anova using ez.glm:
#' ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", data = obk.long, type = 2)
#' 
#' #both return:
#' ## Type II Repeated Measures MANOVA Tests: Pillai test statistic
#' ##                             Df test stat approx F num Df den Df       Pr(>F)    
#' ## (Intercept)                  1     0.970      318      1     10 0.0000000065 ***
#' ## treatment                    2     0.481        5      2     10      0.03769 *  
#' ## gender                       1     0.204        3      1     10      0.14097    
#' ## treatment:gender             2     0.364        3      2     10      0.10447    
#' ## phase                        1     0.851       26      2      9      0.00019 ***
#' ## treatment:phase              2     0.685        3      4     20      0.06674 .  
#' ## gender:phase                 1     0.043        0      2      9      0.82000    
#' ## treatment:gender:phase       2     0.311        1      4     20      0.47215    
#' ## hour                         1     0.935       25      4      7      0.00030 ***
#' ## treatment:hour               2     0.301        0      8     16      0.92952    
#' ## gender:hour                  1     0.293        1      4      7      0.60237    
#' ## treatment:gender:hour        2     0.570        1      8     16      0.61319    
#' ## phase:hour                   1     0.550        0      8      3      0.83245    
#' ## treatment:phase:hour         2     0.664        0     16      8      0.99144    
#' ## gender:phase:hour            1     0.695        1      8      3      0.62021    
#' ## treatment:gender:phase:hour  2     0.793        0     16      8      0.97237    
#' ## ---
#' ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#' 
#' 
#' # adding age as a covariate:
#' 
#' aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long, type = 2)
#' 
#' ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", "age", data = obk.long, type = 2, print.formula = TRUE)
#' # Formula send to aov.car: value ~ treatment * gender + age+ Error(id/phase * hour)
#' 
#' # both return:
#' ## Type II Repeated Measures MANOVA Tests: Pillai test statistic
#' ##                             Df test stat approx F num Df den Df      Pr(>F)    
#' ## (Intercept)                  1     0.971    303.0      1      9 0.000000031 ***
#' ## treatment                    2     0.490      4.3      2      9      0.0483 *  
#' ## gender                       1     0.323      4.3      1      9      0.0681 .  
#' ## age                          1     0.054      0.5      1      9      0.4902    
#' ## treatment:gender             2     0.222      1.3      2      9      0.3232    
#' ## phase                        1     0.851     22.8      2      8      0.0005 ***
#' ## treatment:phase              2     0.763      2.8      4     18      0.0586 .  
#' ## gender:phase                 1     0.064      0.3      2      8      0.7665    
#' ## age:phase                    1     0.393      2.6      2      8      0.1358    
#' ## treatment:gender:phase       2     0.545      1.7      4     18      0.1967    
#' ## hour                         1     0.935     21.7      4      6      0.0010 ** 
#' ## treatment:hour               2     0.534      0.6      8     14      0.7345    
#' ## gender:hour                  1     0.316      0.7      4      6      0.6237    
#' ## age:hour                     1     0.508      1.5      4      6      0.3008    
#' ## treatment:gender:hour        2     0.707      1.0      8     14      0.5043    
#' ## phase:hour                   1     0.721      0.6      8      2      0.7299    
#' ## treatment:phase:hour         2     1.076      0.4     16      6      0.9133    
#' ## gender:phase:hour            1     0.695      0.6      8      2      0.7665    
#' ## age:phase:hour               1     0.974      9.4      8      2      0.0997 .  
#' ## treatment:gender:phase:hour  2     1.314      0.7     16      6      0.7225    
#' ## ---
#' ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#' 
#' 
#' # aggregating over one within-subjects factor (phase) with warning:
#' 
#' aov.car(value ~ treatment * gender + age + Error(id/hour), data = obk.long)
#' 
#' ez.glm(id = "id", c("treatment", "gender"), c("hour"), "value", "age", data = obk.long, print.formula = TRUE)
#' 
#' 
#' # runs with "numeric" factors
#' obk.long$hour2 <- as.numeric(as.character(obk.long$hour))
#' 
#' aov.car(value ~ treatment * gender + Error(id/hour2), data = obk.long, type = 2)
#'


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
	# converting all within subject factors to factors and adding a leading charcter (x) if starting with a digit.
	for (within.factor in within) {
		data[,within.factor] <- factor(data[,within.factor])
		levels(data[,within.factor])[grep("^[[:digit:]]", levels(data[,within.factor]))] <- str_c("x", levels(data[,within.factor])[grep("^[[:digit:]]", levels(data[,within.factor]))])
	}
	# Is fun.aggregate NULL and aggregation necessary?
	if (is.null(fun.aggregate)) {
		if (any(xtabs(as.formula(str_c("~", id, "+", rh1)), data = data) > 1)) {
			warning("More than one observation per cell, aggregating the data using mean (i.e, fun.aggregate = mean)!")
			fun.aggregate <- mean
		}
	}
	# Is Type = 3 and contrasts not contr.sum?
	if ((type == 3 | type == "III") & options("contrasts")[[1]][1] != "contr.sum") warning(str_c("Calculating Type 3 sums with contrasts = ", options("contrasts")[[1]][1], ".\n  Use options(contrasts=c('contr.sum','contr.poly')) instead"))
	# prepare the data:
	tmp.dat <- dcast(data, formula = as.formula(str_c(lh1, rh1, sep = "~")), fun.aggregate = fun.aggregate, ..., value.var = dv)
	# make idata argument
	if (length(within) > 1) {
		within.levels <- lapply(lapply(data[,within], levels), factor)
		idata <- rev(expand.grid(rev(within.levels)))
	} else {
		idata <- data.frame(levels(data[,within]))
		colnames(idata) <- within
	}
	# print(as.formula(str_c("cbind(",str_c(colnames(tmp.dat[-(seq_along(c(id, between)))]), collapse = ", "), ") ~ ", rh2)))
	tmp.lm <- lm(as.formula(str_c("cbind(",str_c(colnames(tmp.dat[-(seq_along(c(id, between)))]), collapse = ", "), ") ~ ", rh2)), data = tmp.dat)
	Anova(tmp.lm, idata = idata, idesign = as.formula(str_c("~", rh3)), type = type)
}



ez.glm <- function(id, between, within, dv, covariate, data, fun.aggregate = NULL, type = 3, ..., print.formula = FALSE) {
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



