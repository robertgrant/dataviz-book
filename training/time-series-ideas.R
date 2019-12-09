# open the train delay data and generate the new variables
delays <- trains$london_se
time <- trains$caltime

plot(time, delays, col="#00000055", 
     ylim=c(0, 18), yaxs="i")
legend(x="topright",
       legend=c("basic", "lag", "MA", "seasonal"),
       lwd=c(1.5, 1.5, 1.5, 1.5),
       col=c("#b62525", "#26469c", "#579a04", "#b44ccd"))

basic_lm <- lm(delays ~ time)
lines(time, basic_lm$fitted.values, col="#b62525", lwd=1.5)

# lagged delays
n <- length(delays)
lagdelays0 <- delays[4:n]
lagtime0 <- time[4:n]
lagdelays1 <- delays[3:(n-1)]
lagtime1 <- time[3:(n-1)]
lagdelays2 <- delays[2:(n-2)]
lagtime2 <- time[2:(n-2)]
lagdelays3 <- delays[1:(n-3)]
lagtime3 <- time[1:(n-3)]

lag_lm <- lm(lagdelays0 ~ lagtime0 + lagdelays1 + lagdelays2 + lagdelays3)
lines(lagtime0, lag_lm$fitted.values, col="#26469c", lwd=1.5)


# moving average (mean, but try median instead...)
bandwidth <- 13
ma <- mean(delays[1:bandwidth])
for(i in 2:(n-bandwidth)) {
  ma <- c(ma, mean(delays[i:(i+bandwidth)]))
}
ma_lm <- lm(delays[(bandwidth+1):n] ~ time[(bandwidth+1):n] + ma)
lines(time[(bandwidth+1):n], ma_lm$fitted.values, 
      col="#579a04", lwd=1.5)


# seasonal (you could put this in a loop or use model.matrix)
period1 <- as.numeric(trains$calperiod==1)
period2 <- as.numeric(trains$calperiod==2)
period3 <- as.numeric(trains$calperiod==3)
period4 <- as.numeric(trains$calperiod==4)
period5 <- as.numeric(trains$calperiod==5)
period6 <- as.numeric(trains$calperiod==6)
period7 <- as.numeric(trains$calperiod==7)
period8 <- as.numeric(trains$calperiod==8)
period9 <- as.numeric(trains$calperiod==9)
period10 <- as.numeric(trains$calperiod==10)
period11 <- as.numeric(trains$calperiod==11)
period12 <- as.numeric(trains$calperiod==12)
season_lm <- lm(delays ~ time + period1 +
                  period2 + period3 + period4 + 
                  period5 + period6 + period7 + 
                  period8 + period9 + period10 + 
                  period11 + period12)
lines(time, season_lm$fitted.values, col="#b44ccd", lwd=1.5)

# Try combining these, like MA and seasonality -- be careful 
# to select the right parts of the time series.
# Imagine explaining the combined time series model to a colleague.