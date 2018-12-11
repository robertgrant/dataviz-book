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


# Chapter 5

# Figure 5.1: medians dot plot

commute<-c(15,
           22,
           26,
           38,
           30,
           19)
city<-as.factor(c('Atlanta',
                  'Boston',
                  'Chicago',
                  'Los Angeles',
                  'New York',
                  'San Francisco'))
myplot<-function() {
qmai<-par('mai')
nmai<-qmai
nmai[1]<-1.4
nmai[2]<-1.1
par(mai=nmai)
plot(as.numeric(city),commute,pch=19,
     cex=1.7,cex.axis=1.3,cex.lab=1.3,
     xaxt='n',yaxt='n',xaxs='i',yaxs='i',bty='n',
     xlim=c(0.5,6.5),ylim=c(0,45),
     xlab='',ylab='Median commute time (minutes)')
axis(side=1,at=0:7,labels=c('',levels(city),''),cex.axis=1,las=2)
axis(side=2,at=seq(from=0,to=40,by=10),cex.axis=1.3,las=1)
par(mai=qmai)
}
png('5-dotplot.png');myplot();dev.off();
svglite::svglite('5-dotplot.svg');myplot();dev.off();




# Figure 5.3: dot plot with error bars (for 95% reference range = 2SDs in this case)

bp<-c(122,
      127,
      116,
      120,
      117)
sd<-c(12,
      14,
      11.5,
      13.1,
      15.2)
travel<-as.factor(c('Bus',
                    'Car',
                    'Cycle',
                    'Train',
                    'Walk'))
myplot<-function() {
  qmai<-par('mai')
  nmai<-qmai
  nmai[1]<-1.4
  nmai[2]<-1.1
  par(mai=nmai)
  plot(as.numeric(travel),bp,pch=19,
       cex=1.7,cex.axis=1.3,cex.lab=1.3,
       xaxt='n',yaxt='n',xaxs='i',yaxs='i',bty='n',
       xlim=c(0.5,5.5),ylim=c(80,165),
       xlab='',ylab='Blood pressure',
       sub='Mean (95% reference range)',cex.sub=1.4)
  axis(side=1,at=0:6,labels=c('',levels(travel),''),cex.axis=1.3,las=2)
  axis(side=2,at=seq(from=80,to=160,by=20),cex.axis=1.3,las=1)
  for(i in 1:5){
    lines(x=c(i,i),y=bp[i]+(c(-2,2)*sd[i]))
  }
  par(mai=qmai)
}
png('5-meansplot-errorbars.png');myplot();dev.off();
svglite::svglite('5-meansplot-errorbars.svg');myplot();dev.off();
