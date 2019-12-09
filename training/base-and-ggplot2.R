# open the train delay data and generate the new variables
trains<-read.csv('traindelays.csv',stringsAsFactors=FALSE)
# define calendar year starting mid Jan
trains$calyear<-trains$finyear
trains$calyear[trains$fourweek>10]<-trains$finyear[trains$fourweek>10]+1
trains$calperiod<-trains$fourweek+3
trains$calperiod[trains$fourweek>10]<-trains$fourweek[trains$fourweek>10]-10
trains$caltime<-trains$calyear+((trains$calperiod-1)/13)

# bivariate plots
plot(trains$caltime, trains$london_se, col="#00000055", 
     ylim=c(0, 18), yaxs="i")
library(ggplot2)
ggplot(data=trains, 
       aes(x=caltime, y=london_se)) +
    geom_point(color="#00000055")


# univariate plots
hist(trains$london_se)
  # then try ading these options one by one:
  # breaks=20, xlim=c(0,16), xaxs="i", yaxs="i"
ggplot(trains, aes(london_se)) + geom_histogram()
  # try out some themes from page 2 of the ggplot2 cheat sheet
  # try controlling the axes with:
  # + coord_cartesian(xlim=c(0,16), ylim=c(0,70))




