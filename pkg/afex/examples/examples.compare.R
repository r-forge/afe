
with(sleep, compare.2.vectors(extra[group == 1], extra[group == 2]))

# gives:
##          test test.statistic test.value  test.df          p
## 1           t              t  -1.860813 18.00000 0.07918671
## 2       welch              t  -1.860813 17.77647 0.07939414
## 3    wilcoxon              W  25.500000       NA 0.06932758
## A permutation              Z  -1.750807       NA 0.08144796
