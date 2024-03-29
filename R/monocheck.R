#' This function checks if monotonicity is violated
#'
#' If mastering an additional attribute lead to a lower probabilities of success,
#' the monotonicity is violated.
#'
#' @param object object of class \code{\link{GDINA}}
#' @param strict whether a strict monotonicity is checked?
#'
#' @return a logical vector for each item or category indicating whether
#' the monotonicity is violated (\code{TRUE}) or not (\code{FALSE})
#'
#' @export
#'
#' @examples
#'\dontrun{
#' dat <- sim10GDINA$simdat
#' Q <- sim10GDINA$simQ
#'
#'
#' mod1 <- GDINA(dat = dat, Q = Q, model = "GDINA")
#' check <- monocheck(mod1)
#' check
#' mod2 <- GDINA(dat = dat, Q = Q, model = "GDINA",mono.constraint = check)
#' check2 <- monocheck(mod2)
#' check2
#'}


monocheck <- function(object,strict = FALSE){
  stopifnot(isa(object,"GDINA"))
  ip <- coef(object)
  Q <- extract(object,"Q")
  Kj <- rowSums(Q>0)
  item.names <- extract(object,"item.names")
  mono <- logical(length(ip))
  for(j in 1:length(ip)){
    po <- partial_order2(Kj[j],extract(object,"reduced.LG")[[j]])
    if(strict){
      if(any(ip[[j]][po[,1]]-ip[[j]][po[,2]]<=0)) mono[j] <- TRUE
    }else{
    if(any(ip[[j]][po[,1]]-ip[[j]][po[,2]]<0)) mono[j] <- TRUE
    }
  }
  names(mono) <- item.names
  return(mono)
}
