simpleboot<-function(x,y=NULL,stat=NULL,probs=NULL,reps=1000,noisy=TRUE,ncpus=1,all.cis=TRUE) {
  if(noisy){
    cat("Bootstrapping can go wrong! ")
    cat("This simple function will not show you warning messages.\n")
    cat("Check results closely and be prepared to consult a statistician. ")
    cat("For example, CIs should contain the point estimate and not extend into impossible values\n")
    if(is.null(stat) & is.character(y)) {
      stat<-y
      y<-NULL
    }
    if(stat=="max" | stat=="min") { warning("Bootstrap does not work for minima and maxima (think about it)") }
    if(stat!="mean" & stat!="median" & stat!="p25" & stat!="p75" & stat!="iqr" &
      stat!="sd" & stat!="pearson" & stat!="spearman") {
          warning("Simpleboot is only programmed to work with stat set to one of: mean, median, sd, iqr, p25, p75, pearson, spearman, meandiff, mediandiff. Other functions might work, but there's no guarantee!")
    }
  }
  # set up multicore if ncpus>1
  multicore<-(ncpus>1)

  # install boot if not in library
  if(!(require(boot))) {
    install.packages('boot')
  }
  if(stat=="p25") {
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) quantile(x[i],probs=0.25,na.rm=TRUE)"),list(stat=stat)))))
  }
  else if(stat=="p75") {
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) quantile(x[i],probs=0.75,na.rm=TRUE)"),list(stat=stat)))))
  }
  else if(stat=="iqr") {
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) quantile(x[i],probs=0.75,na.rm=TRUE)-quantile(x[i],probs=0.25,na.rm=TRUE)"),list(stat=stat)))))
  }
  else if(stat=="quantile") {
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) quantile(x[i],probs=",probs,",na.rm=TRUE)"),list(stat=stat)))))
  }
  else if(stat=="pearson" | stat=="spearman") {
    x<-matrix(c(x,y),ncol=2)[(!is.na(x))&(!is.na(y)),]
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) cor(x[i,],use='complete',method='",stat,"')[1,2]"),list(stat=stat)))))
  }
  else if(stat=="meandiff"){
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) mean(x[i],na.rm=TRUE)-mean(y[i],na.rm=TRUE)"),list(stat=stat)))))
  }
  else if(stat=="mediandiff"){
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) median(x[i],na.rm=TRUE)-median(y[i],na.rm=TRUE)"),list(stat=stat)))))
  }
  else {
    eval(parse(text=eval(substitute(paste0("p.func<-function(x,i) ",stat,"(x[i],na.rm=TRUE)"),list(stat=stat)))))
  }
  if(multicore) {
    bootsy<-boot(x,statistic=p.func,R=reps,stype="i",parallel='multicore',ncpus=ncpus)
  }
  else {
    bootsy<-boot(x,statistic=p.func,R=reps,stype="i")
  }
  if(noisy){
    hist(bootsy$t,breaks=25,main="EDF from bootstrap",xlab=stat)
  }
  if(all.cis) {
    temp<-boot.ci(bootsy,type=c('norm','perc','bca'))
    suppressWarnings(return(list(replicates=reps,
                                 point.estimate=bootsy$t0,
                                 normal.ci=temp$normal[2:3],
                                 percent.ci=temp$percent[4:5],
                                 bca.ci=temp$bca[4:5])))
  }
  else {
    temp<-boot.ci(bootsy,type=c('perc'))
    suppressWarnings(return(list(replicates=reps,
                                 point.estimate=bootsy$t0,
                                 percent.ci=temp$percent[4:5])))
  }

}
