#' Convenience wrappers for car::Anova using either a formula or factor based interface.
#'
#' These functions allow convenient access to \code{\link[car]{Anova}} (from the \pkg{car} package) for data in the \strong{long} format (i.e., one observation per row), possibly aggregating the data if there is more than one obersvation per individuum and cell. Hence, mixed between-within ANOVAs can be calculated conveniently without using the rather unhandy format of \code{car::Anova}. \code{aov.car} can be called using a formula similar to \code{\link{aov}} specifying an error strata for the within-subject factor(s). \code{ez.glm} is called specifying the factors as character vectors.
#'
#' @usage aov.car(formula, data, fun.aggregate = NULL, type = 3, ...)
#'
#' ez.glm(id, between, within, dv, covariate, data, fun.aggregate = NULL, type = 3, ..., print.formula = FALSE)
#' 
#' univariate(object)
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
#' @param ... Further arguments passed to \code{fun.aggregate}.
#' @param object An object of class \code{Anova.mlm} as returned by \code{aov.car}, \code{ez.glm}, or \code{\link[car]{Anova}}
#'
#' @return \code{aov.car} and \code{ez.glm}are wrappers and therfore return the same as \code{\link[car]{Anova}}. Usually an object of class \code{"Anova.mlm"}.
#' 
#' \code{univariate} returns a \code{list} of \code{data.frame}s containing the univariate results (i.e., the classical ANOVA results) from an object of class \code{"Anova.mlm"}. This is essentially the output from \code{summary.Anova.mlm} with \code{multivariate = FALSE}, e.g. \code{summary(aov.car(...), multivriate = FALSE)}, as a list instead of printed.
#'
#' The elements of the list returned by \code{univariate} are: \code{anova}, \code{mauchly}, and \code{spehricity.correction} (containing both, Greenhouse-Geisser and Hyundt-Feldt correction).
#' 
#' @details \strong{Type 3 sums of squares are default in \pkg{afe}.} Note that type 3 sums of squares are said to be dangerous and/or problematic. On the other side they are the default in in SPSS and SAS and recommended by e.g. Maxwell and Delaney (2003). For a brief discussion see \href{http://stats.stackexchange.com/q/6208/442}{here}. 
#'
#' However, note that lower order effects (e.g., main effects) in type 3 ANOVAs are only meaningful with \href{http://www.ats.ucla.edu/stat/mult_pkg/faq/general/effect.htm}{effects coding}. That is, contrasts should be set to \code{\link{contr.sum}} via \code{options(contrasts=c('contr.sum','contr.poly'))}. This should be done automatically when loading \pkg{afe} and \pkg{afe} will issue a warning when running type 3 SS and \href{http://www.ats.ucla.edu/stat/r/library/contrast_coding.htm}{other coding schemes}. You can check the coding with \code{options("contrasts")}. 
#' 
#' Currently these functions are not very well tested for models with \strong{only} between or \strong{only} within subject factors.
#'
#' \code{ez.glm} will concatante all between-subject factors using \code{*} (i.e., producing all main effects and interactions) and all covariates by \code{+} (i.e., adding only the main effects to the existing between-subject factors). The within-subject factors do fully interact with all between-subject factors and covariates. This is essentially identical to the behavior of SPSS's \code{glm} function.
#'
#' @author \code{univariate} is basically a copy of \code{\link[car]{summary.Anova.mlm}} written by John Fox.\cr The other functions were written by Henrik Singmann.
#'
#' @note Variables entered as within-subjects (i.e., repeated measures) factors are silently converted to factors and unused levels dropped.
#'
#' Contrasts attached to a factor as an attribute are probably not preserved and not supported.
#'
#' @name aov.car
#' @aliases aov.car ez.glm univariate
#' @export aov.car ez.glm univariate
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
#' # obtain mixed ANCOVA for the full design:
#' univariate(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long))
#' univariate(ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", "age", data = obk.long))
#' # both calls return the same:
#'
#' ## $anova
#' ##                                      SS num Df  Error SS den Df           F       Pr(>F)
#' ## (Intercept)                 6454.236987      1 215.65658      9 269.3547893 5.152317e-08
#' ## treatment                    171.399953      2 215.65658      9   3.5765187 7.193619e-02
#' ## gender                        94.598340      1 215.65658      9   3.9478742 7.818280e-02
#' ## age                           12.398975      1 215.65658      9   0.5174466 4.901885e-01
#' ## treatment:gender              61.531858      2 215.65658      9   1.2839551 3.231798e-01
#' ## phase                        134.586005      2  59.72439     18  20.2810632 2.448505e-05
#' ## treatment:phase               80.604542      4  59.72439     18   6.0732385 2.826803e-03
#' ## gender:phase                   1.634246      2  59.72439     18   0.2462681 7.843036e-01
#' ## age:phase                     20.553392      2  59.72439     18   3.0972362 6.982439e-02
#' ## treatment:gender:phase        21.254421      4  59.72439     18   1.6014379 2.170946e-01
#' ## hour                         108.513510      4  47.59543     36  20.5192290 7.001584e-09
#' ## treatment:hour                 7.547869      8  47.59543     36   0.7136275 6.779072e-01
#' ## gender:hour                    3.746135      4  47.59543     36   0.7083708 5.915285e-01
#' ## age:hour                      14.904567      4  47.59543     36   2.8183608 3.926421e-02
#' ## treatment:gender:hour          6.235198      8  47.59543     36   0.5895186 7.798264e-01
#' ## phase:hour                     9.762579      8  88.62706     72   0.9913814 4.501348e-01
#' ## treatment:phase:hour           6.579092     16  88.62706     72   0.3340505 9.915014e-01
#' ## gender:phase:hour              8.851396      8  88.62706     72   0.8988515 5.222336e-01
#' ## age:phase:hour                 7.539611      8  88.62706     72   0.7656409 6.339004e-01
#' ## treatment:gender:phase:hour   12.822199     16  88.62706     72   0.6510416 8.307936e-01
#' ## 
#' ## $mauchly
#' ##                             Test statistic    p-value
#' ## phase                         0.8217571566 0.45600959
#' ## treatment:phase               0.8217571566 0.45600959
#' ## gender:phase                  0.8217571566 0.45600959
#' ## age:phase                     0.8217571566 0.45600959
#' ## treatment:gender:phase        0.8217571566 0.45600959
#' ## hour                          0.0966749877 0.04923980
#' ## treatment:hour                0.0966749877 0.04923980
#' ## gender:hour                   0.0966749877 0.04923980
#' ## age:hour                      0.0966749877 0.04923980
#' ## treatment:gender:hour         0.0966749877 0.04923980
#' ## phase:hour                    0.0002379741 0.08651564
#' ## treatment:phase:hour          0.0002379741 0.08651564
#' ## gender:phase:hour             0.0002379741 0.08651564
#' ## age:phase:hour                0.0002379741 0.08651564
#' ## treatment:gender:phase:hour   0.0002379741 0.08651564
#' ## 
#' ## $sphericity.correction
#' ##                                GG eps   Pr(>F[GG])    HF eps   Pr(>F[HF])
#' ## phase                       0.8487215 8.383485e-05 1.0252867 2.448505e-05
#' ## treatment:phase             0.8487215 5.159591e-03 1.0252867 2.826803e-03
#' ## gender:phase                0.8487215 7.493990e-01 1.0252867 7.843036e-01
#' ## age:phase                   0.8487215 8.073373e-02 1.0252867 6.982439e-02
#' ## treatment:gender:phase      0.8487215 2.279698e-01 1.0252867 2.170946e-01
#' ## hour                        0.5341747 1.302016e-05 0.7054545 8.046331e-07
#' ## treatment:hour              0.5341747 6.010781e-01 0.7054545 6.342676e-01
#' ## gender:hour                 0.5341747 5.137213e-01 0.7054545 5.478398e-01
#' ## age:hour                    0.5341747 8.155027e-02 0.7054545 6.211130e-02
#' ## treatment:gender:hour       0.5341747 6.843526e-01 0.7054545 7.263729e-01
#' ## phase:hour                  0.4355822 4.186799e-01 0.7444364 4.402119e-01
#' ## treatment:phase:hour        0.4355822 9.317848e-01 0.7444364 9.787985e-01
#' ## gender:phase:hour           0.4355822 4.651930e-01 0.7444364 5.020890e-01
#' ## age:phase:hour              0.4355822 5.395151e-01 0.7444364 5.992844e-01
#' ## treatment:gender:phase:hour 0.4355822 7.100921e-01 0.7444364 7.878433e-01
#' ## 
#' ## Warning message:
#' ## In univariate(aov.car(value ~ treatment * gender + age + Error(id/phase *  :
#' ##   HF eps > 1 treated as 1
#'   
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
	browser()
	# stuff copied from aov:
	Terms <- terms(formula, "Error", data = data)
    indError <- attr(Terms, "specials")$Error
    if (length(indError) > 1L) 
        stop(sprintf(ngettext(length(indError), "there are %d Error terms: only 1 is allowed", 
            "there are %d Error terms: only 1 is allowed"), length(indError)), 
            domain = NA)
	#
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
		if (any(xtabs(as.formula(str_c("~", id, if (length(within) > 0) "+", rh1)), data = data) > 1)) {
			warning("More than one observation per cell, aggregating the data using mean (i.e, fun.aggregate = mean)!")
			fun.aggregate <- mean
		}
	}
	# Is Type = 3 and contrasts not contr.sum?
	if ((type == 3 | type == "III") & options("contrasts")[[1]][1] != "contr.sum") warning(str_c("Calculating Type 3 sums with contrasts = ", options("contrasts")[[1]][1], ".\n  Use options(contrasts=c('contr.sum','contr.poly')) instead"))
	# prepare the data:
	tmp.dat <- dcast(data, formula = as.formula(str_c(lh1, if (length(within) > 0) rh1 else ".", sep = "~")), fun.aggregate = fun.aggregate, ..., value.var = dv)
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


