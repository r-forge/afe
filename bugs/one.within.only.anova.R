
data(obk.long, package = "afex")

# works
nice.anova(ez.glm("id", "value", obk.long, c("treatment", "gender"), c("phase", "hour")))

# works as well
nice.anova(ez.glm("id", "value", obk.long, within = c("phase", "hour")))

# does not work
nice.anova(ez.glm("id", "value", obk.long, within = c("phase")))

# works
nice.anova(ez.glm("id", "value", obk.long, c("treatment")))

