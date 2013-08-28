
require(devtools)
dev_mode()

install_github("lme4",user="lme4")

install.packages("pbkrtest_0.3-5.1.tar.gz", repos=NULL, type = "source")

# Examples:
data(obk.long, package = "afex")

#LMMs:
(x1 <- mixed(value ~ treatment*phase*hour +(1|id), data = obk.long))
str(x1, 1)

(x2 <- mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, method = "PB", args.test = list(nsim = 10)))
str(x2, 1)

(x3 <- mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, method = "LRT"))

#testing LRTs
mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, method = "LRT")
mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, method = "LRT", type = 2)

mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, type = 2)

### test type 2 tests:

t2 <- mixed(value ~ treatment*phase +(1|id), data = obk.long, method = "LRT", type = 2)

a2.f <- lmer(value ~ treatment*phase +(1|id), data = obk.long)
a2.h <- lmer(value ~ treatment+phase +(1|id), data = obk.long)
a2.t <- lmer(value ~ treatment +(1|id), data = obk.long)
a2.p <- lmer(value ~ phase +(1|id), data = obk.long)

## LRT
t2 <- mixed(value ~ treatment*phase +(1|id), data = obk.long, method = "LRT", type = 2)

anova(a2.f, a2.h)
anova(a2.t, a2.h)
anova(a2.p, a2.h)

# KR
t2 <- mixed(value ~ treatment*phase +(1|id), data = obk.long, type = 2)

t2[[1]]
KRmodcomp(a2.f, a2.h)
KRmodcomp(a2.t, a2.h)
KRmodcomp(a2.p, a2.h)

### test "per.parameter" argument

obk.long$hour <- ordered(obk.long$hour)

# tests only the main effect parameters of hour individually per parameter.
mixed(value ~ treatment*phase*hour +(1|id), per.parameter = "^hour$", data = obk.long)

# tests all parameters including hour individually
mixed(value ~ treatment*phase*hour +(1|id), per.parameter = "hour", data = obk.long)

# tests all parameters individually
mixed(value ~ treatment*phase*hour +(1|id), per.parameter = ".", data = obk.long)

### test "cl" (cluster)

require(parallel)
cl <- makeCluster(rep("localhost", 2), outfile = "cl.log.txt")

mixed(value ~ treatment*phase*hour +(1|id), data = obk.long, method = "LRT", cl = cl)


# example data from package languageR:
# Lexical decision latencies elicited from 21 subjects for 79 English concrete nouns, with variables linked to subject or word. 
data(lexdec, package = "languageR")

# using the simplest model
m1 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec)

m1 <- mixed(RT ~ Correct + Trial + (1|Subject) + (1|Word), data = lexdec, method = "PB")
m1 <- mixed(RT ~ Correct + Trial + (1|Subject) + (1|Word), data = lexdec, type = 2)


anova(m1)
# gives:
##                   Effect df1     df2      Fstat p.value
## 1            (Intercept)   1   96.64 13573.0985   0.000
## 2                Correct   1 1627.73     8.1452   0.004
## 3                  Trial   1 1592.43     7.5738   0.006
## 4               PrevType   1 1605.39     0.1700   0.680
## 5             meanWeight   1   75.39    14.8545   0.000
## 6              Frequency   1   76.08    56.5348   0.000
## 7         NativeLanguage   1   27.12     0.6953   0.412
## 8                 Length   1   75.83     8.6959   0.004
## 9    PrevType:meanWeight   1 1601.18     6.1823   0.013
## 10 NativeLanguage:Length   1 1555.49    14.2445   0.000

# using weights:
lex2 <- within(lexdec, weight.orig <- runif(nrow(lexdec)))

m1 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject), data = lex2, weights = weight.orig)

m1.type3 <- mixed(data = lex2, formula = RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject), weights = weight.orig, type = 3, method = "KR")

m1.type2 <- mixed(data = lex2, formula = RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject), weights = weight.orig, type = 2)

m2.type3 <- mixed(data = lex2, formula = RT ~ Correct + Trial + PrevType + Frequency + NativeLanguage  + (1|Subject), weights = weight.orig, type = 3, method = "KR")

m2.type2 <- mixed(data = lex2, formula = RT ~ Correct + Trial + PrevType + Frequency + NativeLanguage + (1|Subject), weights = weight.orig, type = 2)

# GLMM

require("mlmRev")

gm1 <- mixed(use ~ age + I(age^2) + urban + livch + (1 | district), family = binomial, data = Contraception, args.test = list(nsim = 10), method = "PB")

gm1 <- mixed(cbind(incidence, size - incidence) ~ period + (1 | herd),  family = binomial, data = cbpp, method = "PB", args.test = list(nsim = 10))
