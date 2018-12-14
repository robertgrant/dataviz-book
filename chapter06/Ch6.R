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

# Chapter 6

mpyar<-c(2.18, 2.68, 2.11, 1.71, 0.48, 2.74, 4.24, 9.16)
inc<-c(17416, 19307, 15183, 12838, 4031, 19649, 31710, 68775)
rates<-10000*inc/(mpyar*1000000)
rates/rates[2]
rates-rates[2]
caplot<-function() {
  plot((1:5),rates[1:5],ylim=c(0,100),yaxs='i',xlim=c(0.4,5.6),
     xaxt='n',xlab='Alcoholic drinks per week',
     ylab='Cancer incidence (per 10,000 PYAR)',type='h')
  #lines((1:5),rates[1:5],col='#bbbbbb')
  points((1:5),rates[1:5],cex=2)
  axis(1,at=(1:5),labels=c('0','1-2','3-6','7-14','15+'))
}
svglite::svglite('6-cancer.svg')
  caplot()
dev.off()
png('6-cancer.png')
  caplot()
dev.off()
rr<-rates[1:5]/rates[2]
rr2<-100*(rr-1)
caplot2<-function() {
  plot((1:5),rr2,ylim=c(-20,20),yaxs='i',xlim=c(0.4,5.6),
     xaxt='n',xlab='Alcoholic drinks per week',
     yaxt='n',ylab='Cancer incidence compared to lightest drinkers',type='h')
  #lines((1:5),rates[1:5],col='#bbbbbb')
  lines(x=c(0,6),y=c(0,0),lty=3)
  points((1:5),rr2,cex=2)
  axis(1,at=(1:5),labels=c('0','1-2','3-6','7-14','15+'))
  axis(2,at=c(-20,-10,0,10,20),labels=c('-20%','-10%','0%','+10%','+20%'))
}
svglite::svglite('6-cancer2.svg')
  caplot2()
dev.off()
png('6-cancer2.png')
  caplot2()
dev.off()


drawcor<-function(r) {
  x<-MASS::mvrnorm(1000,mu=c(100,100),Sigma=matrix(c(10,10*r,10*r,10),nrow=2))
  png(paste0('~/Dropbox/Books/Dataviz CRC-ASA/images/6-correlation-',r*10,'.png'))
  plot(x,col='#00000044',pch=19,cex=2,xlab='',ylab='',xaxt='n',yaxt='n')
  dev.off()
  svglite::svglite(paste0('~/Dropbox/Books/Dataviz CRC-ASA/images/6-correlation-',r*10,'.svg'))
  plot(x,col='#00000044',pch=19,cex=2,xlab='',ylab='',xaxt='n',yaxt='n')
  dev.off()
}
drawcor(0.2)
drawcor(0.6)
drawcor(0.9)


cor1<-cor(iris[,1:4])
for(i in 1:4) { cor1[i,i]<-NA }
cors<-reshape2::melt(cor1)
# get it to match the previous scatterplot matrix
cors$Var1<-factor(cors$Var1,levels=c('Sepal.Length',
                                     'Sepal.Width',
                                     'Petal.Length',
                                     'Petal.Width'))
cors$Var2<-factor(cors$Var2,levels=c('Petal.Width',
                                     'Petal.Length',
                                     'Sepal.Width',
                                     'Sepal.Length'))

# this makes the heatmap; some tweaking is done in Inkscape
svglite::svglite('6-heatmap-matrix.svg')
ggplot2::ggplot(cors,aes(Var1,Var2))+
  geom_tile(aes(fill=value),color="white",size=0.1)+
  scale_fill_gradient2(limits=c(-1,1))+
  theme_minimal()+
  coord_equal()
dev.off()
