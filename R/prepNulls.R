#' Prep data for null randomizations
#'
#' Given a phylo object, a picante-style community data matrix (sites are rows,
#' species are columns), and an optional vector of regional abundance, prepare data for
#' randomizations.
#'
#' @param tree Phylo object
#' @param picante.cdm A picante-style community data matrix with sites as rows, and
#' species as columns
#' @param regional.abundance A character vector in the form "s1, s1, s1, s2, s2, s3, etc".
#' Optional, will be generated from the input CDM if not provided.
#' 
#' @details Returns a named list with four elements: the original phylogenetic tree,
#' the original picante-style CDM, an ecoPD-style CDM, and a vector of regional abundance.
#'
#' @return A list of class nulls.input
#'
#' @export
#'
#' @import phylobase grid ecoPDcorr
#'
#' @references Miller, Trisos and Farine.
#'
#' @examples
#' library(geiger)
#' library(picante)
#'
#' #simulate tree with birth-death process
#' tree <- sim.bdtree(b=0.1, d=0, stop="taxa", n=50)
#'
#' sim.abundances <- round(rlnorm(5000, meanlog=2, sdlog=1)) + 1
#'
#' cdm <- simulateComm(tree, min.rich=10, max.rich=25, abundances=sim.abundances)
#'
#' prepped <- prepNulls(tree, cdm)

#this function creates an object of class metrics.input, which is used internally by 
#metricTester to handle varying inputs for different metrics in different packages

prepNulls <- function(tree, picante.cdm, regional.abundance=NULL)
{
	spacodi.cdm <- suppressMessages(as.spacodi(picante.cdm))
	if(is.null(regional.abundance))
	{
		warning("Regional abundance not provided. Assumed to be equivalent to CDM")
		regional.abundance <- abundanceVector(picante.cdm)
	}
	dat <- list("tree"=tree, "picante.cdm"=picante.cdm, "spacodi.cdm"=spacodi.cdm, 
		"regional.abundance"=regional.abundance)
	class(dat) <- c("list", "nulls.input")
	dat
}
