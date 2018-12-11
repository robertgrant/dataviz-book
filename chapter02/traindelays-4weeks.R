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

draw1<-function(line=FALSE,highlight_lo=0,highlight_hi=0,area=FALSE) {
  plot(trains$caltime,trains$london_se,type=ifelse(line,'l','p'),
       ylim=c(0,15),ylab="Delays & cancellations (%)",xlab="4-week periods",
       xaxt='n',yaxt='n',yaxs='i',
       sub='Data from dataportal.orr.gov.uk')
  if(highlight_lo!=0) {
    if(area) {
      for(i in 1997:2016) {
        polygon(x=rep(c(i+((highlight_lo-1.5)/13),
                        i+((highlight_hi-0.5)/13)),
                      each=2),
                y=c(-1,18,18,-1),
                col="#b1301144",border=NA)
      }
    }
    else {
      points(trains$caltime[between(trains$fourweek,highlight_lo,highlight_hi)],
            trains$london_se[between(trains$fourweek,highlight_lo,highlight_hi)],
            col='#b1301199',pch=19)
    }
  }
  axis(side=1,at=c(1997,2001,2005,2009,2013,2017))
  axis(side=1,at=1997:2017,tcl=(-0.25),labels=FALSE)
  axis(side=2,at=2*(0:7))
}
svglite('2-traindelays-scatter1.svg'); draw1(); dev.off()
png('2-traindelays-scatter1.png',width=700); draw1(); dev.off()
svglite('2-traindelays-line1.svg'); draw1(line=TRUE); dev.off()
png('2-traindelays-line1.png',width=700); draw1(line=TRUE); dev.off()
svglite('2-traindelays-line2a.svg'); draw1(line=TRUE,
                                           highlight_lo=10,
                                           highlight_hi=12,
                                           area=FALSE); dev.off()
png('2-traindelays-line2a.png',height=700); draw1(line=TRUE,
                                       highlight_lo=10,
                                       highlight_hi=12,
                                       area=FALSE); dev.off()
svglite('2-traindelays-line2b.svg'); draw1(line=TRUE,
                                           highlight_lo=10,
                                           highlight_hi=12,
                                           area=TRUE); dev.off()
png('2-traindelays-line2b.png',height=700); draw1(line=TRUE,
                                       highlight_lo=10,
                                       highlight_hi=12,
                                       area=TRUE); dev.off()



draw3<-function(line=FALSE) {
  plot(trains$calperiod[trains$calyear==1998],trains$london_se[trains$calyear==1998],
       type=ifelse(line,'l','p'),
       ylim=c(0,15),ylab="Delays & cancellations (%)",xlab="4-week periods",
       xaxt='n',yaxt='n',yaxs='i',
       sub='Data from dataportal.orr.gov.uk')
  axis(side=1,at=c(1,4,7,10,13))
  axis(side=1,at=1:13,tcl=(-0.25),labels=FALSE)
  axis(side=2,at=2*(0:7))
  for(i in c(1997,(1999:2017))) {
    if(line) {
      lines(trains$calperiod[trains$calyear==i],trains$london_se[trains$calyear==i],
            col='#00000088')
    }
    else {
      points(trains$calperiod[trains$calyear==i],trains$london_se[trains$calyear==i],
             col='#00000088')
    }
  }
}
svglite('2-traindelays-3a.svg'); draw3(); dev.off()
png('2-traindelays-3a.png'); draw3(); dev.off()
svglite('2-traindelays-3b.svg'); draw3(line=TRUE); dev.off()
png('2-traindelays-3b.png'); draw3(line=TRUE); dev.off()




myramp<-colorRampPalette(c('#07030088','#e6550d88'),alpha=TRUE)(20)
draw4<-function(line=FALSE,mycol=rep('#000000ff',13)) {
  plot(trains$calperiod[trains$calyear==1998],trains$london_se[trains$calyear==1998],
       type=ifelse(line,'l','p'),
       ylim=c(0,15),ylab="Delays & cancellations (%)",xlab="4-week periods",
       xaxt='n',yaxt='n',yaxs='i',
       sub='Data from dataportal.orr.gov.uk',
       col=mycol[2])
  axis(side=1,at=c(1,4,7,10,13))
  axis(side=1,at=1:13,tcl=(-0.25),labels=FALSE)
  axis(side=2,at=2*(0:7))
  for(i in c(1997,(1999:2017))) {
    if(line) {
      lines(trains$calperiod[trains$calyear==i],trains$london_se[trains$calyear==i],
            col=mycol[i-1996])
    }
    else {
      points(trains$calperiod[trains$calyear==i],trains$london_se[trains$calyear==i],
             col=mycol[i-1996])
    }
  }
}
svglite('2-traindelays-4a.svg'); draw4(mycol=myramp); dev.off()
png('2-traindelays-4a.png'); draw4(mycol=myramp); dev.off()
svglite('2-traindelays-4b.svg'); draw4(line=TRUE,mycol=myramp); dev.off()
png('2-traindelays-4b.png'); draw4(line=TRUE,mycol=myramp); dev.off()



