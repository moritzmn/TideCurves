#' Builds a TideCurve model
#'
#' @description Builds a TideCurve model of class "tidecurve"
#' @references \url{https://www.bsh.de/DE/PUBLIKATIONEN/_Anlagen/Downloads/Meer_und_Umwelt/Berichte-des-BSH/Berichte-des-BSH_50_de.pdf?__blob=publicationFile&v=13/}
#' @references \url {https://doi.org/10.5194/os-15-1363-2019}
#' @return
#' @export
#'
#' @examples
BuildTC <- function(dataInput = NULL, otz = 1, astime, asdate, aedate, aetime, km = -1, mindt = 30){

  #constants
  nspline <- 7
  chron.origin <- chron(dates. = "1900/01/01",
                        times. = "00:00:00",
                        format = c(dates = "y/m/d", times = "h:m:s"),
                        out.format = c(dates = "y/m/d", times = "h:m:s"))
  tperiode.m2  <- 360 / 28.9841042373
  tmean.moon   <- tperiode.m2 * 2
  tm24         <- tmean.moon / 24
  tmoon.0      <- as.numeric(chron(dates. = "1949/12/31",
                                   times. = "21:08:00",
                                   format = c(dates = "y/m/d", times = "h:m:s"),
                                   out.format = c(dates = "y/m/d", times = "h:m:s")) - chron.origin)

  if(km == -1){
    km <- round(1440 / mindt)
  }

  tmdm         <- 24.2325 / 1440
  tplus        <- tmoon.0 + tmdm
  tmmh         <- tm24 / km
  tdtobs       <- mindt / 1440
  tdtobsn      <- tdtobs * (nspline - 1)
  tdtobsn.105  <- tdtobsn + 10^-5
  tdtobs.105   <- tdtobs + 10^-5
  otz.24       <- otz / 24
  tmondkm      <- numeric(length = km)

  #Reading the data
  height          <- dataInput[["height"]]
  chron.beob      <- chron(dates. = dataInput[["observation_date"]],
                           times. = dataInput[["observation_time"]],
                           format = c(dates = "y/m/d", times = "h:m:s"),
                           out.format = c(dates = "y/m/d", times = "h:m:s"))

  #computing base values
  diff.days       <- as.numeric((chron.beob - chron.origin) - otz.24)
  length.diffdays <- length(diff.days)
  moona           <- as.numeric(floor((diff.days[1] - tplus) / tm24))
  moone           <- as.numeric(floor((diff.days[length.diffdays] - tplus) / tm24))
  tmmt.numm       <- numeric(length = length(moona:moone))

  for(i in moona : moone){
    tmmt.numm[i] <- i * tm24 + tplus
  }

  #Analysis date and times as chron
  asdate.time <- chron(dates. = asdate,
                       times. = astime,
                       format = c(dates = "y/m/d", times = "h:m:s"),
                       out.format = c(dates = "y/m/d", times = "h:m:s")) - chron.origin - (otz.24)

  aedate.time <- chron(dates. = aedate,
                       times. = aetime,
                       format = c(dates = "y/m/d", times = "h:m:s"),
                       out.format = c(dates = "y/m/d", times = "h:m:s")) - chron.origin - (otz.24)

  numma   <- as.numeric(floor((asdate.time - tplus) / tm24))
  numme   <- as.numeric(floor((aedate.time - tplus) / tm24))

  tdiff.analyse    <- numme - numma + 1

  nummsa  <- as.numeric(floor((ssdate.time - tplus) / tm24))
  nummse  <- as.numeric(floor((sedate.time - tplus) / tm24))

  #Computing Funcs for all cases
  min_numm <- min(c(numma, nummsa))
  max_numm <- max(c(numme, nummse))
  matrix.cols      <- length(Funcs(tdiff = tdiff.analyse, xi = max_numm)[[3]])

  xdesign.matrix      <- matrix(0.0, nrow = (max_numm - min_numm + 1), ncol = matrix.cols + 1)
  xdesign.matrix[, 1] <- seq.int(min_numm, max_numm, 1)

  for(i in 1 : nrow(xdesign.matrix)){
    xdesign.matrix[i, 2: (matrix.cols + 1)] <- Funcs(xi = xdesign.matrix[i, 1], tdiff = tdiff.analyse)[[3]]
  }

  xa                    <- numeric(length = 7)
  ya                    <- numeric(length = 7)
  ty                    <- numeric()
  data.matrix           <- matrix(0.0, nrow = length.diffdays, ncol = 4)
  colnames(data.matrix) <- c("numm", "imm", "tmmttmond", "height")
  numm                  <- NULL
  floored               <- floor((diff.days - tplus) / tm24)
  tdtobs.2              <- tdtobs / 2
  imm                   <- numeric()
  tmmttmond             <- numeric()
  tmd                   <- numeric()
  dx                    <- numeric()
  ld.3                  <- length.diffdays - 3

  for (ii in 4 : ld.3) {
    ik <- floored[ii]

    if((ik < numma) || (ik > numme)) next

    imm       <- floor((diff.days[ii] - tmmt.numm[ik]) / tmmh) + 1
    tmmttmond <- tmmt.numm[ik] + tmondkm [imm]
    tmd       <- diff.days[ii] - tmmttmond

    if (abs(tmd) > tdtobs.2) next

    insp <- 0
    for (j in (ii - 3) : (ii + 3)){
      insp     <- insp + 1
      xa[insp] <- diff.days[j]
      ya[insp] <- height[j]
    }
    dx       <- xa[insp] - xa[1]

    if(dx > tdtobsn.105) next

    ty                 <- splint(xa, ya, tmmttmond)

    data.matrix[ii, ]  <- c(ik, imm, tmmttmond, ty)
  }

  #Prepare joins on numm for xdesign and design.frame
  colnames(xdesign.matrix) <- c("numm", paste0("V","", seq(1 : matrix.cols)))
  xdesign.matrix           <- data.table(xdesign.matrix, key = "numm")
  data.matrix              <- data.table(data.matrix, key = "numm")

  design.frame     <- data.matrix[(numm >= numma) & (numm <= numme)]
  design.frame     <- xdesign.matrix[design.frame]
  setkey(design.frame, "imm")

  fitting.coef <- design.frame[,{
    m.h   <- mean(height)
    sd.h  <- 3 * sd(height)
    m_mat <- as.matrix(.SD[(height >= m.h - sd.h) & (height <= m.h + sd.h)])
    as.list(coef(lm.fit(x = m_mat[, !colnames(m_mat) %in% c("height", "numm", "imm", "tmmttmond")],
                        y = m_mat[, "height"])))
  }
  , by = "imm"]

  for(j in seq_len(ncol(fitting.coef))) set(fitting.coef,which(is.na(fitting.coef[[j]])),j,0)

  fitting.coef <- lapply(split(fitting.coef, by = "imm", keep.by = FALSE), as.matrix)



}