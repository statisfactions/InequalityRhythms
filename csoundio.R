csndWriteSco<-function(df, outfile=NULL) {
  ## Takes input dataframe, writes
  ## Csound score file
  if(is.null(outfile)){
    outfile <- paste(tempfile("Rcs"),"sco",sep=".")
  }
  score <- c(paste("i",do.call(paste, df)),"e")
  write(score, outfile)
  outfile
}

csndPlayDF <- function(df, orc, output="dac") {
  ## Takes data.frame and uses it, in order, as
  ## p-fields in csound, which it then invokes to play
  sco <- csndWriteSco(df)
  system(paste("csound",orc, sco,"-o",output))
}

csndtemplate <- function(rows=0, orc) {
  ## Creates blank dataframe for inequality sonification
  ## Structure is (clumsily) determined from csound comments
  ## above header of csound "orc" file.

  fields <- unlist(strsplit(readLines(orc)[2], ", "))
  newdf <- data.frame(matrix(nrow=rows,ncol=length(fields)))
  names(newdf) <- fields
  newdf
}
