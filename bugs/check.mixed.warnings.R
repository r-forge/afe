load("gives.warnings.rda")

lmm1 <- mixed(diff.0 ~ inference + (inference|code) + (inference|item), p2sv, control = lmerControl(optCtrl = list(maxfun = 1000000)))

lmm1

lmm2 <- mixed(diff.0 ~ inference + (inference||code) + (1|item), p2sv, control = lmerControl(optCtrl = list(maxfun = 1000000)))
lmm2


lmm3 <- mixed(diff.0 ~ inference + (inference||code) + (inference|item), p2sv, control = lmerControl(optCtrl = list(maxfun = 1000000)))
lmm3
