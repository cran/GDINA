% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bootSE.R
\name{bootSE}
\alias{bootSE}
\title{Calculating standard errors and variance-covariance matrix using bootstrap methods}
\usage{
bootSE(
  GDINA.obj,
  bootsample = 50,
  type = "nonparametric",
  cores = 1,
  seed = 12345
)
}
\arguments{
\item{GDINA.obj}{an object of class GDINA}

\item{bootsample}{the number of bootstrap samples}

\item{type}{type of bootstrap method. Can be \code{parametric} or \code{nonparametric}}

\item{cores}{number of cores to be used for calculation; Default = 1; if \code{cores>1}, bootstrap will run in parallel with \code{foreach} package.}

\item{seed}{random seed for resampling}
}
\value{
itemparm.se standard errors for item probability of success in list format

delta.se standard errors for delta parameters in list format

lambda.se standard errors for structural parameters of joint attribute distribution

boot.est resample estimates
}
\description{
This function conducts nonparametric and parametric bootstrap to calculate standard errors of model parameters.
Parametric bootstrap is only applicable to single group models.
}
\examples{
\dontrun{
# For illustration, only 5 resamples are run
# results are definitely not reliable

dat <- sim30GDINA$simdat
Q <- sim30GDINA$simQ
fit <- GDINA(dat = dat, Q = Q, model = "GDINA",att.dist = "higher.order")
boot.fit <- bootSE(fit,bootsample = 5,seed=123)
boot.fit$delta.se
boot.fit$lambda.se
}
}
\references{
Ma, W., & de la Torre, J. (2020). GDINA: An R Package for Cognitive Diagnosis Modeling. \emph{Journal of Statistical Software, 93(14)}, 1-26.
}
\author{
Wenchao Ma, The University of Minnesota, \email{wma@umn.edu}
}
