pkgname <- "afe"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('afe')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("aov.car")
### * aov.car

flush(stderr()); flush(stdout())

### Name: aov.car
### Title: Convenience wrappers for car::Anova using either a formula or
###   factor based interface.
### Aliases: aov.car ez.glm univariate

### ** Examples

# exampel using OBrienKaiser dataset from package car (see ?OBrienKaiser)

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

# obtain mixed ANCOVA for the full design:
univariate(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long))
univariate(ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", "age", data = obk.long))
# both calls return the same:

## $anova
##                                      SS num Df  Error SS den Df           F       Pr(>F)
## (Intercept)                 6454.236987      1 215.65658      9 269.3547893 5.152317e-08
## treatment                    171.399953      2 215.65658      9   3.5765187 7.193619e-02
## gender                        94.598340      1 215.65658      9   3.9478742 7.818280e-02
## age                           12.398975      1 215.65658      9   0.5174466 4.901885e-01
## treatment:gender              61.531858      2 215.65658      9   1.2839551 3.231798e-01
## phase                        134.586005      2  59.72439     18  20.2810632 2.448505e-05
## treatment:phase               80.604542      4  59.72439     18   6.0732385 2.826803e-03
## gender:phase                   1.634246      2  59.72439     18   0.2462681 7.843036e-01
## age:phase                     20.553392      2  59.72439     18   3.0972362 6.982439e-02
## treatment:gender:phase        21.254421      4  59.72439     18   1.6014379 2.170946e-01
## hour                         108.513510      4  47.59543     36  20.5192290 7.001584e-09
## treatment:hour                 7.547869      8  47.59543     36   0.7136275 6.779072e-01
## gender:hour                    3.746135      4  47.59543     36   0.7083708 5.915285e-01
## age:hour                      14.904567      4  47.59543     36   2.8183608 3.926421e-02
## treatment:gender:hour          6.235198      8  47.59543     36   0.5895186 7.798264e-01
## phase:hour                     9.762579      8  88.62706     72   0.9913814 4.501348e-01
## treatment:phase:hour           6.579092     16  88.62706     72   0.3340505 9.915014e-01
## gender:phase:hour              8.851396      8  88.62706     72   0.8988515 5.222336e-01
## age:phase:hour                 7.539611      8  88.62706     72   0.7656409 6.339004e-01
## treatment:gender:phase:hour   12.822199     16  88.62706     72   0.6510416 8.307936e-01
##
## $mauchly
##                             Test statistic    p-value
## phase                         0.8217571566 0.45600959
## treatment:phase               0.8217571566 0.45600959
## gender:phase                  0.8217571566 0.45600959
## age:phase                     0.8217571566 0.45600959
## treatment:gender:phase        0.8217571566 0.45600959
## hour                          0.0966749877 0.04923980
## treatment:hour                0.0966749877 0.04923980
## gender:hour                   0.0966749877 0.04923980
## age:hour                      0.0966749877 0.04923980
## treatment:gender:hour         0.0966749877 0.04923980
## phase:hour                    0.0002379741 0.08651564
## treatment:phase:hour          0.0002379741 0.08651564
## gender:phase:hour             0.0002379741 0.08651564
## age:phase:hour                0.0002379741 0.08651564
## treatment:gender:phase:hour   0.0002379741 0.08651564
##
## $sphericity.correction
##                                GG eps   Pr(>F[GG])    HF eps   Pr(>F[HF])
## phase                       0.8487215 8.383485e-05 1.0252867 2.448505e-05
## treatment:phase             0.8487215 5.159591e-03 1.0252867 2.826803e-03
## gender:phase                0.8487215 7.493990e-01 1.0252867 7.843036e-01
## age:phase                   0.8487215 8.073373e-02 1.0252867 6.982439e-02
## treatment:gender:phase      0.8487215 2.279698e-01 1.0252867 2.170946e-01
## hour                        0.5341747 1.302016e-05 0.7054545 8.046331e-07
## treatment:hour              0.5341747 6.010781e-01 0.7054545 6.342676e-01
## gender:hour                 0.5341747 5.137213e-01 0.7054545 5.478398e-01
## age:hour                    0.5341747 8.155027e-02 0.7054545 6.211130e-02
## treatment:gender:hour       0.5341747 6.843526e-01 0.7054545 7.263729e-01
## phase:hour                  0.4355822 4.186799e-01 0.7444364 4.402119e-01
## treatment:phase:hour        0.4355822 9.317848e-01 0.7444364 9.787985e-01
## gender:phase:hour           0.4355822 4.651930e-01 0.7444364 5.020890e-01
## age:phase:hour              0.4355822 5.395151e-01 0.7444364 5.992844e-01
## treatment:gender:phase:hour 0.4355822 7.100921e-01 0.7444364 7.878433e-01
##
## Warning message:
## In univariate(aov.car(value ~ treatment * gender + age + Error(id/phase *  :
##   HF eps > 1 treated as 1


# replicating ?Anova using aov.car:
aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, type = 2)
# in contrast to aov you do not need the within-subject factors outside Error()

# replicating ?Anova using ez.glm:
ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", data = obk.long, type = 2)

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
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# adding age as a covariate:

aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long, type = 2)

ez.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", "age", data = obk.long, type = 2, print.formula = TRUE)
# Formula send to aov.car: value ~ treatment * gender + age+ Error(id/phase * hour)

# both return:
## Type II Repeated Measures MANOVA Tests: Pillai test statistic
##                             Df test stat approx F num Df den Df      Pr(>F)
## (Intercept)                  1     0.971    303.0      1      9 0.000000031 ***
## treatment                    2     0.490      4.3      2      9      0.0483 *
## gender                       1     0.323      4.3      1      9      0.0681 .
## age                          1     0.054      0.5      1      9      0.4902
## treatment:gender             2     0.222      1.3      2      9      0.3232
## phase                        1     0.851     22.8      2      8      0.0005 ***
## treatment:phase              2     0.763      2.8      4     18      0.0586 .
## gender:phase                 1     0.064      0.3      2      8      0.7665
## age:phase                    1     0.393      2.6      2      8      0.1358
## treatment:gender:phase       2     0.545      1.7      4     18      0.1967
## hour                         1     0.935     21.7      4      6      0.0010 **
## treatment:hour               2     0.534      0.6      8     14      0.7345
## gender:hour                  1     0.316      0.7      4      6      0.6237
## age:hour                     1     0.508      1.5      4      6      0.3008
## treatment:gender:hour        2     0.707      1.0      8     14      0.5043
## phase:hour                   1     0.721      0.6      8      2      0.7299
## treatment:phase:hour         2     1.076      0.4     16      6      0.9133
## gender:phase:hour            1     0.695      0.6      8      2      0.7665
## age:phase:hour               1     0.974      9.4      8      2      0.0997 .
## treatment:gender:phase:hour  2     1.314      0.7     16      6      0.7225
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# aggregating over one within-subjects factor (phase) with warning:

aov.car(value ~ treatment * gender + age + Error(id/hour), data = obk.long)

ez.glm(id = "id", c("treatment", "gender"), c("hour"), "value", "age", data = obk.long, print.formula = TRUE)


# runs with "numeric" factors
obk.long$hour2 <- as.numeric(as.character(obk.long$hour))

aov.car(value ~ treatment * gender + Error(id/hour2), data = obk.long, type = 2)



### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
