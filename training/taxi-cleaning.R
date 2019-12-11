library(readr)
library(dplyr)
library(lubridate)

trips<-read_csv('trips.csv')
trips<-select(trips,medallion,pickup_datetime,pickup_longitude,pickup_latitude,
              trip_time_in_secs)

trips %>% select(medallion,pickup_datetime,pickup_longitude,pickup_latitude,
              trip_time_in_secs) -> trips

fares<-read_csv('fares.csv')
fares<-select(fares,medallion,pickup_datetime,fare_amount,tip_amount)
taxi<-inner_join(trips,fares) # watch out for duplicates
rm(trips)
rm(fares)
taxi <- rename(taxi, long=pickup_longitude, lat=pickup_latitude)


library(inspectdf)
inspect_cat(taxi)
inspect_num(taxi)
inspect_na(taxi)

hist(taxi$long)
hist(taxi$lat)

plot(taxi$long, taxi$lat)

hist(taxi$trip_time_in_secs)

######################  choose outcome  #######################


hist(taxi$fare_amount, breaks=50)

taxi %>% filter(fare_amount<250) -> temp

hist(temp$fare_amount)



taxi %>%
  filter(fare_amount>0 | tip_amount>0) %>%
  mutate(total=log(fare_amount+tip_amount)) -> taxi

hist(taxi$total, breaks=30)

# drop gross GPS errors
taxi<-filter(taxi,between(long,(-74.3),(-73.5)) &
               between(lat,40.5,41))

# split up dates and times
taxi %>% mutate(hr=hour(pickup_datetime)) %>% 
  mutate(mo=month(pickup_datetime,label=TRUE)) %>% 
  mutate(day=wday(pickup_datetime,label=TRUE)) -> taxi

