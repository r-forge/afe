pkgname <- "afex"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('afex')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("aov.car")
### * aov.car

flush(stderr()); flush(stdout())

### Name: aov.car
### Title: Convenience wrappers for car::Anova using either a formula or
###   factor based interface.
### Aliases: aov.car ez.glm univ

### ** Examples


# exampel using obk.long (see ?obk.long), a long version of the OBrienKaiser dataset from car.

data(obk.long, package = "afex")

# run univariate mixed ANOVA for the full design:
aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, observed = "gender")

ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender")

# both calls return the same:
##                         Effect          df   MSE         F  ges     p
## 1                    treatment       2, 10 22.81    3.94 +  .20   .05
## 2                       gender       1, 10 22.81    3.66 +  .11   .08
## 3             treatment:gender       2, 10 22.81      2.86  .18   .10
## 4                        phase 1.60, 15.99  5.02 16.13 ***  .15 <.001
## 5              treatment:phase 3.20, 15.99  5.02    4.85 *  .10   .01
## 6                 gender:phase 1.60, 15.99  5.02      0.28 .003   .71
## 7       treatment:gender:phase 3.20, 15.99  5.02      0.64  .01   .61
## 8                         hour 1.84, 18.41  3.39 16.69 ***  .13 <.001
## 9               treatment:hour 3.68, 18.41  3.39      0.09 .002   .98
## 10                 gender:hour 1.84, 18.41  3.39      0.45 .004   .63
## 11       treatment:gender:hour 3.68, 18.41  3.39      0.62  .01   .64
## 12                  phase:hour 3.60, 35.96  2.67      1.18  .02   .33
## 13        treatment:phase:hour 7.19, 35.96  2.67      0.35 .009   .93
## 14           gender:phase:hour 3.60, 35.96  2.67      0.93  .01   .45
## 15 treatment:gender:phase:hour 7.19, 35.96  2.67      0.74  .02   .65


# replicating ?Anova using aov.car:
aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, type = 2, return = "Anova")
# in contrast to aov you do not need the within-subject factors outside Error()

# replicating ?Anova using ez.glm:
ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour"), type = 2, return = "Anova")

#both return:
## Type II Repeated Measures MANOVA Tests: Pillai test statistic
##                             Df test stat approx F num Df den Df       Pr(>F)    
## (Intercept)                  1     0.970      318      1     10 0.0000000065 ***
## treatment                    2     0.481        5      2     10      0.03769 *  
## gender                       1     0.204        3      1     10      0.14097    
## treatment:gender             2     0.364        3      2     10      0.10447    
## phase                        1     0.851       26      2      9      0.00019 ***
## treatment:phase              2     0.685        3      4     20      0.06674 .  
## gender:phase                 1     0.043        0      2      9      0.82000    
## treatment:gender:phase       2     0.311        1      4     20      0.47215    
## hour                         1     0.935       25      4      7      0.00030 ***
## treatment:hour               2     0.301        0      8     16      0.92952    
## gender:hour                  1     0.293        1      4      7      0.60237    
## treatment:gender:hour        2     0.570        1      8     16      0.61319    
## phase:hour                   1     0.550        0      8      3      0.83245    
## treatment:phase:hour         2     0.664        0     16      8      0.99144    
## gender:phase:hour            1     0.695        1      8      3      0.62021    
## treatment:gender:phase:hour  2     0.793        0     16      8      0.97237    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

# ANCOVA: adding a covariate (necessary to set factorize = FALSE)
aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long, observed = c("gender", "age"), factorize = FALSE)

ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), covariate = "age", observed = c("gender", "age"), factorize = FALSE)

# aggregating over one within-subjects factor (phase) with warning:
aov.car(value ~ treatment * gender + Error(id/hour), data = obk.long, observed = "gender")

ez.glm("id", "value", obk.long, c("treatment", "gender"), "hour", observed = "gender")

# runs with "numeric" factors
obk.long$hour2 <- as.numeric(as.character(obk.long$hour))

aov.car(value ~ treatment * gender + Error(id/hour2), data = obk.long, type = 2,observed = c("gender"))

