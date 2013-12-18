dat <- read.table('mydata.txt', header=T)
dat$ID <- as.factor(dat$ID)
#library(afex)
str(dat)
fm <- aov.car(Value ~ Propdd00 + Group + Gender + GAS0 + MAD0 + CPD0 + Error(ID/ROI), data=dat, factorize=FALSE)

fm0 <- aov.car(Value ~ MAD0 + CPD0 + Error(ID/ROI), data=dat, factorize=FALSE, return='full')

options(error = recover)
