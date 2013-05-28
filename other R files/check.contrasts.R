
require(afex)

data(obk.long)
str(obk.long)


## ez.glm 
res1 <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender")

contrasts(obk.long$treatment) <- "contr.treatment"
res2 <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender")
isTRUE(all.equal(res1, res2))
# TRUE

res2b <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender", check.contrasts = FALSE)
isTRUE(all.equal(res1, res2b))
# FALSE

options(contrasts=c('contr.treatment', 'contr.poly'))
res3 <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender")
isTRUE(all.equal(res1, res3))
# TRUE

res3b <- ez.glm("id", "value", obk.long, between = c("treatment", "gender"), within = c("phase", "hour"), observed = "gender", check.contrasts = FALSE)
isTRUE(all.equal(res1, res3b))
# FALSE

## mixed
data(obk.long)
options(contrasts=c('contr.sum','contr.poly'))

m1 <- mixed(value ~ treatment * phase + (hour|id), obk.long)

contrasts(obk.long$treatment) <- "contr.treatment"
m2 <- mixed(value ~ treatment * phase + (hour|id), obk.long)
isTRUE(all.equal(m1[[1]], m2[[1]]))
# TRUE

m2b <- mixed(value ~ treatment * phase + (hour|id), obk.long, check.contrasts = FALSE)
isTRUE(all.equal(m1[[1]], m2b[[1]]))
# FALSE

options(contrasts=c('contr.treatment', 'contr.poly'))
m3 <- mixed(value ~ treatment * phase + (hour|id), obk.long)
isTRUE(all.equal(m1[[1]], m3[[1]]))
# TRUE

m3b <- mixed(value ~ treatment * phase + (hour|id), obk.long, check.contrasts = FALSE)
isTRUE(all.equal(m1[[1]], m3b[[1]]))
# FALSE