univariate <- function(object) { 
	# This function is basically a cropped copy of car::summary.Anova.mlm written by John Fox returning the output as a list (instead of printing it).
	GG <- function(SSPE, P){ # Greenhouse-Geisser correction
		p <- nrow(SSPE)
		if (p < 2) return(NA) 
		lambda <- eigen(SSPE %*% solve(t(P) %*% P))$values
		lambda <- lambda[lambda > 0]
		((sum(lambda)/p)^2)/(sum(lambda^2)/p)
	}
	HF <- function(gg, error.df, p){ # Huynh-Feldt correction
		((error.df + 1)*p*gg - 2)/(p*(error.df - p*gg))
	}
	mauchly <- function (SSD, P, df) {
		# most of this function borrowed from stats:::mauchly.test.SSD
		if (nrow(SSD) < 2) return(c(NA, NA))
		Tr <- function (X) sum(diag(X))
		p <- nrow(P)
		I <- diag(p)
		Psi <- t(P) %*% I %*% P 
		B <- SSD 
		pp <- nrow(SSD) 
		U <- solve(Psi, B)
		n <- df 
		logW <- log(det(U)) - pp * log(Tr(U/pp))
		rho <- 1 - (2 * pp^2 + pp + 2)/(6 * pp * n)
		w2 <- (pp + 2) * (pp - 1) * (pp - 2) * (2 * pp^3 + 6 * pp^2 + 
					3 * p + 2)/(288 * (n * pp * rho)^2)
		z <- -n * rho * logW
		f <- pp * (pp + 1)/2 - 1
		Pr1 <- pchisq(z, f, lower.tail = FALSE)
		Pr2 <- pchisq(z, f + 4, lower.tail = FALSE)
		pval <- Pr1 + w2 * (Pr2 - Pr1)
		c(statistic = c(W = exp(logW)), p.value = pval)
	}
	nterms <- length(object$terms)
	error.df <- object$error.df
	table <- matrix(0, nterms, 6)
	table2 <- matrix(0, nterms, 4)
	table3 <- matrix(0, nterms, 2)
	rownames(table3) <- rownames(table2) <- rownames(table) <- object$terms
	colnames(table) <- c("SS", "num Df", "Error SS", "den Df", "F", "Pr(>F)")
	colnames(table2) <- c("GG eps", "Pr(>F[GG])",  "HF eps", "Pr(>F[HF])")
	colnames(table3) <- c("Test statistic", "p-value")
	browser()
	for (term in 1:nterms){
		SSP <- object$SSP[[term]]
		SSPE <- object$SSPE[[term]]
		P <- object$P[[term]]
		p <- ncol(P)
		PtPinv <- solve(t(P) %*% P)
		gg <- GG(SSPE, P)
		table[term, "SS"] <- sum(diag(SSP %*% PtPinv))
		table[term, "Error SS"] <- sum(diag(SSPE %*% PtPinv))
		table[term, "num Df"] <- object$df[term] * p
		table[term, "den Df"] <- error.df * p
		table[term, "F"] <-  (table[term, "SS"]/table[term, "num Df"])/
				(table[term, "Error SS"]/table[term, "den Df"])
		table[term, "Pr(>F)"] <- pf(table[term, "F"], table[term, "num Df"],
				table[term, "den Df"], lower.tail=FALSE)
		table2[term, "GG eps"] <- gg
		table2[term, "HF eps"] <- HF(gg, error.df, p)
		table3[term,] <- mauchly(SSPE, P, object$error.df)
	}
	results <- list(anova = table)
	table3 <- na.omit(table3)
	if (nrow(table3) > 0){
		table2[,"Pr(>F[GG])"] <- pf(table[,"F"], table2[,"GG eps"]*table[,"num Df"],
				table2[,"GG eps"]*table[,"den Df"], lower.tail=FALSE)
		table2[,"Pr(>F[HF])"] <- pf(table[,"F"], 
				pmin(1, table2[,"HF eps"])*table[,"num Df"],
				pmin(1, table2[,"HF eps"])*table[,"den Df"], lower.tail=FALSE)
		table2 <- na.omit(table2)
		if (any(table2[,"HF eps"] > 1)) 
			warning("HF eps > 1 treated as 1")
		attributes(table2)[["na.action"]] <- NULL
		attributes(table3)[["na.action"]] <- NULL
		results <- c(results, mauchly = list(table3), sphericity.correction = list(table2))
	}
	results
}



