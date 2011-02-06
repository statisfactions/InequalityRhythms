require(plyr)
require(WDI)

##################################################
## INEQUALITY DATA: From WIID DB
##################################################


## Data downloaded from:
## http://www.wider.unu.edu/research/Database/en_GB/wiid/_files/79789834673192984/default/WIID2C.xls
## Imported into Gnumeric, then saved as CSV
ineqdist <- read.csv("data/WIID2C.csv", check.names=TRUE)
ineqdist <- ineqdist[,c("Country", "Year", "Gini", paste("D", 1:10,sep=""),"Quality")]
ineqdist <- na.omit(ineqdist)

inequniq <- ddply(ineqdist, c("Country", "Year"),
                  function(df) df[which.max(df$Quality),])
ineq2000 <- droplevels(inequniq[inequniq$Year==2000,])


##################################################
## GDP PER CAPITA, PPP, current international $
## retrieved via WDI package's interface to World
## Bank Data.
##################################################

GDPCap2000 <- WDI(country="all", indicator="NY.GDP.PCAP.PP.CD", start=2000, end=2000)
str(GDPCap2000)

## Reconcile non-matching countries
ineq2000 <- droplevels(ineq2000[ineq2000$Country!="Taiwan",]) # No Taiwan in WDI 2000
levels(ineq2000$Country)[levels(ineq2000$Country) %in%
                           c("Serbia and Montenegro",
                             "Venezuela")] <- c("Serbia", "Venezuela, RB")
ineq2000$GDPCap <- GDPCap2000$NY.GDP.PCAP.PP.CD[match(ineq2000$Country, GDPCap2000$country)]

ineq2000$order <- 1:nrow(ineq2000)

## Write to CSV:
##write.csv(ineq2000, "data/ineqGDPCap2000.csv")

##################################################
## Reshape data to get deciles vertical for each country
## and calculate summary measures
##################################################

countrydec <- melt(ineq2000, id = c("Country", "order"))
decnames <- paste("D", 1:10, sep="")
countrydec <- countrydec[countrydec$variable %in% decnames,]
countrydec <- countrydec[order(countrydec$order),]
countrydec$uniq <- 1:nrow(countrydec)
countrydec$variable <- NULL
countrydec$value <- NULL
rm(decnames)

## Calculate relevant fields:
## popp: % population (always .10 in this example, since deciles)
## incp: % of overall income
## cumpopp: cumulative % of population (from lowest- to highest- income)
## cumincp: cumulative % of income (")

countrydec$popp <- 0.1
countrydec$incp <- countrydec$value/100


totals <- ddply(countrydec, c("Country"), function(df) {
  as.data.frame(cbind(df$uniq, c(0, cumsum(df$popp)[-nrow(df)]),
        c(0, cumsum(df$incp)[-nrow(df)])))})
countrydec[,c("cumpopp", "cumincp")] <- totals[match(countrydec$uniq, totals$V1), 3:4]
rm(totals)

## Write to CSV:
##write.csv(ineq2000, "data/countrydec.csv")
