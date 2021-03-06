#' Apply wrapper for the wilcoWrap function
#'
#' Applies wilcoWrap over a dataframe of metric values, excluding richness.
#'
#' @param dataframe A dataframe of numeric values
#' @param alternative Optional alternative hypothesis. Default is "two-sided". Use 
#' "greater" for competition; "less" for habitat filtering.
#'
#' @details Applies wilcoWrap over a dataframe of metric values, excluding richness, which
#' is considered a metric in some previous functions. 
#'
#' @return A dataframe, with one row for each metric. The first column is the mean of the
#' vector of metric values, the second is the p.value of whether it differs from mu=0,
#' and the third is the name of the metric.
#'
#' @export
#'
#' @references Miller, Trisos and Farine.
#'
#' @examples
#' a <- rnorm(n=100)
#' b <- rnorm(n=100, mean=100)
#' ex <- data.frame(a, b)
#' tWrapApply(ex)

wilcoWrapApply <- function(dataframe, alternative)
{
	#exclude "richness" and "quadrat" columns
	exclude <- c("richness", "quadrat")
	temp <- dataframe[ ,!(names(dataframe) %in% exclude)]

	#apply wilcoWrap over data frame of metric SES scores for a given null and spatial sim
	output <- apply(temp, 2, wilcoWrap, mu=0, alternative)
	
	#transform the table, convert to a data frame, save the row names as an actual column,
	#exclude "richness" as a metric. output a data frame with three columns
	output <- t(output)

	#convert to data frame
	output <- as.data.frame(output)
	
	#add column names
	names(output) <- c("estimate", "p.value")
	
	#get rid of row names
	output$metric <- row.names(output)
	
	row.names(output) <- NULL

	output
}
