# making and editing SVG

library(svglite) # svglite makes tidier, simpler, easy-to-read SVG
library(readr)

# read in the trains data
trains<-read_csv('../data/traindelays.csv')
trains$calyear<-trains$finyear
trains$calyear[trains$fourweek>10]<-trains$finyear[trains$fourweek>10]+1
trains$calperiod<-trains$fourweek+3
trains$calperiod[trains$fourweek>10]<-trains$fourweek[trains$fourweek>10]-10
trains$caltime<-trains$calyear+((trains$calperiod-1)/13)

# make a train delays plot, first with grDevices::svg, then svglite::svglite
svg("trains.svg")
plot(trains$caltime, trains$london_se,
     ylim=c(0,18), yaxs="i")
dev.off()
svglite("trains_lite.svg")
  plot(trains$caltime, trains$london_se,
       ylim=c(0,18), yaxs="i")
dev.off()