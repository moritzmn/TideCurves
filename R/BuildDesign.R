#' Builds the xdesign matrix
#' @description Builds the xdesing.matrix by calling Funcs
#'
#' @param tdiffa The difference in days as double which stems from the analysis period.
#' @param nummsa The transit number (start of synthesis).
#' @param nummse The transit number (end of synthesis).
#'
#' @return Returns a matrix
#'
#' @examples
BuildDesign <- function(tdiffa, nummsa, nummse) {
  matrix.cols      <- length(Funcs(tdiff = tdiffa, xi = 1)[[3]])

  xdesign.matrix      <- matrix(0.0, nrow = (nummsa - nummse + 1), ncol = matrix.cols + 1)
  xdesign.matrix[, 1] <- seq.int(nummsa, nummse, 1)

  for(i in 1 : nrow(xdesign.matrix)){
    xdesign.matrix[i, 2: (matrix.cols + 1)] <- Funcs(xi = xdesign.matrix[i, 1], tdiff = tdiffa)[[3]]
  }

  return(xdesign.matrix)
}