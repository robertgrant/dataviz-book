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


library(grid)
library(gtable)
library(ggplot2)
library(ggExtra)
library(tree)

t<-tree(Petal.Width ~ Sepal.Width + Sepal.Length,data=iris)
p<-predict(t)
r<-iris$Petal.Width-p

# Figure 11.2
svglite::svglite('11-iris1.svg') # requires manual addition of lines
  plot(iris$Petal.Length,iris$Petal.Width,cex=1.8,col=as.numeric(iris$Species),
       xlab='Petal length (cm)',ylab='Petal width (cm)',
       cex.axis=3,cex.lab=3)
dev.off()



# Figure 11.3
svglite::svglite('11-iris-3a.svg')
  partition.tree(t)
  points(iris$Sepal.Length,iris$Sepal.Width,cex=1.3*sqrt(iris$Petal.Width),
         cex.axis=1.4,cex.lab=1.4)
dev.off()
png('11-iris-3a.png')
  partition.tree(t)
  points(iris$Sepal.Length,iris$Sepal.Width,cex=1.3*sqrt(iris$Petal.Width),
         cex.axis=1.4,cex.lab=1.4)
dev.off()

svglite::svglite('11-iris-3b.svg')
  partition.tree(t)
  points(iris$Sepal.Length,iris$Sepal.Width,cex=3*abs(r))
dev.off()
png('11-iris-3b.png')
  partition.tree(t)
  points(iris$Sepal.Length,iris$Sepal.Width,cex=3*abs(r))
dev.off()




# Figure 11.6

set.seed(7614)
x<-runif(100,-2,2)
y<-runif(100,-2,2)
z<-sqrt(x^2 + y^2) < 0.7
svglite::svglite('11-svm.svg')
  plot(x,y,cex=3,col=ifelse(z,'#b62525','#000000'),pch=ifelse(z,19,1),
       xaxt='n',yaxt='n',ylab='',xlab='')
dev.off()
