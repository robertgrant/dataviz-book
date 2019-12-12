library(readr)
library(dplyr)
library(ggplot2)
library(forcats)
library(svglite)

km2 <- read_csv("kmunicate-image-2.csv")
km2$percent[km2$response=="less"] <- 
     km2$percent[km2$response=="less"] * -1
km2$option <- as_factor(km2$option)
km2$option <- fct_relevel(km2$option,
                          levels=c("risk_exttable",
                                   "risk_areas_beneath",
                                   "risk_lines_beneath",
                                   "risk_areas_behind",
                                   "unce_confint",
                                   "unce_fading"))
fct_recode(km2$option, 
           ET="risk_exttable",
           AU="risk_areas_beneath",
           LU="risk_lines_beneath",
           AB="risk_areas_behind",
           CI="unce_confint",
           FA="unce_fading") -> km2$option

svglite("km-image-2.svg")
ggplot(data=km2,aes(index)) + 
  geom_col(data=subset(km2,response=="more"), 
           aes(y=percent, fill="#f48345")) + 
  geom_col(data=subset(km2,response=="less"), 
           aes(y=percent, fill="#8AD4FF")) +
  labs(x="", y="% Votes") +
  ggtitle("Does training in data analysis affect opinions?") +
  theme(legend.position="none") +
  theme_classic() +
  scale_x_continuous(breaks=c(1.5,4.5,7.5,10.5, 14.5,17.5),
                     labels=c("ET","AU","LU","AB","CI","FA"))
dev.off()

#  
