#' @include GDINA.R
#' @title Model Comparison
#' @description To compare two or more \code{GDINA} objects, use method \code{\link{anova}}.
#' @export
#' @aliases anova.GDINA
#' @note anova function does NOT check whether models compared are nested or not.
#' @describeIn GDINA Model comparison using likelihood ratio test
anova.GDINA <- function(object, ...)
{
  obj <- match.call()
  # print(paste(obj)[-1])
  objects <- list(object, ...)

  if (length(objects) == 1)
    stop("At least two models need to be provided for comparison.", call. = FALSE)
  if (any(sapply(objects, class) != "GDINA"))
    stop("Inputs must be objects from class GDINA.", call. = FALSE)
  aic <- sapply(objects, AIC)
  caic <- sapply(objects, extract, what="CAIC")
  aicc <- sapply(objects, extract, what="AICc")
  sabic <- sapply(objects, extract, what="SABIC")
  bic <- sapply(objects, BIC)
  logL <- sapply(objects, logLik)
  dev <- sapply(objects, deviance)
  np <- unlist(sapply(objects, npar)[1, ])
  delchi <- NULL
  delta.chi <- dev - dev[which.max(np)]
  delta.df <- max(np) - np
  pval <- pchisq(delta.chi, delta.df, lower.tail = FALSE)
  LR <- round(data.frame(
    chisq = delta.chi,
    df = delta.df,
    pvalue = pval
  ), 2)
  IC <- data.frame(
    npar = np,
    logLik = formatC(logL, digits = 2, format = "f"),
    deviance = formatC(dev, digits = 2, format = "f"),
    AIC = formatC(aic, digits = 2, format = "f"),
    AICc = formatC(aicc, digits = 2, format = "f"),
    BIC = formatC(bic, digits = 2, format = "f"),
    CAIC = formatC(caic, digits = 2, format = "f"),
    SABIC = formatC(sabic, digits = 2, format = "f")
  )
  rownames(IC) <- rownames(LR) <- paste(obj)[-1]
  output <- list(IC = IC, LR = LR)
  class(output) <- "anova.GDINA"
  output
}
