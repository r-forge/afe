
summary.Anova.mlm <- function(object, test.statistic, multivariate=TRUE, univariate=TRUE, 
		digits=getOption("digits"), ...){
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
	if (missing(test.statistic)) test.statistic <- c("Pillai", "Wilks", "Hotelling-Lawley", "Roy")
	test.statistic <- match.arg(test.statistic, c("Pillai", "Wilks", "Hotelling-Lawley", "Roy"),
			several.ok=TRUE)
	nterms <- length(object$terms)
	if (multivariate || !object$repeated){       
		cat(paste("\nType ", object$type, if (object$repeated) " Repeated Measures",
						" MANOVA Tests:\n", sep=""))
		if (!object$repeated){ 
			cat("\nSum of squares and products for error:\n")
			print(object$SSPE, digits=digits)
		}
		for (term in 1:nterms){
			cat(paste("\n------------------------------------------\n",
							"\nTerm:", object$terms[term], "\n"))
			hyp <- list(SSPH=object$SSP[[term]], 
					SSPE=if (object$repeated) object$SSPE[[term]] else object$SSPE,
					P=if (object$repeated) object$P[[term]] else NULL, 
					test=test.statistic, df=object$df[term], 
					df.residual=object$error.df, title=object$terms[term])
			class(hyp) <- "linearHypothesis.mlm"
			print(hyp, digits=digits, SSPE=object$repeated, ...)
		}
	}
	if (object$repeated && univariate){
		error.df <- object$error.df
		table <- matrix(0, nterms, 6)
		table2 <- matrix(0, nterms, 4)
		table3 <- matrix(0, nterms, 2)
		rownames(table3) <- rownames(table2) <- rownames(table) <- object$terms
		colnames(table) <- c("SS", "num Df", "Error SS", "den Df", "F", "Pr(>F)")
		colnames(table2) <- c("GG eps", "Pr(>F[GG])",  "HF eps", "Pr(>F[HF])")
		colnames(table3) <- c("Test statistic", "p-value")
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
		cat("\nUnivariate Type", object$type, 
				"Repeated-Measures ANOVA Assuming Sphericity\n\n")
		print.anova(table)
		table3 <- na.omit(table3)
		if (nrow(table3) > 0){
			cat("\n\nMauchly Tests for Sphericity\n\n")
			print.anova(table3)
			cat("\n\nGreenhouse-Geisser and Huynh-Feldt Corrections\n",
					"for Departure from Sphericity\n\n")
			table2[,"Pr(>F[GG])"] <- pf(table[,"F"], table2[,"GG eps"]*table[,"num Df"],
					table2[,"GG eps"]*table[,"den Df"], lower.tail=FALSE)
			table2[,"Pr(>F[HF])"] <- pf(table[,"F"], 
					pmin(1, table2[,"HF eps"])*table[,"num Df"],
					pmin(1, table2[,"HF eps"])*table[,"den Df"], lower.tail=FALSE)
			table2 <- na.omit(table2)
			print.anova(table2[,1:2, drop=FALSE])
			cat("\n")
			print.anova(table2[,3:4, drop=FALSE])
			if (any(table2[,"HF eps"] > 1)) 
				warning("HF eps > 1 treated as 1")
		}
	}
	invisible(object)
}

