
require(car)
require(reshape2)
require(stringr)

options(contrasts=c('contr.sum','contr.poly')) 


for (r.file in list.files("pkg/afe/R", full.names = TRUE)) {
	source(r.file)
}


options(error = recover)
options(error = NULL)
