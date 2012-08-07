#' O'Brien Kaiser's Repeated-Measures Dataset with Covariate
#'
#' This is the long version of the \code{OBrienKaiser} dataset from the \pkg{car} pakage adding a random covariate \code{age}. Originally the dataset ist taken from O'Brien and Kaiser (1985). The description from \code{\link[car]{OBrienKaiser}} says: "These contrived repeated-measures data are taken from O'Brien and Kaiser (1985). The data are from an imaginary study in which 16 female and male subjects, who are divided into three treatments, are measured at a pretest, postest, and a follow-up session; during each session, they are measured at five occasions at intervals of one hour. The design, therefore, has two between-subject and two within-subject factors."
#'
#' @docType data
#' @keywords dataset
#' @name obk.long
#' @usage obk.long
#' @format A data frame with 240 rows and 8 variables.
#' @Source O’Brien, R. G., & Kaiser, M. K. (1985). MANOVA method for analyzing repeated measures designs: An extensive primer. \emph{Psychological Bulletin}, 97, 316–333. doi:10.1037/0033-2909.97.2.316
#'
#' @examples
#' # The dataset is constructed as follows:
#' set.seed(1)
#' OBrienKaiser2 <- within(OBrienKaiser, {
#' 		id <- factor(1:nrow(OBrienKaiser))
#' 		age <- scale(sample(18:35, nrow(OBrienKaiser), replace = TRUE), scale = FALSE)})
#' attributes(OBrienKaiser2$age) <- NULL # needed or resahpe2::melt throws an error.
#' OBrienKaiser2$age <- as.numeric(OBrienKaiser2$age)
#' obk.long <- melt(OBrienKaiser2, id.vars = c("id", "treatment", "gender", "age"))
#' obk.long[,c("phase", "hour")] <- lapply(as.data.frame(do.call(rbind,strsplit(as.character(obk.long$variable), "\\."),)), factor)
#' str(obk.long)
#' ## 'data.frame':   240 obs. of  8 variables:
#' ##  $ id       : Factor w/ 16 levels "1","2","3","4",..: 1 2 3 4 5 6 7 8 9 10 ...
#' ##  $ treatment: Factor w/ 3 levels "control","A",..: 1 1 1 1 1 2 2 2 2 3 ...
#' ##  $ gender   : Factor w/ 2 levels "F","M": 2 2 2 1 1 2 2 1 1 2 ...
#' ##  $ age      : num  -4.75 -2.75 1.25 7.25 -5.75 7.25 8.25 2.25 2.25 -7.75 ...
#' ##  $ variable : Factor w/ 15 levels "pre.1","pre.2",..: 1 1 1 1 1 1 1 1 1 1 ...
#' ##  $ value    : num  1 4 5 5 3 7 5 2 3 4 ...
#' ##  $ phase    : Factor w/ 3 levels "fup","post","pre": 3 3 3 3 3 3 3 3 3 3 ...
#' ##  $ hour     : Factor w/ 5 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
NULL
