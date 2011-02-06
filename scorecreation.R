source("csoundio.R")
require(plyr)

## Code to turn decile info (see data.R) into Csound score parameters

scoreify <- function(df, nbeats=10) {
  ## nbeats = the number of "beats" that represents 100%
  ## This function takes input dataframe of population
  ## and income percentages.
  ## Population is here assumed to be at equal intervals--
  ## something to fix in the future.
  ## The output is a section of a csound Score ready for
  ## csndWritSco(), where the times of the beats represent
  ## the cumulative percentage of income by that percentage
  ## of the population.
  
  popbeats <- 0:(nbeats-1)
  intvls <- findInterval(popbeats, c(df$cumincp*nbeats,nbeats), all.inside=TRUE)
  incbeats <- as.vector(with(df, (popbeats-cumincp[intvls]*nbeats)/(incp[intvls]/popp[intvls])
                             + cumpopp[intvls]*nbeats), "numeric")
  scoreOut <- csndtemplate(nbeats*2, "drumpatterns.orc")
  scoreOut$inst <- 1
  scoreOut$start <- (5/3)*(df$order-1)+ c(incbeats, 0:(nbeats-1))/6
  scoreOut$dur <- rep(c(1/15,1/30), each=nbeats)
  scoreOut$amp <- rep(c(0.5,0.08), each=nbeats)
  scoreOut$pan <- rep(c(0.5,0.5), each=nbeats)
  scoreOut$freq <- rep(c(2000,1000), each=nbeats)
  scoreOut$freq[nbeats+1] <- 500 #to mark beginning of country's data
  scoreOut
}

countrydec <- read.csv("data/countrydec.csv")
fullscore <- ddply(countrydec, "Country", scoreify)[-1]
csndPlayDF(fullscore, "drumpatterns.orc")

