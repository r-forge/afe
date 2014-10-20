# prepare data: short to long
data.short <- read.csv2("../../bugs/dietstudy3.csv")
library(reshape2)
data.long <- melt(data.short, id.vars= c("patid", "age", "gender", "VAR00001", "VAR2"), measure.vars=c("tg0","tg1"))
data.long[["patid"]] <- as.factor(data.long[["patid"]])
data.long[["gender"]] <- as.factor(data.long[["gender"]])
data.long[["age"]] <- as.factor(data.long[["age"]])
data.long[["VAR2"]] <- as.factor(data.long[["VAR2"]])

# this works
aov.car(value~ variable*gender+ Error(patid/variable), data = data.long,return = "univariate", type=3)
aov.car(value~ variable*age+ Error(patid/variable), data = data.long,return = "univariate", type=3)

# this gives an error
aov.car(value~ (variable*age*gender)+ Error(patid/variable), data = data.long,return = "univariate", type=3)
# this just omits the interaction effect between age and gender
r <- aov(value ~ (variable*age*gender)+ Error(patid/(variable)), data=data.long)
summary(r)

aov.car(value~ (age+gender)+ Error(patid/variable), data = data.long,return = "univariate", type=3)

# this gives an error
aov.car(value~ (variable*VAR2*age)+ Error(patid/variable), data = data.long,return = "univariate", type=3)
# this works and computes an interaction effect between age and VAR2!!!
r <- aov(value ~ (variable*age*VAR2)+ Error(patid/(variable)), data=data.long)
summary(r)

with(data.long, table(age,VAR2))



