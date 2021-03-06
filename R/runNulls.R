#' Randomize input CDM according to defined null models
#'
#' Given a prepared nulls.input object, will randomize a community data matrix according
#' to all nulls defined in defineNulls, and return a list of randomized CDMs.
#'
#' @param nulls.input A prepared nulls.input object, as generated by prepNulls.
#' @param nulls Optional list of named null model functions to use. These
#' must be defined in the defineNulls function. If invoked, this option will likely
#' be used to run a subset of the defined null models.
#' 
#' @details Currently we are running 9 null models.
#' This function first confirms that the input is of class nulls.input and, if so, then
#' confirms that the nulls to be calculated are in a named list (via checkNulls),
#' then lapplies all null model functions to the input CDM.
#'
#' @return A list of matrices. Each matrix is a product of a randomization of the input
#' CDM and one of the nulls from defineNulls.
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
#'
#' results <- runNulls(prepped)

runNulls <- function(nulls.input, nulls)
{
	if(!inherits(nulls.input, "nulls.input"))
	{
		stop("Input needs to be of class 'nulls.input'")
	}
	
	#if a list of named nulls functions is not passed in, assign nulls to be NULL, in
	#which case all nulls will be run
	if(missing(nulls))
	{
		nulls <- NULL
	}	
	
	nulls <- checkNulls(nulls)
		
	lapply(nulls, function(x) x(nulls.input))
}
