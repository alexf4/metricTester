#' Randomly place quadrats in arena
#'
#' Given a desired number of quadrats, the arena size, and the quadrat size, will attempt
#' to place quadrats down in a non-overlapping fashion
#'
#' @param no.quadrats Number of quadrats to place
#' @param arena.length Length of one side of arena
#' @param quadrat.length Length of one side of desired quadrat
#' 
#' @details Places quadrats down in non-overlapping fashion according to parameters
#' supplied. Because this would run indefinitely if unacceptable parameters were supplied,
#' a conservative check is implemented to "ensure" the function does not get stuck.
#'
#' @return A matrix with the X & Y coordinates of the four corners of each quadrat placed
#'
#' @export
#'
#' @references Miller, Trisos and Farine.
#'
#' @examples
#'
#' bounds <- quadratPlacer(no.quadrats=10, arena.length=300, quadrat.length=50)

quadratPlacer <- function(no.quadrats, arena.length, quadrat.length)
{
	#this ugly bit of code is because I used to define these things as arguments to
	#function. this makes input easier. should fix code to just use arena.length and not
	#require x.max and y.max
	x.max=arena.length
	y.max=arena.length

	if(((quadrat.length^2)/(arena.length^2))*no.quadrats > 0.4)
	{
		stop("Quadrat and/or arena size parameters unsuitable. Sample less of total arena")
	}

	##define quadrat bounds, etc

	quadrat.bounds <- matrix(0,nrow=no.quadrats,ncol=4)
	colnames(quadrat.bounds) <- c("X1","X2","Y1","Y2")

	for (i in c(1:no.quadrats))
	{
		repeat 
		{
			OK <- TRUE
			quadrat.bounds[i,1] <- sample(c(0:(x.max-quadrat.length)),1)
			quadrat.bounds[i,2] <- quadrat.bounds[i,1] + quadrat.length
			quadrat.bounds[i,3] <- sample(c(0:(y.max-quadrat.length)),1)
			quadrat.bounds[i,4] <- quadrat.bounds[i,3] + quadrat.length
			if (i > 1) 
			{
				for (j in c(1:(i-1)))
				{
					if (any(
						quadrat.bounds[i,1] %in% c(quadrat.bounds[j,1]:quadrat.bounds[j,2]) 
							& quadrat.bounds[i,3] %in% c(quadrat.bounds[j,3]:quadrat.bounds[j,4]),
						quadrat.bounds[i,2] %in% c(quadrat.bounds[j,1]:quadrat.bounds[j,2]) 
							& quadrat.bounds[i,3] %in% c(quadrat.bounds[j,3]:quadrat.bounds[j,4]),
						quadrat.bounds[i,1] %in% c(quadrat.bounds[j,1]:quadrat.bounds[j,2]) 
							& quadrat.bounds[i,4] %in% c(quadrat.bounds[j,3]:quadrat.bounds[j,4]),
						quadrat.bounds[i,2] %in% c(quadrat.bounds[j,1]:quadrat.bounds[j,2]) 
							& quadrat.bounds[i,4] %in% c(quadrat.bounds[j,3]:quadrat.bounds[j,4])
						)) 
					{
						OK <- FALSE
					}
				}
			}
			if (OK == TRUE) 
			{
				break;
			}
		}
	}
	return(quadrat.bounds)
}
