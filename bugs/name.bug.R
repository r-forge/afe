

data(obk.long, package = "afex")

str(obk.long)

nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long))

obk2 <- obk.long
levels(obk2$phase) <- c("fup test", "post-hans", "pre tenetious")

nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk2)) # gave an error