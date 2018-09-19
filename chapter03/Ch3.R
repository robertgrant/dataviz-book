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


# Chapter 3

library(dplyr)
library(forcats)
library(svglite)
library(hexbin)
library(MASS)
# prevent dplyr-MASS conflict
select <- dplyr::select


# Atlanta Commutes
ac<-readr::read_csv('CommuteAtlanta.csv')
storepar<-par() # store graphics parameters

# stripchart / dotplot
drawstripchart<-function() {
  par(mai=c(1.4,0.82,0.42,0.42)) # extra bottom margin
  par(mgp=c(2,1,0)) # move x-axis label up a bit
  stripchart(2*floor((ac$Distance)/2), method = "stack",
             offset = .5, pch = 19, at=0, cex=0.8, ylim=c(0,60),
             main="Atlanta Commutes",
             xlab="Distance travelled (miles)", ylab="Number of people")
  mtext(text="Data from \"Statistics: Unlocking the Power of Data\" \n by the Locks (lock5stat.com)",
        side=1,line=4,cex=0.75)
  #axis(side=2,at=c(0,10,20,30,40,50))
  par(mai=storepar$mai)
  par(mgp=storepar$mgp)
}
svglite::svglite('3-stripchart-dotplot.svg')
drawstripchart()
dev.off()
png('3-stripchart-dotplot.png')
drawstripchart()
dev.off()


# histogram
drawhisto<-function(b) {
  par(mai=c(1.4,0.82,0.42,0.42)) # extra bottom margin
  par(mgp=c(2,1,0)) # move x-axis label up a bit
  hist(ac$Distance, breaks=b, main="Atlanta Commutes",
       xlab="Distance travelled (miles)", ylab="Number of people",
       col='#565656')
  mtext(text="Data from \"Statistics: Unlocking the Power of Data\" \n by the Locks (lock5stat.com)",
        side=1,line=4,cex=0.75)
  par(mai=storepar$mai)
  par(mgp=storepar$mgp)
}
svglite::svglite('3-histogram-20.svg'); drawhisto(20); dev.off()
svglite::svglite('3-histogram-10.svg'); drawhisto(10); dev.off()
svglite::svglite('3-histogram-50.svg'); drawhisto(50); dev.off()



# density plot
drawdens<-function(maxdens) {
  storepar<-par() # store graphics parameters
  par(mai=c(1.4,0.82,0.42,0.42)) # extra bottom margin
  par(mgp=c(2,1,0)) # move x-axis label up a bit
  plot(density(ac$Distance,bw="SJ"), main="Atlanta Commutes",
       yaxs='i',ylim=c(0,maxdens),
       cex.lab=1.3,cex.main=1.2,cex.axis=1.2,
       xlab="Distance travelled (miles)", ylab="Probability density")
  mtext(text="Data from \"Statistics: Unlocking the Power of Data\" \n by the Locks (lock5stat.com)",
        side=1,line=4,cex=1)
  par(mai=storepar$mai)
  par(mgp=storepar$mgp)
}
svglite::svglite('3-kernel-density.svg')
  drawdens(0.04)
dev.off()



# compare 2 cities
# the heatmap is adapted from hrbrmstr's blog
atl<-ac$Distance
nyc<-atl*(0.4+as.numeric((1:500)>400))
Distance<-c(atl,nyc)
City<-as.factor(rep(c('Atlanta','New York'),each=500))
comm<-data.frame(Distance=Distance,City=City)
library(ggplot2)
library(viridis)
svglite::svglite('3-compare-histo.svg')
  ggplot(comm,aes(x=Distance))+
    geom_histogram(binwidth=5)+
    theme_classic()+
    facet_grid(City~.)
dev.off()
comm2<-data.frame(Atlanta=atl,NYC=nyc)
svglite::svglite('3-compare-kernel.svg')
  ggplot(comm,aes(x=Distance))+
    geom_density(kernel="gaussian",aes(x=Distance,color=City))+
    theme_classic()
dev.off()
Count5<-c(61,73,93,64,63,38,50,29,3,11,7,1,4,0,0,0,0,0,1,0,2,
          183,114,108,24,25,14,4,9,8,6,1,1,3,0,0,0,0,0,0,0,0)
Distance5<-rep(seq(from=0,to=100,by=5),2)
City5<-as.factor(rep(c('Atlanta','New York'),each=21))
comm2<-data.frame(Distance=Distance5,Count=Count5,City=City5)
svglite::svglite('3-compare-heatmap.svg')
  ggplot(comm2,aes(x=Distance,y=City,fill=Count))+
    geom_tile(color="white", size=0.1)+
    scale_fill_viridis(name="Commuters")+
    theme_minimal()
