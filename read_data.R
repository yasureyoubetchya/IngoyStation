library(zoo)
library(dplyr)
library(dplR)
library(lubridate)
library(ggplot2)
library(scales)

# sourcedata had to be correctly reformatted to tab deliminted.  Originally downloaded from IMR comes as fixed width.

# make list of file names
fnames = list.files('Ingoy Station (feb18)/')

# read in and paste all data together
data <- do.call("rbind", lapply(fnames, function(x) read.table(paste('Ingoy Station (feb18)/', x, sep=''), 
                                                               skip=1, sep='\t', na.strings = " ")))
# change variable names
names(data) = c('Stasjon','Dato','Dyp','Temperatur','Salt','Kal_temperatur','Kal_salt')

# modify date column
data$Dato = as.Date(factor(data$Dato), '%d.%m.%Y')
class()

data %>%
  filter(Kal_temperatur > 1.5) %>%
  ggplot(aes(x=Dato, y=Kal_temperatur, group=Dyp, color=Dyp)) + geom_line() +
  scale_x_date(date_breaks = "3 month", 
               labels=date_format("%b.%y"),
               limits = as.Date(c('2000-03-01','2018-01-01')))

# the following code works expect need to require certain % data points per yr
data %>%
  filter(Kal_temperatur > 1.5) %>%
  mutate(year=year(Dato)) %>%
  group_by(year, Dyp) %>%
  summarize(ann_mean = mean(Kal_temperatur)) %>%
  ggplot(aes(x=year, y=ann_mean, group=Dyp, color=Dyp)) + geom_line()

