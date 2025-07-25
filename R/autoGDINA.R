#' @include GDINA.R
#' @title Q-matrix validation, model selection and calibration in one run
#'
#' @description \code{autoGDINA} conducts a series of CDM analyses within the G-DINA framework. Particularly,
#' the GDINA model is fitted to the data first using the \code{\link{GDINA}} function;
#' then, the Q-matrix is validated using the function \code{\link{Qval}}.
#' Based on the suggested Q-matrix, the data is fitted by the G-DINA model again, followed
#' by an item level model selection via the Wald test using \code{\link{modelcomp}}. Lastly,
#' the selected models are calibrated based on the suggested Q-matrix using the \code{\link{GDINA}} function.
#' The Q-matrix validation and item-level model selection can be disabled by the users.
#' Possible reduced CDMs for Wald test include the DINA model, the DINO model, A-CDM, LLM and RRUM.
#' See \code{Details} for the rules of item-level model selection.
#'
#'
#' @details
#'
#' After the Wald statistics for each reduced CDM were calculated for each item, the
#' reduced models with p values less than the pre-specified alpha level were rejected.
#' If all reduced models were rejected for an item, the G-DINA model was used as the best model;
#' if at least one reduced model was retained, three diferent rules can be implemented for selecting
#' the best model:
#'
#' When \code{modelselectionrule} is \code{simpler}:
#'
#'  If (a) the DINA or DINO model
#'  was one of the retained models, then the DINA or DINO model with the larger p
#'  value was selected as the best model; but if (b) both DINA and DINO were rejected, the reduced
#'  model with the largest p value was selected as the best model for this item. Note that
#'  when the p-values of several reduced models were greater than 0.05, the DINA and DINO models were
#'  preferred over the A-CDM, LLM, and R-RUM because of their simplicity. This procedure is originally
#'  proposed by Ma, Iaconangelo, and de la Torre (2016).
#'
#'  When \code{modelselectionrule} is \code{largestp}:
#'
#'  The reduced model with the largest p-values is selected as the most appropriate model.
#'
#'   When \code{modelselectionrule} is \code{DS}:
#'
#'  The reduced model with non-significant p-values but the smallest dissimilarity index is selected as the most appropriate model.
#'  Dissimilarity index can be viewed as an effect size measure, which quatifies how dis-similar the reduced model is from the
#'  G-DINA model (See Ma, Iaconangelo, and de la Torre, 2016 for details).
#'
#' @note Returned \code{GDINA1.obj}, \code{GDINA2.obj} and \code{CDM.obj} are objects of class \code{GDINA},
#'  and all S3 methods suitable for \code{GDINA} objects can be applied. See \code{\link{GDINA}} and \code{\link{extract}}.
#'  Similarly, returned \code{Qval.obj} and \code{Wald.obj} are objects of class \code{\link{Qval}} and \code{\link{modelcomp}}.
#'
#' @param Qvalid logical; validate Q-matrix or not? \code{TRUE} is the default.
#' @param alpha.level nominal level for the Wald test. The default is 0.05.
#' @param modelselection logical; conducting model selection or not?
#' @param modelselectionrule how to conducted model selection? Possible options include
#'    \code{simpler}, \code{largestp} and \code{DS}. See \code{Details}.
#' @param modelselection.args arguments passed to \code{modelcomp}
#' @param Qvalid.args arguments passed to \code{Qval}
#' @param GDINA1.args arguments passed to GDINA function for initial G-DINA calibration
#' @param GDINA2.args arguments passed to GDINA function for the second G-DINA calibration
#' @param CDM.args arguments passed to GDINA function for final calibration
#' @inheritParams GDINA
#' @seealso \code{\link{GDINA}}, \code{\link{modelcomp}}, \code{\link{Qval}}
#'
#' @return a list consisting of the following elements:
#' \describe{
#' \item{GDINA1.obj}{initial GDINA calibration of class \code{GDINA}}
#' \item{GDINA2.obj}{second GDINA calibration of class \code{GDINA}}
#' \item{Qval.obj}{Q validation object of class \code{Qval}}
#' \item{Wald.obj}{model comparison object of class \code{modelcomp}}
#' \item{CDM.obj}{Final CDM calibration of class \code{GDINA}}
#' }
#'
#' @author Wenchao Ma, The University of Minnesota, \email{wma@umn.edu}
#'
#' @references
#'
#' Ma, W., & de la Torre, J. (2020). GDINA: An R Package for Cognitive Diagnosis Modeling. \emph{Journal of Statistical Software, 93(14)}, 1-26.
#'
#' Ma, W., Iaconangelo, C., & de la Torre, J. (2016). Model similarity, model selection and attribute classification.
#' \emph{Applied Psychological Measurement, 40}, 200-217.
#'
#'@examples
#'\dontrun{
#' # simulated responses
#' Q <- sim10GDINA$simQ
#' dat <- sim10GDINA$simdat
#'
#' #misspecified Q
#' misQ <- Q
#' misQ[10,] <- c(0,1,0)
#' out1 <- autoGDINA(dat,misQ,modelselectionrule="largestp")
#' out1
#' summary(out1)
#' AIC(out1$CDM.obj)
#'
#' # simulated responses
#' Q <- sim30GDINA$simQ
#' dat <- sim30GDINA$simdat
#'
#' #misspecified Q
#' misQ <- Q
#' misQ[1,] <- c(1,1,0,1,0)
#' auto <- autoGDINA(dat,misQ,Qvalid = TRUE, Qvalid.args = list(method = "wald"),
#'                   modelselectionrule="simpler")
#' auto
#' summary(auto)
#' AIC(auto$CDM.obj)
#'
#' #using the other selection rule
#' out11 <- autoGDINA(dat,misQ,modelselectionrule="simpler",
#'                    modelselection.args = list(models = c("DINO","DINA")))
#' out11
#' summary(out11)
#'
#' # disable model selection function
#' out12 <- autoGDINA(dat,misQ,modelselection=FALSE)
#' out12
#' summary(out12)
#'
#'
#' # Disable Q-matrix validation
#' out3 <- autoGDINA(dat = dat, Q = misQ, Qvalid = FALSE)
#' out3
#' summary(out3)
#'}
#' @export

