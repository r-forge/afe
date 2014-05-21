

data(obk.long, package = "afex")

str(obk.long)

aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long, factorize=FALSE)

obk2 <- obk.long
levels(obk2$phase) <- c("fup test", "post-hans", "pre tenetious")

nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk2, factorize=FALSE)) # gave an error