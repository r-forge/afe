
# Bug again found by Florent Duyme.

DF <- structure(list(bloc = structure(c(1L, 2L, 3L, 4L, 1L, 2L, 3L,
4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L,
4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L), .Label = c("1", "2", "3",
"4"), class = "factor"), lig = c(1L, 2L, 3L, 4L, 1L, 2L, 3L,
4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L,
4L, 1L, 2L, 3L, 4L, 1L, 2L, 3L, 4L), col = c(8L, 4L, 7L, 1L,
7L, 5L, 6L, 2L, 9L, 1L, 8L, 3L, 6L, 3L, 10L, 5L, 1L, 10L, 3L,
6L, 3L, 8L, 5L, 7L, 4L, 6L, 1L, 8L, 2L, 9L, 4L, 10L), Y = c(79.64465581,
97.13568627, 104.0197731, 104.429902, 87.33669705, 108.0058824,
108.873939, 108.7458824, 89.5398797, 112.9268627, 109.1049594,
113.974902, 92.4359696, 113.8488235, 113.0375477, 114.4180392,
107.7362803, 102.8456863, 105.2918216, 104.0220588, 97.2575788,
106.7066667, 107.0558051, 107.0019608, 100.5673185, 107.2366667,
112.8855178, 117.3484314, 111.9817733, 107.855, 107.2195332,
112.9268627), fact1 = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 1L,
1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L,
2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L), .Label = c("15487", "15488"
), class = "factor"), fact2 = structure(c(1L, 1L, 1L, 1L, 2L,
2L, 2L, 2L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L, 1L, 1L, 1L, 1L, 2L,
2L, 2L, 2L, 3L, 3L, 3L, 3L, 4L, 4L, 4L, 4L), .Label = c("16050",
"16060", "16070", "16080"), class = "factor")), .Names = c("bloc",
"lig", "col", "Y", "fact1", "fact2"), row.names = c(NA, -32L), class = "data.frame")

 
# did always run
res_anov <- mixed(formula=Y~bloc + fact1*fact2 + (1|fact1:bloc),data=DF, na.action=na.exclude,  method="KR", type="III")


# when mixed() is included in a function, it has a strange behaviour :

 
aiv.sptest <- function(tablo) {

    tablo$bloc<-as.factor(tablo[,"bloc"])
    tablo$fact1<-as.factor(tablo[,"fact1"])
    tablo$fact2<-as.factor(tablo[,"fact2"])
        res_anov <- mixed(formula=Y~bloc + fact1*fact2 + (1|fact1:bloc),data=tablo, na.action=na.exclude,  method="KR", type="III")
        res_anov <- data.frame(res_anov$anova.table[,c(1:3,5)])
        print(res_anov)
}

# doesn't work:
aiv.sptest(DF)

# does work with exchanging data = table with data = DF in the function

# fixed in afex 0.4-43
