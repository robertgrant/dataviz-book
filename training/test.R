# simpleboot test script

setwd('~/git/simpleboot')
source('simpleboot.R')
library(mvtnorm)

# make data
set.seed(15)
x<-rmvnorm(n=100,sigma=matrix(c(1,0.4,0.4,1),nrow=2))
y<-x[,2]
x<-x[,1]

# example of running
simpleboot(x,stat='mean')

# vector of stat arguments
thestats<-c('mean','sd','median','p25','p75','iqr','pearson','spearman')

# data frame to hold results
res<-data.frame(statname=thestats,
                point.est=c(mean(x),
                            sd(x),
                            quantile(x,probs=c(0.5,0.25,0.75)),
                            quantile(x,probs=c(0.75))-quantile(x,probs=c(0.25)),
                            cor(x,y,use='complete',method='pearson'),
                            cor(x,y,use='complete',method='spearman')),
                perc.only.lci=rep(NA,8),perc.only.uci=rep(NA,8),
                norm.all.lci=rep(NA,8),norm.all.uci=rep(NA,8),
                perc.all.lci=rep(NA,8),perc.all.uci=rep(NA,8),
                bca.all.lci=rep(NA,8),bca.all.uci=rep(NA,8),
                perc.only.multicore.lci=rep(NA,8),perc.only.multicore.uci=rep(NA,8),
                norm.all.multicore.lci=rep(NA,8),norm.all.multicore.uci=rep(NA,8),
                perc.all.multicore.lci=rep(NA,8),perc.all.multicore.uci=rep(NA,8),
                bca.all.multicore.lci=rep(NA,8),bca.all.multicore.uci=rep(NA,8),
                time.only=rep(NA,8),
                time.all=rep(NA,8),
                time.only.multicore=rep(NA,8),
                time.all.multicore=rep(NA,8))

# loop over stats + all.cis + multicore
statn<-1
for(s in thestats) {
  for(a in c(TRUE,FALSE)) {
    for(m in c(TRUE,FALSE)) {
      ncpus<-1+(as.numeric(m)*3)
      cat("################################################################ \n")
      cat("#########################  Testing:  ###########################  \n")
      cat(paste0("stat = ",s,' ; all.cis = ',a,' ; multicore = ',m,'\n'))
      cat("################################################################ \n")
      time0<-Sys.time()
      if(s=='pearson' | s=="spearman") {
        out<-simpleboot(x=x,y=y,stat=s,all.cis=a,ncpus=m,noisy=FALSE)
      }
      else {
        out<-simpleboot(x,stat=s,all.cis=a,ncpus=m,noisy=FALSE)
      }
      dur<-as.numeric(Sys.time()-time0)
      if(a) { atxt='.all' }
      else { atxt='.only' }
      if(m) { mtxt='.multicore' }
      else { mtxt='' }
      res[statn,paste0('perc',atxt,mtxt,'.lci')]<-out$percent.ci[1]
      res[statn,paste0('perc',atxt,mtxt,'.uci')]<-out$percent.ci[2]
      if(a) {
        res[statn,paste0('norm',atxt,mtxt,'.lci')]<-out$normal.ci[1]
        res[statn,paste0('norm',atxt,mtxt,'.uci')]<-out$normal.ci[2]
        res[statn,paste0('bca',atxt,mtxt,'.lci')]<-out$bca.ci[1]
        res[statn,paste0('bca',atxt,mtxt,'.uci')]<-out$bca.ci[2]
      }
      res[statn,paste0('time',atxt,mtxt)]<-dur
    }
  }
  statn<-statn+1
}

# draw charts
ncis<-(dim(res)[2]-6)/2
# loop over stats
for(i in 1:(dim(res)[1])) {
  # draw point estimate
  plot(x=0,y=res[i,2],xlim=c(0,ncis),ylim=range(res[i,3:(dim(res)[2]-4)]),
       main=res[i,1],cex=1.6,col='#f74a62')
  # loop over CIs
  for(j in 1:ncis) {
    thisci<-c(1,2)+(2*j)
    lines(x=c(j,j),y=res[i,thisci],col='#42566f')
  }
}