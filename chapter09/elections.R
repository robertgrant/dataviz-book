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



graphics.off()

elec<-read.csv("elections_wide.csv")
yuk<-elec$p3
xuk<-elec$p1-((1-elec$p3)/2)
ysc<-elec$p13
xsc<-elec$p11-((1-elec$p13)/2)

sp<-read.csv("parliament.csv")
ysp<-sp$vote3
xsp<-sp$vote1-((1-sp$vote3)/2)

# interpolation by splines
# here you could reduce the granularity
frametime<-seq(from=1945,to=2010,by=0.2)
spxuk<-smooth.spline(x=elec$year,y=xuk,all.knots=TRUE,spar=0.1)
spyuk<-smooth.spline(x=elec$year,y=yuk,all.knots=TRUE,spar=0.1)
lxuk<-predict(spxuk,frametime)$y
lyuk<-predict(spyuk,frametime)$y
spxsc<-smooth.spline(x=elec$year,y=xsc,all.knots=TRUE,spar=0.1)
spysc<-smooth.spline(x=elec$year,y=ysc,all.knots=TRUE,spar=0.1)
lxsc<-predict(spxsc,frametime)$y
lysc<-predict(spysc,frametime)$y

windows(height=800,width=800)
# simple plots to check the splines have worked
#plot(elec$year,xuk)
#lines(frametime,lxuk)
#plot(elec$year,yuk)
#lines(frametime,lyuk)
#plot(elec$year,xsc)
#lines(frametime,lxsc)
#plot(elec$year,ysc)
#lines(frametime,lysc)

ukcol<-rgb(red=0,green=0,blue=0,
		alpha=seq(from=0.1,to=1,length.out=17),
		maxColorValue=1)
sccol<-rgb(red=0,green=0.396,blue=0.741,
		alpha=seq(from=0.1,to=1,length.out=17),
		maxColorValue=1)
uklcol<-rgb(red=0,green=0,blue=0,
		alpha=seq(from=0.1,to=1,length.out=length(frametime)),
		maxColorValue=1)
sclcol<-rgb(red=0,green=0.396,blue=0.741,
		alpha=seq(from=0.1,to=1,length.out=length(frametime)),
		maxColorValue=1)
par(mar=c(0.1,0.1,1,0.1))
purp<-rgb(red=199,green=21,blue=133,maxColorValue=255)

png("elections.png",width=800,height=800)
plot(xuk,yuk,xlim=c(-0.7,0.7),ylim=c(-0.2,1.2),xaxt="n",yaxt="n",
	xlab="",ylab="",bty="n",col=ukcol,cex=1.5,
	main="")
points(xsc,ysc,col=sccol,cex=1.5)
points(xsp,ysp,col=purp,cex=1.5)
for (i in 2:length(frametime)) {
	lines(x=c(lxuk[i-1],lxuk[i]),
		y=c(lyuk[i-1],lyuk[i]),col=uklcol[i],lwd=2)
	lines(x=c(lxsc[i-1],lxsc[i]),
		y=c(lysc[i-1],lysc[i]),col=sclcol[i],lwd=2)
}
lines(xsp,ysp,col=purp,lwd=2)
lines(x=c(-0.5,0.5),y=c(0,0))
lines(x=c(0,0.5),y=c(1,0))
lines(x=c(-0.5,0),y=c(0,1))
text(x=0,y=1.2,labels="Ternary plot of UK popular vote, 1945-2010",cex=2.4)

text(x=-0.5,y=-0.04,labels="Labour",cex=2)
text(x=0.5,y=-0.04,labels="Conservative",cex=2)
text(x=0,y=1.04,labels="Others",cex=2)
legend(x=-0.75,y=1,legend=c("Scots votes for Westminster",
					"Rest of UK for Westminster",
					"Scottish parliament (since 1999)"),
	col=c(sccol[17],ukcol[17],purp),
	pch=c(1,1,1),
	cex=1.5,pt.cex=1.5,
	bty="n")
text(x=-0.6,y=0.78,labels="Paler lines are older",cex=1.1)
dev.off()
