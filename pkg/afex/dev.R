require(devtools)
load_all()

require(testthat)
#test_dir("tests/testthat")
test_package("afex")
getwd()

getOption("contrasts")

options(error = recover)
options(error = NULL)
