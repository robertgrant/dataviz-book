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

library(readr)

# get hiv data
hiv0<-read_csv('HIV-population.csv')
hiv0<-dplyr::filter(hiv0,Country=='Global')
hiv0<-hiv0[,stringr::str_length(colnames(hiv0))==4]
hiv<-t(as.matrix(hiv0))
hiv<-as.numeric(stringr::str_replace_all(hiv,pattern=" ",replacement=""))
hiv<-data.frame(year=1990:2016,hiv=hiv,stringsAsFactors=FALSE)
svglite::svglite('9-timeline-hiv.svg')
plot(hiv$year,hiv$hiv,type='l',
     ylim=c(0,40000000),xlim=c(1974,2017),yaxs='i',xaxs='i',bty='n',
     ylab='HIV population',xlab='Year')
dev.off()

# get nuclear warheads data
nuc0<-read_csv('nuclear-warheads.csv')
nuc<-rep(NA,41)
for(i in 1:41) {
  nuc[i]<-sum((dplyr::filter(nuc0,Year==as.character(1973+i)))[,4])
}
nuc<-data.frame(year=1974:2014,nuc=nuc,stringsAsFactors=FALSE)
svglite::svglite('9-timeline-nuc.svg')
plot(nuc$year,nuc$nuc,type='l',
     ylim=c(0,70000),xlim=c(1974,2017),yaxs='i',xaxs='i',bty='n',
     ylab='Nuclear warheads',xlab='Year')
dev.off()

# get Halley ozone data
ozo0<-jpeg::readJPEG('halley-ozone.JPG')[149:868,137:864,1]
#col 122 = 450 Dobsons
#col 872 = 0 Dobsons
#row 134 = year 1950
#row 883 = year 2020
# cut 15 pixels off all round for axes
ozopx<-which(t(ozo0)<0.2,arr.ind=TRUE)
ozo<-data.frame(dobson=450*(1-(ozopx[,2]+15)/(872-122)),
                year=1950+(70*(ozopx[,1]+15)/(883-134)))
sozo<-predict(smooth.spline(x=ozo$year,y=ozo$dobson,spar=0.2),
              x=seq(from=1955,to=2017,by=1))
svglite::svglite('9-timeline-ozo.svg')
plot(sozo[['x']],sozo[['y']],type='l',
     ylim=c(0,350),xlim=c(1974,2017),yaxs='i',xaxs='i',bty='n',
     ylab='Antarctic ozone',xlab='Year')
dev.off()
