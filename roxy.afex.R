
require(roxyPackage)
require(stringr)

## Windows
R.libs <- "C:/R/R-devel/library"
svn.number <- as.numeric(str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afex", intern = TRUE)[2], "[[:digit:]]+$")) + 1

# Linux:
R.libs <- "./packages/library"
svn.number <- as.numeric(substr(system("svn info", intern=TRUE)[6], 10, 15)) +1

roxy.package(
	pck.source.dir = "pkg/afex",
	pck.version = str_c("0.11-", svn.number),
	pck.description = data.frame(
		Package = "afex",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")),
        person(given=\"Ben\", family=\"Bolker\", role=c(\"ctb\")),
        person(given=\"Søren\", family=\"Højsgaard\", role=c(\"ctb\")),
        person(given=\"John\", family=\"Fox\", role=c(\"ctb\")),
        person(given=\"Michael A.\", family=\"Lawrence\", role=c(\"ctb\")),
        person(given=\"Ulf\", family=\"Mertens\", role=c(\"ctb\"))
    )",
		Depends = "R (>= 3.0.0), car, lme4 (>= 1.0.5)",
		Suggests = "ascii, xtable, parallel, plyr, optimx, nloptr",
        Imports = "stringr, coin, Matrix, pbkrtest (>= 0.3-6), reshape2",
		Description = "Provides convenience functions for analyzing factorial experiments using ANOVA or mixed modeling. ez.glm(), aov.car(), or aov4() allow convenient specification of between, within (i.e., repeated-measures), or mixed between-within (i.e., split-plot) ANOVAs for data in long format (i.e., one observation per row) aggregating more then one observation per individual and cell of the design. mixed() fits a mixed model using lme4::lmer() and computes p-values for all effects in the model using either Kenward-Roger approximation of degrees of freedom (LMM only), parametric bootstrap (LMMs and GLMMs) or likelihood ratio tests (LMMs and GLMMs). afex uses type 3 sums of squares as default (imitating commercial statistical software). compare.2.vectors() compares two vectors using a variety of tests (t, wilcoxon, and permutation).",
		URL = "http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex",
		License = "GPL (>=3)",
		Encoding = "latin1",
		stringsAsFactors = FALSE),
		actions = c("roxy"),
		R.libs = R.libs, 
		repo.root = tempdir())
#system("rmdir pkg/afex/inst")

#checkNEWS("pkg/afex/NEWS")

help(package = "afex")
		
options(error = recover)
options(error = NULL)
=======

require(roxyPackage)
require(stringr)

## Windows
R.libs <- "C:/R/R-devel/library"
svn.number <- as.numeric(str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afex", intern = TRUE)[2], "[[:digit:]]+$")) + 1

# Linux:
R.libs <- "./packages/library"
svn.number <- as.numeric(substr(system("svn info", intern=TRUE)[6], 10, 15)) +1

roxy.package(
	pck.source.dir = "pkg/afex",
	pck.version = str_c("0.9-", svn.number),
	pck.description = data.frame(
		Package = "afex",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")),
        person(given=\"Ben\", family=\"Bolker\", role=c(\"ctb\")),
        person(given=\"S??\", family=\"H??aard\", role=c(\"ctb\")),
        person(given=\"Ulrich\", family=\"Halekoh\", role=c(\"ctb\")),
        person(given=\"John\", family=\"Fox\", role=c(\"ctb\")),
        person(given=\"Michael A.\", family=\"Lawrence\", role=c(\"ctb\")))",
		Depends = "R (>= 3.0.0), car, lme4 (>= 1.0.5), pbkrtest (>= 0.3-6), reshape2",
		Suggests = "ascii, xtable, parallel",
        Imports = "stringr, coin, Matrix",
		Description = "Provides convenience functions for analyzing factorial experiments using ANOVA or mixed-models. ez.glm() and aov.car() allow convenient calculation of between, within (i.e., repeated-measures), or mixed between-within (i.e., split-plot) ANOVAs for data in the long format (i.e., one observation per row) wrapping car::Anova() (aggregating more then one observation per individual and cell of the design), per default returning a print ready ANOVA table. Function mixed() fits a mixed model using lme4::lmer() and computes p-values for all effects in the model using either the Kenward-Roger approximation of degrees of freedom (LMM only), parametric bootstrap (LMMs and GLMMs) or likelihood ratio tests (LMMs and GLMMs). afex uses type 3 sums of squares as default (imitating commercial statistical software) and sets the default contrasts to contr.sum. Furthermore, compare.2.vectors() conveniently compares two vectors using a variety of tests.",
		URL = "http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex",
		License = "GPL (>=3)",
		Encoding = "latin1",
		stringsAsFactors = FALSE),
		actions = c("roxy"),
		R.libs = R.libs, 
		repo.root = "rp.tmp")
#system("rmdir pkg/afex/inst")

#checkNEWS("pkg/afex/NEWS")

help(package = "afex")
		
options(error = recover)
options(error = NULL)
>>>>>>> .r109
