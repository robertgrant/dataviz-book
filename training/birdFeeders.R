# experiments in smoothers with bird feeder data

# set year and smoothing parameters
year <- 2016
spline_smoothing_parameter <- 0.4
running_medians_bandwidth <- 5 # this should be odd
loess_smoothing_parameter <- 0.7

# read in the data
bf <- read.csv(paste0('birdFeederRates',year,'.csv'),
             stringsAsFactors=FALSE)
dates <- as.Date(bf$dates,'%Y-%m-%d') # convert to R dates
num_dates <- as.numeric(dates)
rates <- bf$rate
n <- length(dates)

# splines
splinebf <- smooth.spline(x=as.numeric(dates),
                          y=rates,
                          all.knots=TRUE,
                          spar=spline_smoothing_parameter)
splinedays <- ((as.numeric(dates[1])):(as.numeric(dates[n])))
splinedates <- as.Date(splinedays,origin="1970-01-01")
smooth_spline <- predict(splinebf,x=splinedays)
splinevalues <- smooth_spline[['y']]

# running medians
runmedvalues <- median(rates[1:running_medians_bandwidth])
runmeddates <- dates[ceiling(running_medians_bandwidth * 0.5)]
for(i in ((ceiling(running_medians_bandwidth * 0.5)+1) : 
          (n - floor(running_medians_bandwidth * 0.5)))) {
  runmedvalues <- c(runmedvalues, 
                     median(rates[(i - floor(running_medians_bandwidth * 0.5)) :
                                    (i + floor(running_medians_bandwidth * 0.5))]))
  runmeddates <- c(runmeddates, dates[i])
}


# loess
loessbf <- loess(rates ~ num_dates,
                 span=loess_smoothing_parameter,
                 degree=2)
loessdays <- ((as.numeric(dates[1])):(as.numeric(dates[n])))
loessdates <- as.Date(loessdays,origin="1970-01-01")
loessvalues <- predict(loessbf, newdata=loessdays)




# plots
 # which smoother do you want?
smoother_name<- "spline" # spline, runmed or loess
 # even better, we could wrap this choice, the year and the parameters, 
 # up in one function
mysmoother_dates <- get(paste0(smoother_name,"dates"))
mysmoother_values <- get(paste0(smoother_name,"values"))



 #png(paste0("birdfeeders",year,".png") # if you want to export to a PNG file
 # first, plot the raw data (rates)
plot(dates,
     rates,type="S",
     ylim=c(0,12), yaxs='i', col="#317d7daa",
     xlab="Date",ylab="Inches of birdseed per day", 
     main=paste(as.character(year), " -- ", smoother_name))
 # try type="s" as well... 

 # second, plot the smoother
lines(x=mysmoother_dates,
      y=mysmoother_values,
      col="#46b4b4aa", lwd=2)
 #dev.off() # if you want to export to a PNG file



