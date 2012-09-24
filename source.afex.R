
require(coin)
require(reshape2)
require(stringr)
require(lme4)
require(pbkrtest)
require(car)

# require(R2WinBUGS)

options(contrasts=c('contr.sum','contr.poly')) 


for (r.file in list.files("pkg/afex/R", full.names = TRUE)) {
	source(r.file)
}


options(error = recover)
options(error = NULL)
