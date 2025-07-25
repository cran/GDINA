% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/realdata_ECPE.R
\docType{data}
\name{realdata_ECPE}
\alias{realdata_ECPE}
\title{Examination for the Certificate of Proficiency in English (ECPE) data}
\format{
A list of responses and Q-matrix with components:
\describe{
\item{\code{dat}}{Responses of 2922 examinees to 28 items.}
\item{\code{Q}}{The \eqn{28 \times 3} Q-matrix.}
}
}
\usage{
realdata_ECPE
}
\description{
Examination for the Certificate of Proficiency in English (ECPE) data (the grammar section) has been used
in Henson and Templin (2007), Templin and Hoffman (2013), Feng, Habing, and Huebner (2014), and
Templin and Bradshaw (2014), among others.
}
\details{
The data consists of responses of 2922 examinees to 28 items involving 3 attributes.
Attribute 1 is morphosyntactic rules, Attribute 2 is cohesive rules and
Attribute 3 is lexical rules.
}
\examples{
\dontrun{
mod1 <- GDINA(realdata_ECPE$dat,realdata_ECPE$Q)
mod1
summary(mod1)

mod2 <- GDINA(realdata_ECPE$dat,realdata_ECPE$Q,model="RRUM")
mod2
anova(mod1,mod2)
# You may compare the following results with Feng, Habing, and Huebner (2014)
coef(mod2,"rrum")

# G-DINA with hierarchical structure
# see Templin & Bradshaw, 2014
ast <- att.structure(list(c(3,2),c(2,1)),K=3)

est.gdina2 <- GDINA(realdata_ECPE$dat,realdata_ECPE$Q,model = "GDINA",
                   control = list(conv.crit = 1e-6),
                   att.str = list(c(3,2),c(2,1)))
# see Table 7 in Templin & Bradshaw, 2014
summary(est.gdina2)
}

}
\references{
Ma, W., & de la Torre, J. (2020). GDINA: An R Package for Cognitive Diagnosis Modeling. \emph{Journal of Statistical Software, 93(14)}, 1-26.

Feng, Y., Habing, B. T., & Huebner, A. (2014). Parameter estimation of the reduced RUM using the EM algorithm. \emph{Applied Psychological Measurement, 38}, 137-150.

Henson, R. A., & Templin, J. (2007, April). Large-scale language assessment using cognitive diagnosis models. Paper presented at the annual meeting of the National Council for Measurement in Education in Chicago, Illinois.

Templin, J., & Bradshaw, L. (2014). Hierarchical diagnostic classification models: A family of models for estimating and testing attribute hierarchies. \emph{Psychometrika, 79}, 317-339.

Templin, J., & Hoffman, L. (2013). Obtaining diagnostic classification model estimates using Mplus. \emph{Educational Measurement: Issues and Practice, 32}, 37-50.
}
\author{
Wenchao Ma, The University of Minnesota, \email{wma@umn.edu}
}
\keyword{datasets}
