require(devtools)
load_all()

require(testthat)
#test_dir("tests/testthat")
test_package("afex")

options(error = recover)
options(error = NULL)

#install.packages("afex", dependencies = TRUE)
#devtools::build()
devtools::build_vignettes()
clean_vignettes(pkg = ".")