# only between
aov.car(value ~ treatment * gender + Error(id), data = obk.long, type = 2,observed = c("gender"))
aov.car(value ~ treatment * gender + Error(id), data = obk.long, type = 2, observed = c("gender"))

ez.glm("id", "value", obk.long, c("treatment", "gender"), within = NULL, type = 2, print.formula = TRUE, observed = "gender")

# only within

aov.car(value ~ Error(id/phase*hour), data = obk.long, type = 2)

ez.glm("id", "value", obk.long,  NULL, c("phase", "hour"), type = 2, print.formula = TRUE)

# using return = "full":

str(aov.car(value ~ Error(id/phase*hour), data = obk.long, return = "full"), 1)

## List of 4
##  $ Anova:List of 14
##   ..- attr(*, "class")= chr "Anova.mlm"
##  $ lm   :List of 11
##   ..- attr(*, "class")= chr [1:2] "mlm" "lm"
##  $ data :'data.frame':  16 obs. of  16 variables:
##  $ idata:'data.frame':  15 obs. of  2 variables:

# use args.return arguments:
aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, args.return = list(correction = "none", es = "pes"))

aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long,observed = "gender", args.return = list(correction = "none", MSE = FALSE))




cleanEx()
nameEx("compare.2.vectors")
### * compare.2.vectors

flush(stderr()); flush(stdout())

### Name: compare.2.vectors
### Title: Compare two vectors using various tests.
### Aliases: compare.2.vectors

### ** Examples


with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2]))

# gives:
## $parametric
##    test test.statistic test.value test.df       p
## 1     t              t     -1.861   18.00 0.07919
## 2 Welch              t     -1.861   17.78 0.07939
## 
## $nonparametric
##              test test.statistic test.value test.df       p
## 1 stats::Wilcoxon              W     25.500      NA 0.06933
## 2     permutation              Z     -1.751      NA 0.08154
## 3  coin::Wilcoxon              Z     -1.854      NA 0.06487
## 4          median              Z      1.744      NA 0.17867

# compare with:
with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2], alternative = "less"))

with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2], alternative = "greater"))

# doesn't make much sense as the data is not paired, but whatever:
with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2], paired = TRUE))

# from ?t.test:
compare.2.vectors(1:10,y=c(7:20, 200))




cleanEx()
nameEx("mixed")
### * mixed

flush(stderr()); flush(stdout())

### Name: mixed
### Title: Obtain p-values for a mixed-model from lmer().
### Aliases: mixed

### ** Examples

## Not run: 
##D 
##D # use the obk.long data (mildly reasonable)
##D data(obk.long)
##D mixed(value ~ treatment * phase + (hour|id), obk.long)
##D 
##D # Examples for using the per.parammeter argument:
##D data(obk.long, package = "afex")
##D obk.long$hour <- ordered(obk.long$hour)
##D 
##D # tests only the main effect parameters of hour individually per parameter.
##D mixed(value ~ treatment*phase*hour +(1|id), per.parameter = "^hour$", data = obk.long)
##D 
##D # tests all parameters including hour individually
##D mixed(value ~ treatment*phase*hour +(1|id), per.parameter = "hour", data = obk.long)
##D 
##D # tests all parameters individually
##D mixed(value ~ treatment*phase*hour +(1|id), per.parameter = ".", data = obk.long)
##D 
##D # example data from package languageR:
##D # Lexical decision latencies elicited from 21 subjects for 79 English concrete nouns, with variables linked to subject or word.
##D data(lexdec, package = "languageR")
##D 
##D # using the simplest model
##D m1 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight +
##D     Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec)
##D 
##D m1
##D # gives:
##D ##                   Effect df1       df2      Fstat p.value
##D ## 1            (Intercept)   1   96.6379 13573.1410  0.0000
##D ## 2                Correct   1 1627.7303     8.1452  0.0044
##D ## 3                  Trial   1 1592.4301     7.5738  0.0060
##D ## 4               PrevType   1 1605.3939     0.1700  0.6802
##D ## 5             meanWeight   1   75.3919    14.8545  0.0002
##D ## 6              Frequency   1   76.0821    56.5348  0.0000
##D ## 7         NativeLanguage   1   27.1213     0.6953  0.4117
##D ## 8                 Length   1   75.8259     8.6959  0.0042
##D ## 9    PrevType:meanWeight   1 1601.1850     6.1823  0.0130
##D ## 10 NativeLanguage:Length   1 1555.4858    14.2445  0.0002
##D 
##D # Fitting a GLMM using parametric bootstrap:
##D require("mlmRev") # for the data, see ?Contraception
##D 
##D gm1 <- mixed(use ~ age + I(age^2) + urban + livch + (1 | district),
##D  family = binomial, data = Contraception, args.test = list(nsim = 10), method = "PB")
## End(Not run)



