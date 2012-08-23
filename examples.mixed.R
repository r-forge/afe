

load("pkg/afe/data/affr.rda")

## > str(affr)
## 'data.frame':   960 obs. of  10 variables:
##  $ id           : Factor w/ 40 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ cond         : Factor w/ 2 levels "logic","pseudo": 2 2 2 2 2 2 2 2 2 2 ...
##  $ validity     : Factor w/ 2 levels "invalid","valid": 2 2 2 2 2 1 2 1 2 1 ...
##  $ believability: Factor w/ 3 levels "abstract","believable",..: 3 2 1 1 2 1 3 3 1 3 ...
##  $ content      : Factor w/ 24 levels "1","2","3","4",..: 11 19 6 21 13 18 14 23 15 2 ...
##  $ resp         : int  4 5 3 4 4 3 4 2 3 5 ...
##  $ n.validity   : num  -1 -1 -1 -1 -1 1 -1 1 -1 1 ...
##  $ n.bel1       : num  0 1 -1 -1 1 -1 0 0 -1 0 ...
##  $ n.bel2       : num  1 0 -1 -1 0 -1 1 1 -1 1 ...
##  $ n.cond       : num  1 1 1 1 1 1 1 1 1 1 ...

res1 <- mixed("cond * validity * believability", "(1|id) + (1|content)", "resp", affr)

mixed("n.cond * validity * (n.bel1 + n.bel2)", "(1|id) + (1|content)", "resp", affr)


# m1 <- lmer(resp ~ validity*believability*cond +(1|id) + (1|content), data = affr)

# example data from package languageR:
# Lexical decision latencies elicited from 21 subjects for 79 English concrete nouns, with variables linked to subject or word. 
data(lexdec, package = "languageR")

# using the simplest model
m1 <- mixed(RT ~ Correct + Trial + PrevType * meanWeight + Frequency + NativeLanguage * Length + (1|Subject) + (1|Word), data = lexdec, type = 2)


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