	append.X.at.digit <- function(orig.string, X = "X") {
		out.string <- orig.string
		out.string[grepl("[[:digit:]]$", out.string)] <- str_c(out.string[grepl("[[:digit:]]$", out.string)], X)
		out.string
	}
	
	data.n <- data # create copy of data to work with	
	# add "X" to all colnames ending with digit to avoid problems with coding and change fixed and random accordingly
	colnames(data.n) <- append.X.at.digit(colnames(data))
	fixed.vars.orig <- all.vars(as.formula(str_c("~", fixed)))
	fixed.vars <- append.X.at.digit(fixed.vars.orig)
	fixed.orig <- fixed
	for (f in seq_along(fixed.vars.orig)) {
		fixed <- str_replace_all(fixed, fixed.vars.orig[f], fixed.vars[f])
	}
	random.vars.orig <- all.vars(as.formula(str_c("~", random)))
	random.vars <- append.X.at.digit(random.vars.orig)
	random.orig <- random
	for (f in seq_along(random.vars.orig)) {
		random <- str_replace_all(random, random.vars.orig[f], random.vars[f])
	}
	# done
	# contruct model matrix and map paramaters and effects
	m.matrix.full <- model.matrix(as.formula(str_c("~", fixed)), data = data.n)
	m.matrix <- m.matrix.full[,!colnames(m.matrix.full) %in% "(Intercept)"]
	m.matrix.param <- colnames(m.matrix)
	mm.params <- vapply(lapply(str_split(m.matrix.param, ":"), str_replace, pattern= "[[:digit:]]", replacement = ""), str_c, collapse = ":", "")
	fixed.effects <- attr(terms(as.formula(str_c("~", fixed)), data = data.n), "term.labels")
	# done
	# obtain the lmer fits
	full.model <- lmer(as.formula(str_c(dv, "~", fixed, "+", random)), data = data.n, ...)
	fits <- vector("list", length(fixed.effects))
	for (c in seq_along(fixed.effects)) {
		tmp.columns <- str_c(deparse(mm.params %in% fixed.effects[-c]), collapse = "")
		fits[[c]] <- lmer(as.formula(str_c(dv, "~ m.matrix[,", tmp.columns, "] +", random)), data = data.n, ...)
	}
	names(fits) <- fixed.effects