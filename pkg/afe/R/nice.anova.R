
make.nice.anova <- function(anova, es = NULL) {
	is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol
	round.ps <- function(x) {
		as.character(ifelse(x < 0.001, "<.001", substr(ifelse(x < 0.01, formatC(x, digits = 3, format = "f"), formatC(x, digits = 2, format = "f")), 2, 5)))
	}
	make.fs <- function(anova) {
		ifelse(anova[["p"]] < 0.001, paste(formatC(anova[["F"]], digits = 2, format = "f"), "***"), 
		ifelse(anova[["p"]] < 0.01, paste(formatC(anova[["F"]], digits = 2, format = "f"), "**"), 
		ifelse(anova[["p"]] < 0.05, paste(formatC(anova[["F"]], digits = 2, format = "f"), "*"), 
		ifelse(anova[["p"]] < 0.1, paste(formatC(anova[["F"]], digits = 2, format = "f"), "+"), formatC(anova[["F"]], digits = 2, format = "f")))))
	}
	browser()
	if ((length(anova) > 2) & (names(anova)[3] != "aov")) {
		#browser()
		t.out <- anova[["ANOVA"]]
		t.out[row.names(anova[["Sphericity Corrections"]]), "DFn"] <- t.out[row.names(anova[["Sphericity Corrections"]]), "DFn"] * anova[["Sphericity Corrections"]][,"GGe"]
		t.out[row.names(anova[["Sphericity Corrections"]]), "DFd"] <- t.out[row.names(anova[["Sphericity Corrections"]]), "DFd"] * anova[["Sphericity Corrections"]][,"GGe"]
		t.out[row.names(anova[["Sphericity Corrections"]]), "p"] <- anova[["Sphericity Corrections"]][,"p[GG]"]
		t.out[row.names(anova[["Sphericity Corrections"]]), "p<.05"] <- anova[["Sphericity Corrections"]][,"p[GG]<.05"]
		tmp <- t.out
	} else {
		tmp <- anova[[1]]
	}
	#browser()
	tmp2 <- tmp[-1,]
	tmp2[,"df"] <- paste(ifelse(is.wholenumber(tmp2[,"DFn"]),tmp2[,"DFn"], round(tmp2[,"DFn"], 2)),  ifelse(is.wholenumber(tmp2[,"DFd"]),tmp2[,"DFd"], round(tmp2[,"DFd"], 2)), sep = ", ")
	tmp2[,"MSE"] <- tmp2[,"SSd"]/tmp2[,"DFd"]
	data.frame(Factor = tmp2[,"Effect"], df = tmp2[,"df"], MSE = formatC(tmp2[,"MSE"], digits = 2, format = "f"), F = make.fs(tmp2), g.eta = round.ps(tmp2[,"ges"]), p = round.ps(tmp2[,"p"]), stringsAsFactors = FALSE)
}

