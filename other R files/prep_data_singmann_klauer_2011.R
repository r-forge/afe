
require(afex) # needed for ANOVA and loading reshape2
require(reshape2) # may be required for transforming the data prior the analysis.
require(plotrix) # needed for plotting

##################
## Experiment 1 ##
##################

d.in <- read.table("experiment1.txt", header = TRUE)
### Variables:
# VP = Participant ID
# Bed = condition (1 = deductive, 2 = inductive/probabilistic)
# C = content/conditional:
#     1 = Wenn Wasser auf ein Lagerfeuer gegossen wurde, dann geht es aus.
#     2 = Wenn eine Person nass ist, dann ist sie in ein Schwimmbecken gefallen.
#     3 = Wenn eine Person viel Salz gegessen hat, dann ist sie durstig.
#     4 = Wenn eine Person sich verschluckt hat, dann hustet sie.
# direction: 1 = original; 2 = reversed


mean(d.in$age)

d.direction <- melt(d.in, id.vars=c("VP", "Bed"), measure.vars=c("C1_R", "C2_R", "C3_R", "C4_R"))
d.direction$content <- factor(substr(as.character(d.direction$variable),1,2))
d.direction <- within(d.direction, {
  variable <- NULL
  direction <- value
  value <- NULL
})
d.responses <- melt(d.in, id.vars=c("VP", "Bed"), measure.vars= paste0(rep(paste0("C", 1:4), each = 4), "_", c("MP", "AC", "MT", "DA"), "_1"))
d.responses$content <- factor(substr(d.responses$variable, 1, 2))
d.responses$inference <- factor(substr(d.responses$variable, 4, 5))
d.responses$variable <- NULL
dl <- merge(d.responses, d.direction)
dl <- within(dl, {
  VP <- factor(VP)
  instruction <- factor(Bed)
  type <- factor(direction)
  problem <- inference
})
dl$what <- factor(ifelse(dl$inference %in% c("MP", "AC"), "affirmation", "denial"))
head(dl)
str(dl)

sk2011.1 <- within(dl, {
  id <- VP
  inference <- factor(as.character(inference), levels = c("MP", "MT", "AC", "DA"))
  response <- value
  validity <- factor(ifelse(inference %in% c("MP", "MT"), "valid", "invalid"), levels = c("valid", "invalid"))
})

str(sk2011.1)

levels(sk2011.1$instruction) <- c("deductive", "probabilistic")
sk2011.1$plausibility <- factor(ifelse(as.numeric(sk2011.1$validity) == sk2011.1$direction, "plausible", "implausible"), levels = c("plausible", "implausible"))
sk2011.1$direction <- factor(sk2011.1$direction, 1:2, labels = c("original", "reversed"))
sk2011.1 <- sk2011.1[,c("id", "instruction", "plausibility", "inference", "validity", "what", "direction", "response", "content")]

str(sk2011.1)

save(sk2011.1, file = "sk2011.1.rda")

ez.glm("id", "response", sk2011.1[sk2011.1$what == "affirmation",], within = c("inference", "plausibility"), between = "instruction", args.return=(es = "pes"))

str(sk2011.1)



## ANOVAs:
ez.glm("VP", "value", dl[dl$what == "affirmation",], within = c("problem", "type"), between = "instruction", args.return=(es = "pes"))
ez.glm("VP", "value", dl[dl$what == "denial",], within = c("problem", "type"), between = "instruction", args.return=(es = "pes"))

### plots

#x-axis var:
dl$x <- factor(dl$problem:dl$type, levels = c("MP:1", "MP:2", "AC:2", "AC:1", "MT:1", "MT:2", "DA:2", "DA:1"))

# check plausibility factor:
with(sk2011.1, table(as.numeric(sk2011.1$validity) == sk2011.1$direction, x))

par(mfrow=c(1,2))
raw.means.plot2(dl[dl$what == "affirmation",], "VP", "instruction", "x", "value", main = "Affirmation Problems")
raw.means.plot2(dl[dl$what == "denial",], "VP", "instruction", "x", "value", main = "Denial Problems")
