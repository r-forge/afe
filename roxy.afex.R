
require(roxyPackage)
require(stringr)

R.libs <- "C:/R/R-devel/library"

svn.number <- as.numeric(str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afex", intern = TRUE)[2], "[[:digit:]]+$")) + 1

roxy.package(
	pck.source.dir = "pkg/afex",
	pck.version = str_c("0.7-", svn.number),
	pck.description = data.frame(
		Package = "afex",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")))",
		Depends = "R (>= 2.14.0), coin, car, lme4 (>= 1.0.4), pbkrtest (>= 0.3-6)",
		Suggests = "ascii, xtable, parallel",
        Imports = "reshape2, stringr",
		Description = "Provides convenience functions for analyzing factorial experiments using ANOVA or mixed-models. ez.glm() and aov.car() allow convenient calculation of between, within (i.e., repeated-measures), or mixed between-within (i.e., split-plot) ANOVAs for data in the long format (i.e., one observation per row) wrapping car::Anova() (aggregating more then one observation per individual and cell of the design), per default returning a print ready ANOVA table. Function mixed() fits a mixed model using lme4::lmer() and computes p-values for all effects in the model using either the Kenward-Rogers approximation of degrees of freedom (LMM only), parametric bootstrap (LMMs and GLMMs) or likelihood ratio tests (LMMs and GLMMs). afex uses type 3 sums of squares as default (imitating commercial statistical software) and sets the default contrasts to contr.sum. Furthermore, compare.2.vectors() conveniently compares two vectors using a variety of tests.",
		URL = "http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex",
		License = "GPL (>=3)",
		Encoding = "UTF-8",
		stringsAsFactors = FALSE),
		actions = c("roxy"),
		R.libs = R.libs, 
		repo.root = "rp.tmp")
system("rmdir pkg/afex/inst")

checkNEWS("pkg/afex/NEWS")

help(package = "afex")
		
options(error = recover)
options(error = NULL)
