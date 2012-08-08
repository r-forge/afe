
require(car)
require(reshape2)
require(stringr)
require(lme4)
require(pbkrtest)

options(contrasts=c('contr.sum','contr.poly')) 


for (r.file in list.files("pkg/afe/R", full.names = TRUE)) {
	source(r.file)
}


options(error = recover)
options(error = NULL)