delaymat<-matrix(c(rep(0,3),trains$london_se,rep(0,10)),
                 nrow=13)
rankmat<-apply(delaymat,2,rank,ties.method="first")
worstmat<-rankmat
worstmat[worstmat<11]<-1
worstmat[worstmat>10]<-worstmat[worstmat>10]-9
worstcol<-c('#ffffff','#f7e1de','#e4988f','#ad3829')
draw5<-function() {
  plot(-1,-1,
       ylim=c(0.5,13.5),xlim=c(1996.5,2017.5),
       ylab="4-week periods",xlab="Year",
       xaxt='n',yaxt='n',yaxs='i',xaxs='i')
  axis(side=1,at=c(2000,2005,2010,2015))
  axis(side=1,at=1997:2017,tcl=(-0.25),labels=FALSE)
  axis(side=2,at=1:13)
  for(i in 1:21) {
    for(j in 1:13) {
      polygon(x=c(i+1996-0.5,i+1996-0.5,i+1996+0.5,i+1996+0.5),
              y=c(j-0.5,j+0.5,j+0.5,j-0.5),
              col=worstcol[worstmat[j,i]],border=NA)
    }
  }
}
png('2-traindelays-calendar5.png'); draw5(); dev.off()
svglite('2-traindelays-calendar5.svg'); draw5(); dev.off()


plot(ffour,trains$london_se)

plot(trains %>% group_by(fourweek) %>% summarise(mean(london_se)),
     ylim=c(0,5),type='l',col='blue',xlab='4-week period')
lines(trains %>% group_by(fourweek) %>% summarise(median(london_se)),
      ylim=c(0,5),col='rosybrown')

plot(trains$fourweek[trains$finyear==1997],trains$london_se[trains$finyear==1997],
     type='l',ylim=c(0,15),xlim=c(1,13))
for(i in 1998:2016) {
  lines(trains$fourweek[trains$finyear==i],trains$london_se[trains$finyear==i])
}






# chapter 3

# violin plot
ffweek<-trains$fourweek
season<-rep(' ',length(ffweek))
season[ffweek>8 & ffweek<13]<-'Winter'
season[ffweek==13 | ffweek<3]<-'Spring'
season[ffweek>2 & ffweek<6]<-'Summer'
season[ffweek>5 & ffweek<9]<-'Autumn'
trains$season<-forcats::fct_relevel(as.factor(sesason),
                                    "Spring","Summer","Autumn","Winter")
svglite::svglite('3-violin.svg')
ggplot2::ggplot(trains,aes(season,london_se)) +
  geom_violin(scale="area",fill="#4682b4") +
  theme_bw() +
  expand_limits(y=0.62)
dev.off()

, x, y, alpha, color,
fill, group, linetype, size, weight






# chapter 5

png('5-trainsdelays-boxplot.png')
  boxplot(trains$london_se ~ trains$finyear,
          ylim=c(0,15), yaxs='i', ylab='Mean % delays and cancellations',
          cex.axis=3,cex.main=3,cex.lab=3)
dev.off()
svglite::svglite('5-trainsdelays-boxplot.svg')
  boxplot(trains$london_se ~ trains$finyear,
          ylim=c(0,15), yaxs='i', ylab='Mean % delays and cancellations',
          cex.axis=3,cex.main=3,cex.lab=3)
dev.off()

png('5-traindelays-meansplot.png')
  plot(trains %>% group_by(finyear) %>% summarise(mean(london_se)),
       ylim=c(0,8),yaxs='i',ylab='Mean % delays and cancellations',xlab='',
       cex.axis=3,cex.main=3,cex.lab=3)
dev.off()
svglite::svglite('5-traindelays-meansplot.svg')
  plot(trains %>% group_by(finyear) %>% summarise(mean(london_se)),
       ylim=c(0,8),yaxs='i',ylab='Mean % delays and cancellations',xlab='',
       cex.axis=3,cex.main=3,cex.lab=3)
