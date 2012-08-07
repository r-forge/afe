

# first step, convert OBrienKaiser from wide to long format and add a (random) covariate age.
set.seed(1)
OBrienKaiser2 <- within(OBrienKaiser, {
		id <- factor(1:nrow(OBrienKaiser))
		age <- scale(sample(18:35, nrow(OBrienKaiser), replace = TRUE), scale = FALSE)})
attributes(OBrienKaiser2$age) <- NULL # needed or resahpe2::melt throws an error.
OBrienKaiser2$age <- as.numeric(OBrienKaiser2$age)
obk.long <- melt(OBrienKaiser2, id.vars = c("id", "treatment", "gender", "age"))
obk.long[,c("phase", "hour")] <- lapply(as.data.frame(do.call(rbind,strsplit(as.character(obk.long$variable), "\\."),)), factor)
str(obk.long)
## 'data.frame':   240 obs. of  8 variables:
##  $ id       : Factor w/ 16 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ treatment: Factor w/ 3 levels "control","A",..: 1 1 1 1 1 2 2 2 2 3 ...
##  $ gender   : Factor w/ 2 levels "F","M": 2 2 2 1 1 2 2 1 1 2 ...
##  $ age      : num  -4.75 -2.75 1.25 7.25 -5.75 7.25 8.25 2.25 2.25 -7.75 ...
##  $ variable : Factor w/ 15 levels "pre.1","pre.2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ value    : num  1 4 5 5 3 7 5 2 3 4 ...
##  $ phase    : Factor w/ 3 levels "fup","post","pre": 3 3 3 3 3 3 3 3 3 3 ...
##  $ hour     : Factor w/ 5 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...

# run univariate mixed ANCOVA for the full design:
nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long))


nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour"), "age"))

# no between
nice.anova(ez.glm("id", "value", obk.long, NULL, c("phase", "hour")))

# no within
nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender")))

nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender")), sig.symbol = rep("", 4))

# using aov.car:
nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long), MSE = FALSE)

\dontrun{
# use package asciis or xtable for nice formatting in manuscripts.

full <- nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour"), "age"))

require(ascii)
print(ascii(full, include.rownames = FALSE, caption = "ANOVA 1"), type = "org")

require(xtable)
print.xtable(xtable(full, caption = "ANOVA 2"), include.rownames = FALSE)
}


