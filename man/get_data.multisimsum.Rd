% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_data.multisimsum.R
\name{get_data.multisimsum}
\alias{get_data.multisimsum}
\title{get_data.multisimsum}
\usage{
\method{get_data}{multisimsum}(x, sstat = "all", description = FALSE, ...)
}
\arguments{
\item{x}{An object of class \code{multisimsum}.}

\item{sstat}{Summary statistics to include; can be a scalar value or a vector. Possible choices are:
\itemize{
\item \code{all}, all the summary statistics are returned This is the default option.
\item \code{nsim}, the number of replications with non-missing point estimates and standard error.
\item \code{thetamean}, average point estimate.
\item \code{thetamedian}, median point estimate.
\item \code{se2mean}, average standard error.
\item \code{se2median}, median standard error.
\item \code{bias}, bias in point estimate.
\item \code{empse}, empirical standard error.
\item \code{mse}, mean squared error.
\item \code{relprec}, percentage gain in precision relative to the reference method.
\item \code{modelse}, model-based standard error.
\item \code{relerror}, relative percentage error in standard error.
\item \code{cover}, coverage of a nominal \code{level}\% confidence interval.
\item \code{bccover}, bias corrected coverage of a nominal \code{level}\% confidence interval.
\item \code{power}, power of a (1 - \code{level})\% level test.#'
}}

\item{description}{Append a column to the returned \code{data.frame} with a description of each summary statistic? Defaults to \code{FALSE}.}

\item{...}{Ignored.}
}
\value{
A \code{data.frame} containing summary statistics from a simulation study.
}
\description{
Extract data from a multisimsum object
}
\examples{
data(frailty)
ms <- multisimsum(data = frailty, par = "par", true = c(trt = -0.50,
   fv = 0.75), estvarname = "b", se = "se", methodvar = "model",
   by = "fv_dist")
get_data(ms)
get_data(ms, description = TRUE)
}
\seealso{
\code{\link[=multisimsum]{multisimsum()}}, \code{\link[=get_data]{get_data()}}
}
