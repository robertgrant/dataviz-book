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




# Chapter 8

# bootstrap semi-transparents

n<-60
iter<-100
set.seed(2546)
# markers for mean

x<-rpois(n,2.8)+runif(n,min=(-0.1),max=0.1)
y<-rbeta(n,0.5,0.5)
x[1:(floor(n/3))]<-sort(x[1:(floor(n/3))]) # induce a little correlation
y[1:(floor(n/3))]<-sort(y[1:(floor(n/3))])
svglite::svglite('8-bootstrap-means.svg')
  plot(x,y,ylim=c(0,1.1),cex=0.6,col='#00000080',bty='n')
  for(i in 1:iter) {
    bs<-sample(1:n,n,replace=TRUE)
    mx<-mean(x[bs])
    my<-mean(y[bs])
    points(mx,my,pch=19,col='#cd4c4c15')
  }
dev.off()
# convex hull for the same
ch<-chull(x,y)


# splines
xg<-seq(from=0,to=8,by=0.01)
svglite::svglite('8-bootstrap-splines.svg')
  plot(x,y,ylim=c(0,1.1),cex=0.6,col='#00000080',bty='n')
  for(i in 1:iter) {
    bs<-sample(1:n,n,replace=TRUE)
    ly<-predict(smooth.spline(y[bs]~x[bs],spar=1),x=xg)
    lines(ly$x,ly$y,col='#cd4c4c15',lwd=3)
  }
dev.off()



# hurricane paths
xx<-yy<-g<-NULL
set.seed(873646)
sumx<-sumy<-rep(0,500)
svglite::svglite('8-hurricane1.svg')
plot(c(0,500),c(0,400),col='#ffffff',bty='n',xaxt='n',yaxt='n',xlab='',ylab='')
for(i in 1:100) {
  x<-cumsum(seq(from=1,to=0.3,length.out=500)+cumsum(rnorm(500,mean=0,sd=0.01)))
  y<-cumsum(seq(from=0.2,to=1,length.out=500)+cumsum(rnorm(500,mean=0,sd=0.01)))
  xx<-c(xx,x)
  yy<-c(yy,y)
  g<-c(g,rep(i,500))
  lines(x,y,lwd=1,col='#00000033')
}
dev.off()

set.seed(873646)
sumx<-sumy<-rep(0,500)
allx<-ally<-NULL
for(i in 1:100) {
  x<-cumsum(seq(from=1,to=0.3,length.out=500)+cumsum(rnorm(500,mean=0,sd=0.01)))
  y<-cumsum(seq(from=0.2,to=1,length.out=500)+cumsum(rnorm(500,mean=0,sd=0.01)))
  allx<-c(allx,x)
  ally<-c(ally,y)
}
all<-data.frame(x=allx,y=ally)
svglite::svglite('8-hurricane3.svg')
ggplot2::ggplot(all,aes(x,y)) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  scale_fill_distiller(palette='Blues',direction=1) +
  theme_void()
dev.off()



#  funnel plot

set.seed(4144)
n_hospitals<-60
min_patients<-10
max_patients<-1000
global_death_rate<-0.048
hospital_death_rates<-global_death_rate+rnorm(n_hospitals,mean=0,sd=0.0002)
n_patients<-floor(runif(n_hospitals,min=min_patients,max=max_patients))
n_deaths<-rbinom(n_hospitals,n_patients,hospital_death_rates)
observed_global_rate<-sum(n_deaths)/sum(n_patients)
lcis95<-ucis95<-lcis99<-ucis99<-rep(NA,max_patients-min_patients+1) # hypothetical patient counts
for(i in 1:(max_patients-min_patients+1)) {
  lcis95[i]<-qbinom(0.025,i+min_patients-1,observed_global_rate)/(i+min_patients-1)
  ucis95[i]<-qbinom(0.975,i+min_patients-1,observed_global_rate)/(i+min_patients-1)
  lcis99[i]<-qbinom(0.01,i+min_patients-1,observed_global_rate)/(i+min_patients-1)
  ucis99[i]<-qbinom(0.99,i+min_patients-1,observed_global_rate)/(i+min_patients-1)
}
plot(n_patients,100*n_deaths/n_patients,
     xlab="Number of patients",
     ylab="Hospital death rate (%)",
     main="Variation in deaths treating Disease X",
     ylim=c(0,1.6*max(100*n_deaths/n_patients)),
     xaxs='i',yaxs='i',
     cex.main=1.5,
     cex.lab=1.4,
     cex.axis=1.3)
abline(h=100*observed_global_rate,lty=3,lwd=1.5)
lines(min_patients:max_patients,100*lcis95,col='#26469C',lwd=1.8)
lines(min_patients:max_patients,100*ucis95,col='#26469C',lwd=1.8)
lines(min_patients:max_patients,100*lcis99,col='#9c2646',lwd=1.8)
lines(min_patients:max_patients,100*ucis99,col='#9c2646',lwd=1.8)
legend(x='topright',
       legend=c('Hospital','National rate','95% limit','99% limit'),
       lty=c(0,3,1,1),
       lwd=c(NA,1.5,1.8,1.8),
       col=c('black','black','#26469C','#9c2646'),
       pch=c(1,NA,NA,NA),
       cex=1.3)