dev.off()

trainsq<-trains %>% group_by(finyear) %>% summarise(quantile(london_se,probs=0.25),
                                                    quantile(london_se,probs=0.5),
                                                    quantile(london_se,probs=0.75))
png('5-traindelays-quartiles.png')
  plot(trainsq[,c(1,4)],type='l',ylim=c(0,8),col='#8d8d8d', yaxs='i',
       ylab='% delays and cancellations',xlab='',main='Quartiles for each year',
       cex.axis=3,cex.main=3,cex.lab=3)
  lines(trainsq[,c(1,3)],col='#000000')
  lines(trainsq[,c(1,2)],col='#8d8d8d')
dev.off()
svglite::svglite('5-traindelays-quartiles.svg')
  plot(trainsq[,c(1,4)],type='l',ylim=c(0,8),col='#8d8d8d', yaxs='i',
      ylab='% delays and cancellations',xlab='',main='Quartiles for each year',
      cex.axis=3,cex.main=3,cex.lab=3)
  lines(trainsq[,c(1,3)],col='#000000')
  lines(trainsq[,c(1,2)],col='#8d8d8d')
dev.off()

winsor80<-function(x) {
  lims<-quantile(x,probs=c(0.1,0.9))
  x<-x[dplyr::between(x,lims[1],lims[2])]
  return(mean(x))
}
trainsw<-trains %>% group_by(finyear) %>% summarise(winsor80(london_se),
                                                    mad(london_se))
trainsw<-cbind(trainsw,trainsw[,2]-trainsw[,3],trainsw[,2]+trainsw[,3])

png('5-traindelays-winsor-mad.png')
  plot(trainsw[,c(1,5)],type='l',ylim=c(0,8),col='#8d8d8d', yaxs='i',
       ylab='% delays and cancellations',xlab='',main='80% Winsorised mean +/- MAD',
       cex.axis=3,cex.main=3,cex.lab=3)
  lines(trainsw[,c(1,2)],col='#000000')
  lines(trainsw[,c(1,4)],col='#8d8d8d')
dev.off()
svglite::svglite('5-traindelays-winsor-mad.svg')
  plot(trainsw[,c(1,5)],type='l',ylim=c(0,8),col='#8d8d8d', yaxs='i',
       ylab='% delays and cancellations',xlab='',main='80% Winsorised mean +/- MAD',
       cex.axis=3,cex.main=3,cex.lab=3)
  lines(trainsw[,c(1,2)],col='#000000')
  lines(trainsw[,c(1,4)],col='#8d8d8d')
dev.off()

trainssm<-smooth.spline(trains$finyear,trains$london_se,spar=0.3)

png('5-traindelays-spline.png')
  plot(predict(trainssm,seq(from=1997,to=2016,by=0.1)),type='l',
       ylim=c(0,8),yaxs='i',ylab='% delays and cancellations',xlab='',
       main='Smoothed with splines',
       cex.axis=3,cex.main=3,cex.lab=3)
dev.off()
svglite::svglite('5-traindelays-spline.svg')
  plot(predict(trainssm,seq(from=1997,to=2016,by=0.1)),type='l',
       ylim=c(0,8),yaxs='i',ylab='% delays and cancellations',xlab='',
       main='Smoothed with splines',
       cex.axis=3,cex.main=3,cex.lab=3)
dev.off()

trainsls<-loess(trains$london_se ~ trains$finyear)

png('5-traindelays-loess.png')
  plot(trains$finyear,
      predict(trainsls,data.frame(finyear=seq(from=1997,to=2016,by=0.1))),type='l',
      ylim=c(0,8),yaxs='i',ylab='% delays and cancellations',xlab='',
      main='Smoothed with LOESS',
      cex.axis=3,cex.main=3,cex.lab=3)
dev.off()
svglite::svglite('5-traindelays-loess.svg')
  plot(trains$finyear,
       predict(trainsls,data.frame(finyear=seq(from=1997,to=2016,by=0.1))),type='l',
       ylim=c(0,8),yaxs='i',ylab='% delays and cancellations',xlab='',
       main='Smoothed with LOESS',
       cex.axis=3,cex.main=3,cex.lab=3)
dev.off()


# chapter 9

png('9-autocorr.png')
  plot(acf(trains$london_se,ci=(-1)),main='')
dev.off()
