
.onAttach <- function(libname, pkgname) {
	#assign(".oldContrasts", options("contrasts"), envir = .GlobalEnv)
  packageStartupMessage("************\nWelcome to afex created by Henrik Singmann. Important notes:")
	if (options("contrasts")[[1]][1] != "contr.sum") {
		packageStartupMessage("Setting contrasts to effects coding: options(contrasts=c('contr.sum', 'contr.poly'))")
        # \nPrevious contrasts saved in '.oldContrasts'.
		options(contrasts=c('contr.sum', 'contr.poly'))
	} else packageStartupMessage("Contrasts already set to effects coding: options(contrasts=c('contr.sum', '...'))")
  packageStartupMessage("afex loads the required packages (e.g., lme4, coin, car, pbkrtest) in an order that does not lead to problems.\nLoading any of the packages (specifically lme4) beforehand usually leads to problems.\nLoading nlme in addition to afex (before or after loading it), also leads to problems.\n************")
}

#' @export
# .Last.lib <- function(libpath) {
	# if (exists(".oldContrasts")) {
		# if (.oldContrasts[[1]][1] == "contr.sum") message("Unloading afe and removing '.oldContrasts'\nContrasts not restored, was unnecessary.")
		# else {
			# message("Unloading afe, restoring previous contrasts, and removing '.oldContrasts'.")
			# options(.oldContrasts)
		# }
		# rm(.oldContrasts)
	# } else message("Unloading afe but '.oldContrasts' not found.\nContrasts not restored, see 'options('contrasts')'")
# }
