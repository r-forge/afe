
.onAttach <- function(libname, pkgname) {
	.oldContrasts <- options("contrasts")
	if (.oldContrasts[[1]][1] != "contr.sum") {
		packageStartupMessage("Setting contrasts to effects coding: options(contrasts=c('contr.sum', 'contr.poly'))\n  Previous contrasts saved in \".oldContrasts.\"")
		options(contrasts=c('contr.sum', 'contr.poly'))
	} else packageStartupMessage("Contrasts already set to effects coding: options(contrasts=c('contr.sum', '...'))")
}

#' @export
.Last.Lib <- function(libpath) {
	if (exists(".oldContrasts")) {
		if (.oldContrasts[[1]][1] == "contr.sum") return()
		else {
			message("Unloading afe and resetting previous contrasts.")
			options(.oldContrasts)
		}
	}
}
