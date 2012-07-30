
require(roxyPackage)

svn.number <- str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afe", intern = TRUE)[2], "[[:digit:]]+$")

roxy.package(
	pck.source.dir = "pkg/afe",
	pck.version = str_c("0.1-", svn.number),
	pck.description = data.frame(
		Package = "afe",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		Author = "Henrik Singmann <henrik.singmann@psychologie.uni-freiburg.de>",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")))",
		Depends = "R (>= 2.14.0), car, reshape2, stringr",
		Description = "Provides convenience functions for analyzing factorial experiments, namely provide convenience tools for repeated-measures ANOVA and ANCOVA analysis with type 2 and type 3 sums of squares wrapping car::Anova().",
		License = "GPL (>=3)",
		Encoding = "UTF-8",
		stringsAsFactors = FALSE),
		actions = c("roxy"),
		R.libs = "C:/Program Files/R/R-2.15.1/library", 
		repo.root = "rp.tmp")
		
		
options(error = recover)
options(error = NULL)
