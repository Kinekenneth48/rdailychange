% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{calc_d5_method}
\alias{calc_d5_method}
\title{Calculate Day-5 Method}
\usage{
calc_d5_method(d5_cands, dx)
}
\arguments{
\item{d5_cands}{A logical vector of indices associated with dx.
d4_cands(i) is TRUE if and only if dx(i) and dx(i + 4) are positive,
and at most one of dx(i + 1), dx(i + 2), or dx(i + 3) are negative.}

\item{dx}{A numeric vector of daily snow changes.}
}
\value{
A numeric vector of the Day-5 method. See details.
}
\description{
Takes a numeric vector of daily snow changes, as well as
a logical vector of possible indices to include in the Day-5 method,
and returns the vector of the Day-5 method.
}
\section{Details}{

An observation of the Day-5 method consists of the sum of five
consecutive elements of dx, the first and last of which must be
positive, only one negative observation in the middle,
and the sum of the five observations must be positive.
The d5_cands logical vector is TRUE when the first and fifth
observations are positive, and at most one of the second, third,
and fourth observation is negative. At the indices where d5_cands is TRUE,
this function sums the dx(i), dx(i + 1), dx(i + 2), dx(i + 3), dx(i + 4).
If that sum is positive, it is added as a value of the Day-5 method.
The function would then falsify d5_cands(i + 1), d5_cands(i + 2),
d5_cands(i + 3), and d5_cands(i + 4) as an index of dx can
be used in a sum only once.
}

\examples{
dx <- c(1, -3, 3, 1, 2, 3, 1, -7, 2, -1, -2, 3)
d5_cands <- c(TRUE, FALSE, TRUE, FALSE, TRUE,
              FALSE, FALSE, FALSE)
rdailychange:::calc_d5_method(d5_cands, dx)

}
