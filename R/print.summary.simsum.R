#' print.summary.simsum
#'
#' @title Print method for summary.simsum objects
#' @param x An object of class `summary.simsum`
#' @param digits Number of significant digits used for printing. Defaults to 4.
#' @param sstat Summary statistics to print; can be a scalar of a vector (for printing multiple summary statistics at once). Possible choices are:
#' * `all`, all the summary statistics are printed. This is the default option.
#' * `bsims`, the number of non-missing point estimates.
#' * `sesims`, the number of non-missing standard errors.
#' * `bias`, bias in point estimate.
#' * `esd`, empirical standard error.
#' * `mse`, mean squared error.
#' * `relprec`, percentage gain in precision relative to the reference method.
#' * `modelse`, model-based standard error.
#' * `relerror`, relative percentage error in standard error.
#' * `cover`, coverage of a nominal `level`\% confidence interval.
#' * `power`, power of a (1 - `level`)\% level test.
#'
#' @note If `sstat` is a vector that contains `all`, all summary statistics are printed by default.
#' @export
#'
#' @examples
#' data("MIsim")
#' x = simsum(data = MIsim, estvarname = "b", true = 0.5, se = "se", methodvar = "method", mcse = TRUE)
#' xs = summary(x)
#' xs

print.summary.simsum <- function(x, digits = 4, sstat = "all") {
	### Check arguments
	arg_checks = checkmate::makeAssertCollection()

	# `x` must be an object of class `summary.simsum`
	checkmate::assert_class(x, classes = "summary.simsum", add = arg_checks)

	# `digits` must be an integer value greater than or equal to zero
	checkmate::assert_int(digits, lower = 0, upper = Inf, add = arg_checks)

	# `sstat` must be one of the possible choices
	checkmate::assert_subset(sstat, choices = c("all", "bsims", "sesims", "bias", "esd", "mse", "relprec", "modelse", "relerror", "cover", "power"), add = arg_checks)

	### Report if there are any errors
	if (!arg_checks$isEmpty()) checkmate::reportAssertions(arg_checks)

	### Print call to `simsum`
	cat("\nCall:\n\t", paste(deparse(x$call), sep = "\n", collapse = "\n"), "\n", sep = "")

	### Print `methodvar` (if any), possible methods, and reference method
	if (!is.null(x$methodvar)) {
		cat("\nMethod variable:", x$methodvar, "\n")
		methods = unique(x$summ$method)
		cat("\tUnique methods:", paste(methods, collapse = ", "), "\n")
		cat("\tReference method:", x$ref, "\n")
	} else {
		cat("\nMethod variable: none\n")
	}

	### Print `by` factors (if any)
	if (!is.null(x$by)) {
		cat("By factors:", paste(x$by, collapse = ", "), "\n")
	} else {
		cat("By factors: none\n")
	}

	### Select only summary statistics on interest
	if (!("all" %in% sstat)) {
		x$summ = x$summ[x$summ$stat %in% sstat,]
	}

	### Format summary table
	x = format(x = x, digits = digits)

	### Make names of the summary table
	names(x$summ)[names(x$summ) == "stat"] = " "
	names(x$summ)[names(x$summ) == "coef"] = "Coef"
	names(x$summ)[names(x$summ) == "mcse"] = "MCSE"
	if (x$mcse) {
		names(x$summ)[names(x$summ) == "lower"] = paste("Lower", sprintf("%.0f%%", 100 * (x$ci_level)))
		names(x$summ)[names(x$summ) == "upper"] = paste("Upper", sprintf("%.0f%%", 100 * (x$ci_level)))
	}

	### Print pretty summary
	cat("\nSummary statistics:\n")
	if (is.null(x$by) & is.null(x$methodvar)) {
		print(x$summ, row.names = FALSE)

	} else if (is.null(x$by) & !is.null(x$methodvar)) {
		methodvar_split = split(x$summ, f = lapply(x$methodvar, function(f) x$summ[[f]]))
		methodvar_split = lapply(methodvar_split, function(w) {
			w[[x$methodvar]] = NULL
			w})
		names(methodvar_split) = methods
		for (i in methods) {
			cat("\n\tMethod =", i, "\n")
			print(methodvar_split[[i]], row.names = FALSE)
		}
	} else if (!is.null(x$by) & is.null(x$methodvar)) {
		by_split = split(x$summ, f = lapply(x$by, function(f) x$summ[[f]]))
		for (i in seq_along(by_split)) {
			cat("\n\t", paste(paste(x$by, unlist(strsplit(names(by_split)[i], ".", fixed = TRUE)), sep = " = "), collapse = ", "), "\n")

			print(by_split[[i]], row.names = FALSE)
		}
	} else {
		by_split = split(x$summ, f = lapply(x$by, function(f) x$summ[[f]]))
		for (i in seq_along(by_split)) {
			for (w in x$by) {
				by_split[[i]][[w]] = NULL
			}
			methodvar_split = split(by_split[[i]], f = lapply(x$methodvar, function(f) by_split[[i]][[f]]))
			methodvar_split = lapply(methodvar_split, function(w) {
				w[[x$methodvar]] = NULL
				w})
			names(methodvar_split) = methods
			for (j in methods) {
				cat(paste0("\n\tMethod = ", j, ","), paste(paste(x$by, unlist(strsplit(names(by_split)[i], ".", fixed = TRUE)), sep = " = "), collapse = ", "), "\n")
				print(methodvar_split[[j]], row.names = FALSE)
			}
		}
	}
}