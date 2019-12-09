source('simpleboot.R')
library(mvtnorm)

# make data
set.seed(15)
data<-as.data.frame(rmvnorm(n=100,sigma=matrix(c(1,0.4,0.4,1),nrow=2)))
y<-data[,2]
x<-data[,1]

# statistical theory (asymptotic) inference for the mean of x
mean(x)
sd(x)
mean(x)-(1.96*sd(x)/sqrt(100))
mean(x)+(1.96*sd(x)/sqrt(100))

# bootstrap inference for the mean of x
simpleboot(x, stat='mean')

# likewise for the 75th centile:
simpleboot(x, stat='p75')

# let's try this manually for lm(), so you can see what's going on:
summary(lm(y~x))
# we're interested in the slope (coefficient of x)
slope <- summary(lm(y~x))$coefficients[2,1] # store the slope

newdata <- data[sample(1:100,replace=TRUE),]
  # notice that we must not sample x and y separately!
newy<-newdata[,2]
newx<-newdata[,1]
summary(lm(newy~newx))
# repeat 1000 times!
bootstrap_slopes <- bootstrap_intercepts <- rep(NA,1000)
for(i in 1:1000) {
  newdata <- data[sample(1:100,replace=TRUE),]
  newy<-newdata[,2]
  newx<-newdata[,1]
  bootstrap_slopes[i] <- summary(lm(newy~newx))$coefficients[2,1]
  bootstrap_intercepts[i] <- summary(lm(newy~newx))$coefficients[1,1]
}
# we can make inferences from all the bootstrap slopes
# (Empirical Distribution Function)
hist(bootstrap_slopes, breaks=30)
abline(v=slope, col="#b62525", lty=3)
# this is the 95% percentile bootstrap CI:
quantile(bootstrap_slopes, prob=c(0.025, 0.975))
# and they are handy for visualising:
plot(x,y)
for(i in 1:1000) {
  lines(abline(a=bootstrap_intercepts[i],
               b=bootstrap_slopes[i],
               col="#b6252505"))
}
# notice that we have to set the opacity very low
