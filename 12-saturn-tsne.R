# saturn tsne

library(dplyr)
library(tsne)
splot0<-function(x) {  
  plot(x,bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
                           cex=0.8,pch=19,col='#00000066')
}
splot<-function(x,name){
  png(paste0(name,'.png')); splot0(x); dev.off();
  svglite::svglite(paste0(name,'.svg')); splot0(x); dev.off();
}

##################  image in the book ####################
set.seed(43807)
cube<-data.frame(x=runif(1000000,min=-1,max=1),
                 y=runif(1000000,min=-1,max=1),
                 z=runif(1000000,min=-1,max=1))
dist<-sqrt(cube$x^2+cube$y^2+cube$z^2)
planet<-cube[dist<0.4,]
rings<-cube[dist>0.5 & dist<0.7 & abs(cube$z)<0.05,]
saturn<-rbind(planet,rings)
saturn<-saturn[sample(dim(saturn)[1],1000),]
splot(saturn[,1:2],"saturn_plan")
splot(saturn[,c(1,3)],"saturn_elevation")
splot(cbind(saturn[,1],sqrt(2)*saturn[,2]+sqrt(2)*saturn[,3]),"saturn_tilted")
pca.saturn<-princomp(saturn,scores=TRUE)$scores
splot(pca.saturn[,1:2],"saturn_pca")
tsne.saturn<-tsne(saturn)
splot(tsne.saturn,"saturn_tsne")


###################  additional blog images  ##################

north_south_cols<-colorspace::diverge_hcl(10, 
                                          h = c(246, 40), 
                                          c = 96,
                                          l = c(65, 90))
north_south_cats<-floor(1+(9.99*(saturn[,3]-min(saturn[,3]))/
                             (max(saturn[,3])-min(saturn[,3]))))
north_south<-north_south_cols[north_south_cats]
plot(pca.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=north_south)
plot(tsne.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=north_south)

longitude_cols<-colorspace::rainbow_hcl(20)
#longitude_rads<-(as.numeric(saturn[,1]<0)*pi)+
#                (((as.numeric(saturn[,1]>=0)*2)-1)*atan(saturn[,2]/saturn[,1]))
longitude_rads<-atan2(saturn[,2],saturn[,1])
longitude_cats<-floor(1+(19.99*(longitude_rads-min(longitude_rads))/
                           (max(longitude_rads)-min(longitude_rads))))
longitude<-longitude_cols[longitude_cats]
plot(pca.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=longitude)
plot(tsne.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=longitude)


# try different perplexities
tsne.saturn<-tsne(saturn,perplexity=150)
north_south_cols<-colorspace::diverge_hcl(10, 
                                          h = c(246, 40), 
                                          c = 96,
                                          l = c(65, 90))
north_south_cats<-floor(1+(9.99*(saturn[,3]-min(saturn[,3]))/
                             (max(saturn[,3])-min(saturn[,3]))))
north_south<-north_south_cols[north_south_cats]
plot(pca.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=north_south)
plot(tsne.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=north_south)

longitude_cols<-colorspace::rainbow_hcl(20)
#longitude_rads<-(as.numeric(saturn[,1]<0)*pi)+
#                (((as.numeric(saturn[,1]>=0)*2)-1)*atan(saturn[,2]/saturn[,1]))
longitude_rads<-atan2(saturn[,2],saturn[,1])
longitude_cats<-floor(1+(19.99*(longitude_rads-min(longitude_rads))/
                           (max(longitude_rads)-min(longitude_rads))))
longitude<-longitude_cols[longitude_cats]
plot(pca.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=longitude)
plot(tsne.saturn[,1:2],bty='n',xaxt='n',yaxt='n',xlab="",ylab="",
     cex=0.8,pch=19,col=longitude)
