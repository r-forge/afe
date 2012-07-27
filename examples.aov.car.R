
# important to set the correct contrasts when using Type 3 sums of squares:
options(contrasts=c('contr.sum','contr.poly')) 

# exampel using OBrienKaiser

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


# replicating ?Anova using aov.car:
aov.car(value ~ treatment * gender + Error(id/phase*hour), data = obk.long, type = 2)
# in contrast to aov you do not need the within-subject factors outside Error()

# replicating ?Anova using spss.glm:
spss.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", data = obk.long, type = 2)

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

spss.glm(id = "id", c("treatment", "gender"), c("phase", "hour"), "value", "age", data = obk.long, type = 2, print.formula = TRUE)
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


# aggregating over one within-subjects factor (hour):

aov.car(value ~ treatment * gender + age + Error(id/phase), data = obk.long, type = 2)

spss.gl(value ~ treatment * gender + age + Error(id/phase), data = obk.long, type = 2)





 