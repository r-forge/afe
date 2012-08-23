
require(roxyPackage)
require(stringr)

R.libs <- "C:/Program Files/R/R-2.15.1/library"
R.libs <- "C:/Program Files/R/R-2.15.0/library"

svn.number <- as.numeric(str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afex", intern = TRUE)[2], "[[:digit:]]+$")) + 1

roxy.package(
	pck.source.dir = "pkg/afex",
	pck.version = str_c("0.3-", svn.number),
	pck.description = data.frame(
		Package = "afex",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		Author = "Henrik Singmann <henrik.singmann@psychologie.uni-freiburg.de>",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")))",
		Depends = "R (>= 2.14.0), car, lme4, pbkrtest, reshape2, stringr, coin",
		Suggests = "ascii, xtable",
		Description = "Provides convenience functions for analyzing factorial experiments using ANOVA or mixed-models. Functions ez.glm() and aov.car() allow convenient specification of pure-between, pure-within (i.e., repeated-measures), and mixed between-within (i.e., split-plot) ANOVAs and ANCOVAs with type 2 and type 3 sums of squares for data in the long format (i.e., one observation per row) wrapping car::Anova() (aggregating more then one observation per individual and cell of the design). Function nice.anova() produces publication ready ANOVA tables. Function mixed() fits a mixed model using lme4::lmer() and computes p-values for all effects in the model (using the Kenward-Rogers approximation of degrees of freedom). afex uses type 3 sums of squares as default (imitating commercial statistical software) and sets the default contrasts to contr.sum.",
		URL = "http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex",
		License = "GPL (>=3)",
		Encoding = "UTF-8",
		stringsAsFactors = FALSE),
		actions = c("roxy", "package", "html", "check", "doc"),
		R.libs = R.libs, 
		repo.root = "rp.tmp")
system("rmdir pkg/afex/inst")

checkNEWS("pkg/afex/NEWS")

help(package = "afex")
		
options(error = recover)
options(error = NULL)
