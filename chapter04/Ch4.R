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


# Chapter 4

library(waffle)
library(treemap)


# Figure 4.2
x<-rep(seq(from=0,to=990,by=110),10)
y<-rep(seq(from=0,to=990,by=110),each=10)
colz<-c('#1c1c1c','#414141','#747474','#9d9d9d','#7f0608','#cbcbcb')
drugz<-c(47,24,3,7,6,13)
drugcol<-rep(colz,drugz)
svgz<-paste0("<rect x='",x,
             "' y='",y,
             "' height='100' width='100' style='fill:",
             drugcol,";stroke:none;'/>")
con<-file('delete-me.txt','w')
writeLines(svgz,con)
close(con)


# Figure 4.7
pre<-c(12, 14, 57, 90, 80, 79, 11, 22, 21, 18)
post<-c(9, 16, 55, 71, 80, 76, 19, 11, 33, 18)
change<-post-pre

xpre<-390.68+212.95+60.84+((0:9)*304.21)
xpost<-390.68+212.95+60.84+91.36+((0:9)*304.21)

o<-order(pre,decreasing=TRUE) # ranked by pre value
fo<-file('deleteme.txt',open='w')
write(paste0('<rect x="',xpre,'" y="',2223.73-(pre[o]*20.22),'" width="91.16" height="',pre[o]*20.22,
       '" style="fill:#202020;stroke:#000000;stroke-width:0.12"/> \n',
       '<rect x="',xpost,'" y="',2223.73-(post[o]*20.22),'" width="91.16" height="',post[o]*20.22,
       '" style="fill:#e0e0e0;stroke:#000000;stroke-width:0.12"/>'),
      file=fo)
close(fo)

o<-order(change,decreasing=TRUE) # ranked by change
fo<-file('deleteme.txt',open='w')
write(paste0('<rect x="',xpre,'" y="',2223.73-(pre[o]*20.22),'" width="91.16" height="',pre[o]*20.22,
             '" style="fill:#202020;stroke:#000000;stroke-width:0.12"/> \n',
             '<rect x="',xpost,'" y="',2223.73-(post[o]*20.22),'" width="91.16" height="',post[o]*20.22,
             '" style="fill:#e0e0e0;stroke:#000000;stroke-width:0.12"/>'),
      file=fo)
close(fo)
# then combined with SVG of Figure 4.6 in Inkscape (see markdown file)


# Figure 4.8
countries <- data.frame(country2010=c(rep('UK',10),
                                       rep('Ireland',14),
                                       rep('Portugal',7)),
                         country2015=c(rep('UK',8),
                                       rep('Ireland',13),
                                       rep('UK',2),
                                       rep('Portugal',7),
                                       'Ireland'))
svglite::svglite('3-parallel-sets.svg')
ggparallel(names(countries)[1:2], order=0, countries) +
  scale_fill_brewer(palette="Paired", guide="none") +
  scale_colour_brewer(palette="Paired", guide="none")
dev.off()

# this improved version borrowed code from
# https://matthewdharris.com/2017/11/11/a-brief-diversion-into-static-alluvial-sankey-diagrams-in-r/
devtools::install_github("corybrunson/ggalluvial")
library(ggalluvial)
countries2<-data.frame(country2010=rep(c('UK','Ireland','Portugal'),each=3),
                       country2015=rep(c('UK','Ireland','Portugal'),3),
                       n=c(18,2,1,3,11,0,1,0,14))
svglite::svglite('4-parallel-sets.svg')
ggplot(countries2,aes(weight=n,axis1=country2010,axis2=country2015)) +
  geom_alluvium(aes(fill=country2015,color=country2015),
                width=1/12,alpha=0.7,knot.pos=0.4) +
  geom_stratum(width=1/6,color="grey") +
  scale_fill_manual(values=c('#45aac4', '#579a04', '#b62525')) +
  scale_color_manual(values=c('#45aac4', '#579a04', '#b62525')) +
  geom_text(stat="stratum",label.strata=TRUE) +
  scale_x_continuous(breaks=1:2,labels=c("2010","2015")) +
  theme_minimal() +
  theme(
    legend.position="none",
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    axis.text.y=element_blank(),
    axis.text.x=element_text(size=18,face="bold")
  )
dev.off()



# Figure 4.9
x<-data.frame(Sex=rep(c('Men','Women'),2),
              Users=rep(c('Yes','No'),each=2),
              size=c(21,58,9,12))
svglite('3-treemap.svg')
treemap(x,index=c('Sex','Users'),vSize='size',type='index')
dev.off()




# Figure 4.10
# I later decided to change the labelling, which was just done manually in the SVG
svglite('3-waffle1.svg')
waffle(c(`Men`=30, `Women`=70), rows=10, size=1, colors=c("#579a04", "#9a0457"))
dev.off()
svglite('3-waffle2.svg')
waffle(c(`Yes`=21, `No`=9), rows=3, size=1, colors=c("#579a04", "#cbfc8d"))
dev.off()
svglite('3-waffle3.svg')
waffle(c(`Yes`=58, `No`=12), rows=7, size=1, colors=c("#9a0457", "#fda0d3"))
dev.off()
# These parts are then combined in Inkscape
