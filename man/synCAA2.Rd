% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/synCAA2.R
\docType{data}
\name{synCAA2}
\alias{synCAA2}
\title{Synthetic Catch-at-age data II}
\format{
A list consisting of:
\itemize{
  \item \code{midAge} a vector of the mid ages of the age groups,
  \item \code{catch} a matrix with the catches for different years.
}
}
\source{
Sparre, P., Venema, S.C., 1998. Introduction to tropical fish stock assessment.
  Part 1. Manual. \emph{FAO Fisheries Technical Paper}, (306.1, Rev. 2). 407 p.
}
\usage{
data(synCAA2)
}
\description{
Synthetic Catch-at-age data from Sparre & Venema (1998).
   Can be used for the estimation of the instantaneous mortality rate (Z) by
   means of the cumulative catch curve (\code{\link{catchCurve}}).
}
\examples{
data(synCAA2)
str(synCAA2)
summary(synCAA2)


}
\keyword{CAA}
\keyword{Catch-at-age}
\keyword{age}
\keyword{data}
\keyword{dataset}