autoGDINA <-
  function(dat, Q, modelselection = TRUE,
           modelselectionrule = "simpler", alpha.level = 0.05,
           modelselection.args = list(),
           Qvalid = TRUE, Qvalid.args = list(),
           GDINA1.args = list(),
           GDINA2.args = list(), CDM.args = list()) {
    ASEcall <- match.call()

    GDINA1.opt <- c(list(dat = dat, Q = Q, verbose = 0), GDINA1.args)




    cat("Initial calibration...")
    GDINA1.obj <- do.call(GDINA,GDINA1.opt)


    Q <- extract(GDINA1.obj,what = "Q")
    cat("done.\n")
    Qv <- NULL
    if (Qvalid)  {
      cat("Q-matrix validation...")
      Qvalid.args <- c(list(GDINA.obj = GDINA1.obj),Qvalid.args)
      Qv <- do.call(Qval, Qvalid.args)
      mQ <- extract(Qv,what = "sug.Q")
      if (any(mQ != Q)) {
        GDINA2.opt <- c(list(dat = dat, Q = mQ, verbose = 0), GDINA2.args)
        GDINA2.obj <- do.call("GDINA",GDINA2.opt)
      }else{
        GDINA2.obj <- GDINA1.obj
      }
      cat("done.\n")
    } else{
      GDINA2.obj <- GDINA1.obj
    }
    Wp <- NULL
    Q <- extract(GDINA2.obj,what = "Q")
    if (modelselection) {
      cat("Model selection... ")
      modelselection.args <- c(list(GDINA.obj = GDINA2.obj),modelselection.args)
      Wp <- do.call(modelcomp,modelselection.args)
      ps <- extract(Wp,what = "pvalues")

      if (tolower(modelselectionrule) == "simpler") {

        if(any(toupper(Wp$models)%in%c("DINA","DINO"))){
          if(any(toupper(Wp$models)%in%c("LLM","RRUM","ACDM"))){
            #some DINO and DINA; some acdm
        model = apply(ps, 1, function(x) {
          if (max(x[1:2], na.rm = T) > alpha.level) {
            which.max(x[1:2])
          } else if (max(x[3:5], na.rm = T) > alpha.level) {
            which.max(x[3:5]) + 2
          } else{
            return(0)
          }
        })
          }else{
            #no acdm
            model <- apply(ps,1,which.max)
            model[apply(ps,1,max,na.rm=TRUE)<alpha.level] <- 0
          }
        }else{
          # no dina and dino
          model <- apply(ps,1,which.max)
          model[apply(ps,1,max,na.rm=TRUE)<alpha.level] <- 0
        }
      } else if(tolower(modelselectionrule) == "largestp"){
        model = apply(ps, 1, function(x) {
          if (max(x, na.rm = T) > alpha.level) {
            which.max(x)
          } else{
            return(0)
          }
        })
      }else if(tolower(modelselectionrule) == "ds"){
        model = apply(cbind(ps,extract.modelcomp(Wp,what = "DS")), 1, function(x) {
          if (max(x[1:5], na.rm = T) > alpha.level) {
            which.min.randomtie(x[5+which(x[1:5]>alpha.level)])
          } else{
            return(0)
          }
        })
        # print(model)
      }
      models  <-  rep(0, nrow(Q))
      models[which(rowSums(Q)!= 1)] <- model
      cat("done. \n")
    }else{models <- 0}
    CDM.opt <- c(list(dat = dat, Q = Q, verbose = 0, model = models), CDM.args)
    cat("Final calibration... ")
    CDM.obj <- do.call("GDINA",CDM.opt)

    cat("done.\n")
    out <-list( CDM.obj = CDM.obj,
        Qval.obj = Qv,
        Wald.obj = Wp,
        GDINA1.obj = GDINA1.obj,
        GDINA2.obj = GDINA2.obj,
        options = list(
          reducedCDM = Wp$models,
          alpha.level = alpha.level,
          Qvalid = Qvalid,eps=Qv$eps,
          modelselection = modelselection,
          modelselectionrule =modelselectionrule,
          GDINA1.option = GDINA1.args,
          GDINA2.option = GDINA2.args,
          CDM.option = CDM.args,
          ASEcall = ASEcall
        )
      )
    class(out) = "autoGDINA"
    return(out)
  }
