library(lme4)
sleepstudy$Days <- as.factor(sleepstudy$Days)
fm1 <- lmer(Reaction ~ Days + (1|Subject), sleepstudy)
library(multcomp)
summary(glht(fm1, linfct=mcp(Days="Tukey")), test=univariate())
library(afex)
mixed(Reaction ~ Days + (1|Subject), sleepstudy)

# produces error
summary(glht(fm1, linfct=mcp(Days="Tukey")), test=univariate())

# produces NO error
summary(glht(fm1, linfct=mcp(Days="Tukey")), test=multcomp::univariate())


detach(package:afex)
summary(glht(fm1, linfct=mcp(Days="Tukey")), test=univariate())
