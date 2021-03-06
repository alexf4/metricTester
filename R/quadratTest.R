#' Calculate if single, observed metrics deviate beyond expectations
#'
#' Given a table of results, where means, SDs, and CIs are bound to the observed scores at
#' the corresponding richness or quadrat, this function calculates whether each observed
#' score is significantly less or ore than expected at that quadrat or richness.
#'
#' @param results.table Data frame of observed metrics with expected mean, SD and CI bound
#' in. See example
#' @param concat.by Whether to concatenate the results by richness or quadrat. If the
#' former, observed scores are compared to all randomized scores where the quadrat had the
#' corresponding richness. If the latter, observed scores (e.g. those from quadrat 1) are
#' compared to all randomized quadrat 1 scores.
#' @param metrics Optional list of named metric functions to use. These
#' must be defined in the defineMetrics function. If invoked, this option will likely
#' be used to run a subset of the defined metrics.
#' 
#' @details Given a table of results, where means, SDs, and CIs are bound to the observed
#' scores at the corresponding richness or quadrat, this function returns 0, 1, or 2,
#' corresponding to not significant, significantly clustered, and significantly
#' overdispersed. 
#'
#' @return A data frame of 0s, 1s, and 2s.
#'
#' @export
#'
#' @references Miller, Trisos and Farine.
#'
#' @examples
#' library(dplyr)
#' library(geiger)
#' library(picante)
#'
#' #simulate tree with birth-death process
#' tree <- sim.bdtree(b=0.1, d=0, stop="taxa", n=50)
#'
#' #simulate a log normal abundance distribution
#' sim.abundances <- round(rlnorm(5000, meanlog=2, sdlog=1)) + 1
#'
#' #simulate a community of varying richness
#' cdm <- simulateComm(tree, min.rich=10, max.rich=25, abundances=sim.abundances)
#'
#' #run the metrics and nulls combo function
#' rawResults <- metricsNnulls(tree, cdm)
#'
#' #reduce the randomizations to a more manageable format
#' reduced <- reduceRandomizations(rawResults)
#'
#' #calculate the observed metrics from the input CDM
#' observed <- observedMetrics(tree, cdm)
#'
#' #summarize the means, SD and CI of the randomizations
#' summarized <- lapply(reduced, summaries, concat.by="richness")
#'
#' #merge the observations and the summarized randomizations to facilitate significance
#' #testing
#' merged <- lapply(summarized, merge, observed)
#'
#' #calculate the standardized scores of each observed metric as compared to the richness
#' #null model randomization
#' quadratTest(merged$richness, "richness")
#'
#' #do the same as above but across all null models
#' temp <- lapply(1:length(merged), function(x) quadratTest(merged[[x]], "richness"))

quadratTest <- function(results.table, concat.by, metrics)
{
	#if a list of named metric functions is not passed in, assign metrics to be NULL, in
	#which case all length of all metrics will be used
	if(missing(metrics))
	{
		metrics <- NULL
	}
		
	#take advantage of the checkMetrics function to find the name of all metrics
	#get rid of the "richness" metric name
	metricNames <- names(checkMetrics(x=metrics))[2:length(names(checkMetrics(x=metrics)))]

	significance <- list()
	for(i in 1:length(metricNames))
	{
		upper.name <- paste(metricNames[i], "upper", sep=".")
		lower.name <- paste(metricNames[i], "lower", sep=".")
		upper <- results.table[,upper.name]
		lower <- results.table[,lower.name]
		overdispersed <- results.table[,metricNames[i]] > upper
		overdispersed[overdispersed==TRUE] <- 2
		clustered <- results.table[,metricNames[i]] < lower
		clustered[overdispersed==TRUE] <- 1
		significance[[i]] <- overdispersed + clustered
	}
	if(concat.by=="richness")
	{
		significance <- as.data.frame(significance)
		names(significance) <- metricNames
		significance <- data.frame(richness=results.table$richness, significance)
	}
	else if(concat.by=="quadrat")
	{
		significance <- as.data.frame(significance)
		names(significance) <- metricNames
		significance <- data.frame(quadrat=results.table$quadrat, significance)
	}
	significance
}
