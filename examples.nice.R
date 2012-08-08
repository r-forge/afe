

# exampel using obk.long (see ?obk.long), a long version of the OBrienKaiser dataset from car.

data(obk.long)

# run univariate mixed ANCOVA for the full design:
nice.anova(aov.car(value ~ treatment * gender + age + Error(id/phase*hour), data = obk.long))

nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour"), "age"))

# no between
nice.anova(ez.glm("id", "value", obk.long, NULL, c("phase", "hour")))

# no within
nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender")))

nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender")), sig.symbol = rep("", 4))

\dontrun{
# use package ascii or xtable for formatting of tables ready for printing.

full <- nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour"), "age"))

require(ascii)
print(ascii(full, include.rownames = FALSE, caption = "ANOVA 1"), type = "org")

require(xtable)
print.xtable(xtable(full, caption = "ANOVA 2"), include.rownames = FALSE)
}