cleanEx()
nameEx("nice.anova")
### * nice.anova

flush(stderr()); flush(stdout())

### Name: nice.anova
### Title: Make nice ANOVA table for printing.
### Aliases: nice.anova

### ** Examples

# exampel using obk.long (see ?obk.long), a long version of the OBrienKaiser dataset from car.

data(obk.long)
# create object of class Anova:
tmp.aov <- aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, return = "Anova")

nice.anova(tmp.aov, observed = "gender")

nice.anova(tmp.aov, observed = "gender", sig.symbol = rep("", 4))

## Not run: 
##D # use package ascii or xtable for formatting of tables ready for printing.
##D 
##D full <- nice.anova(tmp.aov, observed = "gender")
##D 
##D require(ascii)
##D print(ascii(full, include.rownames = FALSE, caption = "ANOVA 1"), type = "org")
##D 
##D require(xtable)
##D print.xtable(xtable(full, caption = "ANOVA 2"), include.rownames = FALSE)
## End(Not run)



cleanEx()
nameEx("obk.long")
### * obk.long

flush(stderr()); flush(stdout())

### Name: obk.long
### Title: O'Brien Kaiser's Repeated-Measures Dataset with Covariate
### Aliases: obk.long
### Keywords: dataset datasets

### ** Examples

# The dataset is constructed as follows:
set.seed(1)
OBrienKaiser2 <- within(OBrienKaiser, {
		id <- factor(1:nrow(OBrienKaiser))
		age <- scale(sample(18:35, nrow(OBrienKaiser), replace = TRUE), scale = FALSE)})
attributes(OBrienKaiser2$age) <- NULL # needed or resahpe2::melt throws an error.
OBrienKaiser2$age <- as.numeric(OBrienKaiser2$age)
obk.long <- melt(OBrienKaiser2, id.vars = c("id", "treatment", "gender", "age"))
obk.long[,c("phase", "hour")] <- lapply(as.data.frame(do.call(rbind,strsplit(as.character(obk.long$variable), "\\."),)), factor)
obk.long <- obk.long[,c("id", "treatment", "gender", "age", "phase", "hour", "value")]
obk.long <- obk.long[order(obk.long$id),]
rownames(obk.long) <- NULL
str(obk.long)
## 'data.frame':   240 obs. of  7 variables:
##  $ id       : Factor w/ 16 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ treatment: Factor w/ 3 levels "control","A",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ gender   : Factor w/ 2 levels "F","M": 2 2 2 2 2 2 2 2 2 2 ...
##  $ age      : num  -4.75 -4.75 -4.75 -4.75 -4.75 -4.75 -4.75 -4.75 -4.75 -4.75 ...
##  $ phase    : Factor w/ 3 levels "fup","post","pre": 3 3 3 3 3 2 2 2 2 2 ...
##  $ hour     : Factor w/ 5 levels "1","2","3","4",..: 1 2 3 4 5 1 2 3 4 5 ...
##  $ value    : num  1 2 4 2 1 3 2 5 3 2 ...
head(obk.long)
##    id treatment gender   age phase hour value
## 1  1   control      M -4.75   pre    1     1
## 2  1   control      M -4.75   pre    2     2
## 3  1   control      M -4.75   pre    3     4
## 4  1   control      M -4.75   pre    4     2
## 5  1   control      M -4.75   pre    5     1
## 6  1   control      M -4.75  post    1     3



### * <FOOTER>
###
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
