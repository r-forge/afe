# mixed vs lmer 

load(file = "mixed bug july 2013.Rdata")

# this works for both lmer and mixed
(ldmc1m = mixed(WD ~ dd + sp + sp*dd + (1|site), data= data_total_2))
ldmc1m = lmer(WD ~ dd + sp + sp*dd + (1|site), data= data_total_2)

# but with some added effects mixed returns and error while lmer does not.

ldmc1m = mixed(WD ~ dd + sp + sp*dd + dbh + sp*dbh + (1|site), data= data_total_2)

ldmc1m = mixed(WD ~ dd + sp + sp*dd + dbh + sp*dbh + (1|site), data= na.omit(data_total_2))


(ldmc1m = lmer(WD ~ dd + sp + sp*dd + dbh + sp*dbh + (1|site), data= data_total_2))

