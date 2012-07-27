
require(car)
require(reshape2)
require(stringr)

for (r.file in list.files("pkg/afe/R", full.names = TRUE)) {
	source(r.file)
}


options(error = recover)
options(error = NULL)
