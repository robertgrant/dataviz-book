############################################################################
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>
############################################################################


# Figure 7.2

set.seed(434)
x<-runif(30,min=0,max=10)
y<-6+(((x-10)^2)/9)+rnorm(30,mean=0,sd=4)
svglite::svglite('7-preattentive1.svg')
plot(x,y,xaxs='i',yaxs='i',bty='n',pch=c(19,rep(1,29)),cex=1.8,xlab='',ylab='',
     xlim=c(0,12),ylim=c(0,25))
dev.off()

set.seed(18123)
x<-runif(30,min=1,max=9)
y<-6+(0.6*x)+rnorm(30,mean=0,sd=4)
svglite::svglite('7-preattentive2.svg')
plot(x,y,xaxs='i',yaxs='i',bty='n',pch=19,
     cex=c(5,rep(1.8,29)),col='#00000099',
     xlab='',ylab='',
     xlim=c(0,12),ylim=c(0,25))
dev.off()

set.seed(75647)
x<-sort(runif(14,min=1,max=9))
y<-6+(0.6*x)+rnorm(14,mean=0,sd=0.5)
svglite::svglite('7-preattentive3.svg')
plot(1:14,y,type='l',xaxt='n',yaxt='n',bty='n',
     bg='black',col='#64ec23',
     xlab='',ylab='',
     xlim=c(0,16),ylim=c(5,12))
lines(8:11,y[8:11])
dev.off()







# Figure 7.4

library(dplyr)
library(forcats)
library(svglite)

trains<-read.csv('traindelays.csv',stringsAsFactors=FALSE)
ffour<-as.factor(as.character(trains$fourweek))
ffour<-fct_relabel(ffour,fun=function(x) {
  c("6 Apr to 3 May",
    "4 May to 31 May",
    "1 Jun to 28 Jun",
    "29 Jun to 26 Jul",
    "27 Jul to 23 Aug",
    "24 Aug to 20 Sep",
    "21 Sep to 18 Oct",
    "19 Oct to 15 Nov",
    "16 Nov to 13 Dec",
    "14 Dec to 10 Jan",
    "11 Jan to 7 Feb",
    "8 Feb to 7 Mar",
    "8 Mar to 5 April")[as.integer(x)] })
# define calendar year starting mid Jan
trains$calyear<-trains$finyear
trains$calyear[trains$fourweek>10]<-trains$finyear[trains$fourweek>10]+1
trains$calperiod<-trains$fourweek+3
trains$calperiod[trains$fourweek>10]<-trains$fourweek[trains$fourweek>10]-10
trains$caltime<-trains$calyear+((trains$calperiod-1)/13)

plot(trains$caltime,trains$london_se)
lines(trains$caltime[as.numeric(ffour)==12],
      trains$london_se[as.numeric(ffour)==12])

tukey<-function(tukeyline=1) {
  tukeyhi<-trains$london_se+tukeyline
  tukeylo<-trains$london_se-tukeyline
  plot(trains$caltime,trains$london_se,pch=NA,
       ylim=c(0,15),ylab="Delays & cancellations (%)",xlab="4-week periods",
       xaxt='n',yaxt='n',yaxs='i',bty='n',
       sub='Data from dataportal.orr.gov.uk')
  axis(side=1,at=c(1997,2001,2005,2009,2013,2017))
  axis(side=1,at=1997:2017,tcl=(-0.25),labels=FALSE)
  axis(side=2,at=2*(0:7))
  for(i in 1:length(tukeyhi)) {
    lines(x=rep(trains$caltime[i],2),
          y=c(tukeylo[i],tukeyhi[i]))
  }
}
svglite::svglite('7-tukey.svg');tukey();dev.off();
png('7-tukey.png');tukey();dev.off();
