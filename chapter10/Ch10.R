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

set.seed(434)
n<-40
ntrain<-20
iter<-20
x<-rnorm(n,mean=100,sd=10)
y0<-rnorm(n,mean=0,sd=1)
y1<-abs((x-100)/14)+rnorm(n,mean=0,sd=0.7)
plot(x,y0)

rms<-array(NA,dim=c(6,2,iter))
colnames(rms)<-c('train','test')

for(i in 1:iter) {
tr<-sample(1:n,ntrain)
xtr<-x[tr]
xte<-x[-tr]
#ytr<-y0[tr]
#yte<-y0[-tr]
ytr<-y1[tr]
yte<-y1[-tr]

x2tr<-xtr^2
x3tr<-xtr^3
x4tr<-xtr^4
x5tr<-xtr^5
x2te<-xte^2
x3te<-xte^3
x4te<-xte^4
x5te<-xte^5

mod0tr<-lm(ytr~1)
rms[1,1,i]<-sqrt(mean((mod0tr$residuals)^2))
rms[1,2,i]<-sqrt(mean((predict(mod0tr,data.frame(ytr=yte,xtr=xte))-yte)^2))
mod1tr<-lm(ytr~xtr)
rms[2,1,i]<-sqrt(mean((mod1tr$residuals)^2))
rms[2,2,i]<-sqrt(mean((predict(mod1tr,data.frame(ytr=yte,xtr=xte))-yte)^2))
mod2tr<-lm(ytr~xtr+x2tr)
rms[3,1,i]<-sqrt(mean((mod2tr$residuals)^2))
rms[3,2,i]<-sqrt(mean((predict(mod2tr,
                             data.frame(ytr=yte,xtr=xte,x2tr=x2te))-yte)^2))
mod3tr<-lm(ytr~xtr+x2tr+x3tr)
rms[4,1,i]<-sqrt(mean((mod3tr$residuals)^2))
rms[4,2,i]<-sqrt(mean((predict(mod3tr,
                             data.frame(ytr=yte,
                                        xtr=xte,
                                        x2tr=x2te,
                                        x3tr=x3te))-yte)^2))
mod4tr<-lm(ytr~xtr+x2tr+x3tr+x4tr)
rms[5,1,i]<-sqrt(mean((mod4tr$residuals)^2))
rms[5,2,i]<-sqrt(mean((predict(mod4tr,
                               data.frame(ytr=yte,
                                          xtr=xte,
                                          x2tr=x2te,
                                          x3tr=x3te,
                                          x4tr=x4te))-yte)^2))
mod5tr<-lm(ytr~xtr+x2tr+x3tr+x4tr+x5tr)
rms[6,1,i]<-sqrt(mean((mod5tr$residuals)^2))
rms[6,2,i]<-sqrt(mean((predict(mod5tr,
                               data.frame(ytr=yte,
                                          xtr=xte,
                                          x2tr=x2te,
                                          x3tr=x3te,
                                          x4tr=x4te,
                                          x5tr=x5te))-yte)^2))
}

mrms<-apply(rms,c(1,2),mean)

svglite::svglite('10-cv-data.svg')
plot(x,y1,xaxt='n',yaxt='n',xlab='',ylab='')
dev.off()

svglite::svglite('10-cv-rms.svg')
plot(0:5,mrms[,1],type='l',col='black',lty=1,ylim=c(0.4,1.6),yaxs='i',
     xlab='Complexity of polynomial model',
     ylab=paste('Mean RMS error over',iter,'cross-validation splits'))
lines(0:5,mrms[,2],col='black',lty=3)
points(0:5,mrms[,1])
points(0:5,mrms[,2])
legend(x=0,y=1.52,lty=c(1,3),legend=c('Training','Test'))
dev.off()


#####################

set.seed(434)
x<-runif(50,min=0,max=10)
y<-runif(50,min=0,max=10)
p<-exp(x+0.4*y-8)/(1+exp(x+0.4*y-8))
o<-rbinom(50,size=1,prob=p)
svglite::svglite('10-logistic.svg')
plot(x,y,pch=1+18*o,xlab="Predictor A",ylab="Predictor B")
lines(x=c(8.1,4.1),y=c(0,10))
dev.off()
svglite::svglite('10-logistic-wrong.svg')
plot(x,y,pch=1+18*as.numeric((as.numeric(p>0.5))!=o),
     xlab="Predictor A",ylab="Predictor B")
lines(x=c(8.1,4.1),y=c(0,10))
dev.off()
