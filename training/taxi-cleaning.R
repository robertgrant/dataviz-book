library(readr)
library(dplyr)
library(lubridate)

trips<-read_csv('trips.csv')
trips<-select(trips,medallion,pickup_datetime,pickup_longitude,pickup_latitude,
              trip_time_in_secs)
fares<-read_csv('fares.csv')
fares<-select(fares,medallion,pickup_datetime,fare_amount,tip_amount)
taxi<-inner_join(trips,fares) # watch out for duplicates
rm(trips)
rm(fares)
taxi <- taxi %>% rename(long=pickup_longitude, lat=pickup_latitude)

######################  choose outcome  #######################

taxi<-taxi %>%
  filter(fare_amount>0 | tip_amount>0) %>%
  mutate(total=log(fare_amount+tip_amount))


# drop gross GPS errors
taxi<-filter(taxi,between(long,(-74.3),(-73.5)) &
               between(lat,40.5,41))

# split up dates and times
taxi %>% mutate(hr=lubridate::hour(pickup_datetime)) %>% 
  mutate(mo=lubridate::month(pickup_datetime,label=TRUE)) %>% 
  mutate(day=lubridate::wday(pickup_datetime,label=TRUE)) -> taxi