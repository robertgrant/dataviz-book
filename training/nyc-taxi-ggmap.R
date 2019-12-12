library(readr)
library(ggmap)
library(viridis)

taxi <- read_csv("taxi.csv")

# get NYC maps
nycmap<-get_map(location=c(lon=(-73.9),lat=40.7),zoom=11,color='bw',
                source='stamen')
centralmap<-get_map(location=c(lon=(-73.97),lat=40.76),zoom=12,color='bw')

# these require ggmapstyles:
# snaz<-'https://snazzymaps.com/style/1261/dark'
# nycmap<-get_snazzymap(center=c(lon=(-73.9),lat=40.7),zoom=11,mapRef=snaz)
# centralmap<-get_snazzymap(center=c(lon=(-73.97),lat=40.74),zoom=12,mapRef=snaz)

# or you can just load the ready-made version:
load('maps.RData')

# count ("length") of journeys
nycmap %>%
  ggmap(darken=0.5)+
  stat_summary_2d(data=taxi,
                  aes(x=long,y=lat,z=total),
                  alpha=0.6,
                  bins=c(100,100),
                  fun="length")+
  scale_fill_viridis(option="plasma")+
  labs(x="Longitude",
       y="Latitude",
       fill="Journeys")


# mean of total ( log fare + tip)
nycmap %>%
  ggmap(darken=0.5)+
  stat_summary_2d(data=taxi,
                  aes(x=long,y=lat,z=total),
                  alpha=0.6,
                  bins=c(100,100),
                  fun="mean")+
  scale_fill_viridis(option="plasma")+
  labs(x="Longitude",
       y="Latitude",
       fill="Log fare+tip")


# bespoke function discarding squares with fewer than 10 journeys
centralmap %>%
  ggmap(darken=0.5)+
  stat_summary_2d(data=taxi,
                  aes(x=long,y=lat,z=total),
                  alpha=0.8,
                  bins=c(60,60),
                  fun=function(x){ifelse(length(x)>9,mean(x),NA)})+
  scale_fill_viridis(option="plasma",limits=c(2.2,3.2))+
  labs(x="Longitude",
       y="Latitude",
       fill="Log fare+tip")+
  ggtitle("New York taxis, 2013",
          subtitle="Where can drivers earn more money per journey?")
