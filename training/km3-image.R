library(readr)
library(dplyr)
library(ggplot2)
library(forcats)
library(svglite)

km3 <- read_csv("kmunicate-image-3.csv")

km3<- rename(km3,votecount=count)

km3$option <- as_factor(km3$option)
km3$option <- fct_relevel(km3$option,
                          levels=c("risk_reference",
                                   "risk_exttable",
                                   "risk_areas_beneath",
                                   "risk_lines_beneath",
                                   "risk_areas_behind",
                                   "unce_standard",
                                   "unce_confint",
                                   "unce_fading"))
fct_recode(km3$option, 
           KM1="risk_reference",
           ET="risk_exttable",
           AU="risk_areas_beneath",
           LU="risk_lines_beneath",
           AB="risk_areas_behind",
           KM2="unce_standard",
           CI="unce_confint",
           FA="unce_fading") -> km3$option

# define colors
himmelblau <- c("1" = "#8AD4FF",
                "2" = "#0089d8",
                "3" = "#004b76")

svglite("km-image-3.svg")
ggplot(km3, aes(index, fill=as.factor(choice))) +
  geom_col(aes(y=votecount)) + 
  coord_flip() + 
  theme_classic() + 
  labs(x="", y="Votes") +
  scale_x_reverse(breaks=c(2,6,10,14,18,23,27,31),
                  labels=c("ET","AU","KM","AB","LU",
                           "CI","KM","FA")) +
  scale_fill_manual(values=himmelblau) +
  ggtitle("Missing preference data are not big enough \n to change the conclusions")
dev.off()