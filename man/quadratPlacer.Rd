% Generated by roxygen2 (4.0.2): do not edit by hand
\name{quadratPlacer}
\alias{quadratPlacer}
\title{Randomly place quadrats in arena}
\usage{
quadratPlacer(no.quadrats, arena.length, quadrat.length)
}
\arguments{
\item{no.quadrats}{Number of quadrats to place}

\item{arena.length}{Length of one side of arena}

\item{quadrat.length}{Length of one side of desired quadrat}
}
\value{
A matrix with the X & Y coordinates of the four corners of each quadrat placed
}
\description{
Given a desired number of quadrats, the arena size, and the quadrat size, will attempt
to place quadrats down in a non-overlapping fashion
}
\details{
Places quadrats down in non-overlapping fashion according to parameters
supplied. Because this would run indefinitely if unacceptable parameters were supplied,
a conservative check is implemented to "ensure" the function does not get stuck.
}
\examples{
bounds <- quadratPlacer(no.quadrats=10, arena.length=300, quadrat.length=50)
}
\references{
Miller, Trisos and Farine.
}

