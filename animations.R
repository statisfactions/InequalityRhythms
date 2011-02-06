require(animation)

ineq2000 <- read.csv("data/ineqGDPCap2000.csv")
ineq2000 <- ineq2000[order(ineq2000$Gini),]

oopt <- ani.options(nmax = 60, outdir=getwd(), interval=(5/4), loop=TRUE)


dev.new()
par(bg = "white")
ani.record(reset=TRUE)
clrs <- rep("deepskyblue", nrow(ineq2000))
for(i in 1:nrow(ineq2000)) {
  clrs[i] <- "black"
  lb <- max(i-10, 1)
  ub <- min(i+10, nrow(ineq2000))
  dotchart(ineq2000$GDPCap[lb:ub], labels = ineq2000$Country[lb:ub],
           color =  clrs[lb:ub], lcolor = clrs[lb:ub],
           xlim = c(0, 55000), xlab = "GDP per Capita",
           main=paste("Now playing: ",ineq2000$Country[i],
             "\n\nGini coefficient = ", round(ineq2000$Gini[i]/100,2), sep=""))
  clrs[i] <- "deepskyblue"
  ani.record()
}
dev.off()


saveMovie(ani.replay(), movie.name="counttest.mpg", convert="convert")