dev.off()


# log-transformed kernel
ac$Distance<-sqrt(ac$Distance)
svglite::svglite('3-kernel-density-log.svg'); drawdens(0.25); dev.off()
# x-axis to be relabeled manually


# violin plot
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



# small multiple changes over time
x0<-rnorm(60,140,12)
x1<-x0+ifelse(x0>130,(130-x0)/4,0)+rnorm(60,0,5)
x2<-x1+ifelse(x1>130,(130-x1)/4,0)+rnorm(60,0,5)
x3<-x2+ifelse(x2>130,(130-x2)/4,0)+rnorm(60,0,5)
x4<-x3+ifelse(x3>130,(130-x3)/4,0)+rnorm(60,0,5)
quart<-cut(x0,quantile(x0,probs=c(0,0.25,0.5,0.75,1)),labels=FALSE)
x<-data.frame(pt=1:60,x0,x1,x2,x3,x4,quart)
x<-tidyr::gather(x,time,bp,-pt,-quart)
x$time<-as.numeric(stringr::str_sub(x$time,2))
for(j in 1:4) {
  x$thisq<-as.numeric(x$quart==j)
  x<-dplyr::arrange(x,thisq)
  svglite::svglite(paste0("3-small-change-",j,".svg"))
  plot(x$time,x$bp,col="white",xlab="Time",
       ylab=ifelse(j==1,"Systolic blood pressure (mmHg)",""))
  for(i in 1:60) {
    xx<-dplyr::filter(x,pt==i)
    lines(xx$time,xx$bp,
          col=ifelse(xx$quart==j,"#b62525aa","#88888888"),
          lwd=ifelse(xx$quart==j,2,1))
  }
  dev.off()
}


# scatterplot with marginal densities

# hexbin & contour
hb<-hexbin(iris$Sepal.Width,iris$Sepal.Length,xbins=20)
svglite::svglite('3-iris-hexbin.svg')
plot(hb)
dev.off()
svglite::svglite('3-iris-slice-density.svg')
slicedens(x=iris$Sepal.Width,y=iris$Sepal.Length,slices=12,yinc=0.05,
          lboost=0.03,gboost=0.4,fcol=rgb(0,0,0,200,maxColorValue=255),
          extend=TRUE,densopt=list(kernel="cosine",adjust=0.5))
dev.off()
petal.dens = kde2d(iris$Sepal.Width, iris$Sepal.Length)
svglite::svglite('3-iris-contour.svg')
contour(petal.dens,drawlabels=FALSE,ylab='Sepal Length',xlab='Sepal Width')
dev.off()




# use and abuse of axes

x<-1:4
y<-c(31,30.3,31.9,26)
svglite::svglite('3-abuse1.svg')
plot(x,y,ylim=c(0,35),xlim=c(0.5,4.5),xaxt='n',yaxs='i',bty='n',
     cex=1.4,cex.axis=1.5,cex.lab=1.5)
axis(side=1,at=0:5,cex.axis=1.5)
lines(x,y,lwd=2)
dev.off()
svglite::svglite('3-abuse2.svg')
plot(x,y,ylim=c(24,35),xlim=c(0.5,4.5),xaxt='n',yaxs='i',bty='n',
     cex=1.4,cex.axis=1.5,cex.lab=1.5)
axis(side=1,at=0:5,cex.axis=1.5)
lines(x,y,lwd=2)
dev.off()
y<-c(31,30.3,31.9,6)
svglite::svglite('3-abuse3.svg')
plot(x,y,ylim=c(0,35),xlim=c(0.5,4.5),xaxt='n',yaxs='i',bty='n',
     cex=1.4,cex.axis=1.5,cex.lab=1.5)
axis(side=1,at=0:5,cex.axis=1.5)
lines(x,y,lwd=2)
dev.off()
y<-c(31,30.3,31.9,26)
svglite::svglite('3-abuse4.svg',width=10,height=10) # needs manual tweaking
plot(x,y,ylim=c(20,35),xlim=c(0.5,4.5),xaxt='n',yaxs='i',bty='n',
     cex=1.4,cex.axis=1.5,cex.lab=1.5)
axis(side=1,at=0:5,cex.axis=1.5)
lines(x,y,lwd=2)
dev.off()
