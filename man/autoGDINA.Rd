% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autoGDINA.R, R/summary.GDINA.R
\name{autoGDINA}
\alias{autoGDINA}
\alias{summary.autoGDINA}
\title{Q-matrix validation, model selection and calibration in one run}
\usage{
autoGDINA(
  dat,
  Q,
  modelselection = TRUE,
  modelselectionrule = "simpler",
  alpha.level = 0.05,
  modelselection.args = list(),
  Qvalid = TRUE,
  Qvalid.args = list(),
  GDINA1.args = list(),
  GDINA2.args = list(),
  CDM.args = list()
)

\method{summary}{autoGDINA}(object, ...)
}
\arguments{
\item{dat}{A required \eqn{N \times J} \code{matrix} or \code{data.frame} consisting of the
responses of \eqn{N} individuals to \eqn{J} items. Missing values need to be coded as \code{NA}.}

\item{Q}{A required matrix; The number of rows occupied by a single-strategy dichotomous item is 1, by a polytomous item is
the number of nonzero categories, and by a mutiple-strategy dichotomous item is the number of strategies.
The number of column is equal to the number of attributes if all items are single-strategy dichotomous items, but
the number of attributes + 2 if any items are polytomous or have multiple strategies.
For a polytomous item, the first column represents the item number and the second column indicates the nonzero category number.
For a multiple-strategy dichotomous item, the first column represents the item number and the second column indicates the strategy number.
For binary attributes, 1 denotes the attributes are measured by the items and 0 means the attributes are not
   measured. For polytomous attributes, non-zero elements indicate which level
   of attributes are needed (see Chen, & de la Torre, 2013).  See \code{Examples}.}

\item{modelselection}{logical; conducting model selection or not?}

\item{modelselectionrule}{how to conducted model selection? Possible options include
\code{simpler}, \code{largestp} and \code{DS}. See \code{Details}.}

\item{alpha.level}{nominal level for the Wald test. The default is 0.05.}

\item{modelselection.args}{arguments passed to \code{modelcomp}}

\item{Qvalid}{logical; validate Q-matrix or not? \code{TRUE} is the default.}

\item{Qvalid.args}{arguments passed to \code{Qval}}

\item{GDINA1.args}{arguments passed to GDINA function for initial G-DINA calibration}

\item{GDINA2.args}{arguments passed to GDINA function for the second G-DINA calibration}

\item{CDM.args}{arguments passed to GDINA function for final calibration}

\item{object}{GDINA object for various S3 methods}

\item{...}{additional arguments}
}
\value{
a list consisting of the following elements:
\describe{
\item{GDINA1.obj}{initial GDINA calibration of class \code{GDINA}}
\item{GDINA2.obj}{second GDINA calibration of class \code{GDINA}}
\item{Qval.obj}{Q validation object of class \code{Qval}}
\item{Wald.obj}{model comparison object of class \code{modelcomp}}
\item{CDM.obj}{Final CDM calibration of class \code{GDINA}}
}
}
\description{
\code{autoGDINA} conducts a series of CDM analyses within the G-DINA framework. Particularly,
the GDINA model is fitted to the data first using the \code{\link{GDINA}} function;
then, the Q-matrix is validated using the function \code{\link{Qval}}.
Based on the suggested Q-matrix, the data is fitted by the G-DINA model again, followed
by an item level model selection via the Wald test using \code{\link{modelcomp}}. Lastly,
the selected models are calibrated based on the suggested Q-matrix using the \code{\link{GDINA}} function.
The Q-matrix validation and item-level model selection can be disabled by the users.
Possible reduced CDMs for Wald test include the DINA model, the DINO model, A-CDM, LLM and RRUM.
See \code{Details} for the rules of item-level model selection.
}
\details{
After the Wald statistics for each reduced CDM were calculated for each item, the
reduced models with p values less than the pre-specified alpha level were rejected.
If all reduced models were rejected for an item, the G-DINA model was used as the best model;
if at least one reduced model was retained, three diferent rules can be implemented for selecting
the best model:

When \code{modelselectionrule} is \code{simpler}:

 If (a) the DINA or DINO model
 was one of the retained models, then the DINA or DINO model with the larger p
 value was selected as the best model; but if (b) both DINA and DINO were rejected, the reduced
 model with the largest p value was selected as the best model for this item. Note that
 when the p-values of several reduced models were greater than 0.05, the DINA and DINO models were
 preferred over the A-CDM, LLM, and R-RUM because of their simplicity. This procedure is originally
 proposed by Ma, Iaconangelo, and de la Torre (2016).

 When \code{modelselectionrule} is \code{largestp}:

 The reduced model with the largest p-values is selected as the most appropriate model.

  When \code{modelselectionrule} is \code{DS}:

 The reduced model with non-significant p-values but the smallest dissimilarity index is selected as the most appropriate model.
 Dissimilarity index can be viewed as an effect size measure, which quatifies how dis-similar the reduced model is from the
 G-DINA model (See Ma, Iaconangelo, and de la Torre, 2016 for details).
}
\section{Methods (by generic)}{
\itemize{
\item \code{summary(autoGDINA)}: print summary information

}}
\note{
Returned \code{GDINA1.obj}, \code{GDINA2.obj} and \code{CDM.obj} are objects of class \code{GDINA},
 and all S3 methods suitable for \code{GDINA} objects can be applied. See \code{\link{GDINA}} and \code{\link{extract}}.
 Similarly, returned \code{Qval.obj} and \code{Wald.obj} are objects of class \code{\link{Qval}} and \code{\link{modelcomp}}.
}
\examples{
\dontrun{
# simulated responses
Q <- sim10GDINA$simQ
dat <- sim10GDINA$simdat

#misspecified Q
misQ <- Q
misQ[10,] <- c(0,1,0)
out1 <- autoGDINA(dat,misQ,modelselectionrule="largestp")
out1
summary(out1)
AIC(out1$CDM.obj)

# simulated responses
Q <- sim30GDINA$simQ
dat <- sim30GDINA$simdat

#misspecified Q
misQ <- Q
misQ[1,] <- c(1,1,0,1,0)
auto <- autoGDINA(dat,misQ,Qvalid = TRUE, Qvalid.args = list(method = "wald"),
                  modelselectionrule="simpler")
auto
summary(auto)
AIC(auto$CDM.obj)

#using the other selection rule
out11 <- autoGDINA(dat,misQ,modelselectionrule="simpler",
                   modelselection.args = list(models = c("DINO","DINA")))
out11
summary(out11)

# disable model selection function
out12 <- autoGDINA(dat,misQ,modelselection=FALSE)
out12
summary(out12)


# Disable Q-matrix validation
out3 <- autoGDINA(dat = dat, Q = misQ, Qvalid = FALSE)
out3
summary(out3)
}
}
\references{
Ma, W., & de la Torre, J. (2020). GDINA: An R Package for Cognitive Diagnosis Modeling. \emph{Journal of Statistical Software, 93(14)}, 1-26.

Ma, W., Iaconangelo, C., & de la Torre, J. (2016). Model similarity, model selection and attribute classification.
\emph{Applied Psychological Measurement, 40}, 200-217.
}
\seealso{
\code{\link{GDINA}}, \code{\link{modelcomp}}, \code{\link{Qval}}
}
\author{
Wenchao Ma, The University of Minnesota, \email{wma@umn.edu}
}
