
load("affr.RData")

affr <- affr1[,c("id", "cond", "validity", "believability", "content", "resp", "n.validity", "n.bel1", "n.bel2", "n.cond")]

save(affr, file = "affr.rda")

