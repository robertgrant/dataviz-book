library(readr)
library(dplyr)
library(ggplot2)
library(forcats)
library(svglite)

km1 <- read_csv("kmunicate-image-1.csv")
km1 %>% rename(votecount=exttable) -> km1
km1$votecount[km1$response=="less"] <- 
     km1$votecount[km1$response=="less"] * -1
km1$option <- as_factor(km1$option)
km1$option <- fct_relevel(km1$option,
                          levels=c("exttable",
                                   "areas_beneath",
                                   "lines_beneath",
                                   "areas_behind",
                                   "confint",
                                   "fading"))
fct_recode(km1$option, 
           ET="exttable",
           AU="areas_beneath",
           LU="lines_beneath",
           AB="areas_behind",
           CI="confint",
           FA="fading") -> km1$option

svglite("km-image-1.svg")
ggplot(data=km1,aes(as.factor(option))) + 
  geom_col(data=subset(km1,response=="more"), 
           aes(y=votecount, fill="#f48345")) + 
  geom_col(data=subset(km1,response=="less"), 
           aes(y=votecount, fill="#8AD4FF")) +
  labs(x="", y="Votes") +
  ggtitle("Are these options more or less useful \n than the standard KM plot?") +
  theme(legend.position="none") +
  theme_classic()
dev.off()

  scale_y_continuous(breaks=seq(-40,40,10),labels=abs(seq(-40,40,10))) + 
