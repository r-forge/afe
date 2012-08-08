
require(roxyPackage)
require(stringr)

R.libs <- "C:/Program Files/R/R-2.15.1/library"
R.libs <- "C:/Program Files/R/R-2.15.0/library"

svn.number <- as.numeric(str_extract(system("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" pkg/afex", intern = TRUE)[2], "[[:digit:]]+$")) + 1

roxy.package(
	pck.source.dir = "pkg/afex",
	pck.version = str_c("0.2-", svn.number),
	pck.description = data.frame(
		Package = "afex",
		Type = "Package",
		Title = "Analysis of Factorial Experiments",
		Author = "Henrik Singmann <henrik.singmann@psychologie.uni-freiburg.de>",
		AuthorsR = "c(person(given=\"Henrik\", family=\"Singmann\", email=\"henrik.singmann@psychologie.uni-freiburg.de\", role=c(\"aut\", \"cre\")))",
		Depends = "R (>= 2.14.0), car, reshape2, stringr",
		Suggests = "ascii, xtable",
		Description = "Provides convenience functions for analyzing factorial experiments with ANOVA or ANCOVA replicating the behavior of commercial statisical packages (i.e., Type 3 sums of squares are the default). Specifically, afex provides the two functions aov.car and ez.glm for pure-between, pure-within (i.e., repeated-measures), and mixed between-within (i.e., split-plot) ANOVAs and ANCOVAs with type 2 and type 3 sums of squares for data in the long format (i.e., one obersvation per row) wrapping car::Anova(). If there is more than one obersvation per cell and subject, afex aggregates the data. Finally, function nice.anova produces publication ready ANOVA tables.",
		URL = "http://www.psychologie.uni-freiburg.de/Members/singmann/R/afex",
		License = "GPL (>=3)",
		Encoding = "UTF-8",
		stringsAsFactors = FALSE),
		actions = c("roxy", "package", "html", "check"),
		R.libs = R.libs, 
		repo.root = "rp.tmp")
system("rmdir pkg/afex/inst")

		
options(error = recover)
options(error = NULL)
