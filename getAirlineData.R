library(rvest)
library(lubridate)
library(stringr)
library(tidyverse)


remove_duplicates <- function(flight_df, airportCode) {
  
  flight_data<- flight_df
  ScrapeTime <- flight_data$ScrapeTime
  ScrapeDate <- flight_data$ScrapeDate
  
  flight_data <- flight_data[, -c(8,9,10)]
  removal_vector <- which(duplicated(flight_data))
  
  flight_data <- flight_data[-removal_vector,]
  ScrapeTime <- ScrapeTime[-removal_vector]
  ScrapeDate <- ScrapeDate[-removal_vector]
  flight_data$ScrapeDate <- ScrapeDate
  flight_data$ScrapeTime <- ScrapeTime
  flight_data$airport <- paste0('K', airportCode)
  length(flight_data)
  names(flight_data)
  return(flight_data)
}


get_air_data  <- function(airportCode) {
  
  setwd(paste0('C:/Users/kkami/Desktop/AIRLINES/', airportCode))
  html <- read_html(paste0("https://flightaware.com/live/airport/", 'K', airportCode))
  MDWx <- html_nodes(html, xpath = '//*[@id="departures-board"]/div/table') %>% html_table(header = TRUE)
  MDWx <- as.data.frame(MDWx)
  names(MDWx) <- c('Flight Code', 'Aircraft', 'Departing To', 'Depart Time', 'x', 'Arrival Time')
  MDWx <- MDWx[c(1,2,3,4,6)] #keep columns from web scrape
  MDWx <- MDWx[-1,] #remove first row of unneeded headings
  
  MDWx <- separate(MDWx, `Depart Time`, c('Depart Time', 'TMZ-D'), sep = '\\s')
  MDWx <- separate(MDWx, `Arrival Time`, c('Arrival Time', 'TMZ-A'), sep = '\\s')
  
  MDWx$`Depart Time` <- as.character(MDWx$`Depart Time`)
  MDWx$`Depart Time` <- paste0(MDWx$`Depart Time`, 'm')
  MDWx$`Depart Time` <- parse_time(MDWx$`Depart Time`, format = '%I:%M%p')
  MDWx$`Depart Time` <- as.character(MDWx$`Depart Time`)
  
  
  MDWx$`Arrival Time` <- as.character(MDWx$`Arrival Time`)
  MDWx$`Arrival Time` <- paste0(MDWx$`Arrival Time`, 'm')
  MDWx$`Arrival Time` <- parse_time(MDWx$`Arrival Time`, format = '%I:%M%p')
  MDWx$`Arrival Time` <- as.character(MDWx$`Arrival Time`)
  
  MDWx$ScrapeDate <- format(Sys.Date(), '%m-%d-%Y')
  MDWx$ScrapeTime <- format(Sys.time(), '%I:%M%p')
  MDWx$Airport <- paste0('K', airportCode)
  
  num_files <- length(list.files(getwd()))
  
  if(num_files == 0) {
    write.csv(MDWx, paste0('K', airportCode, '.csv')) }
  else {
    old_MDWx <- read.csv(paste0('K', airportCode,'.csv'), stringsAsFactors = FALSE) # read in previous data
    old_MDWx <- old_MDWx[,-1] #remove arbitrary number column
    names(old_MDWx) <- names(MDWx) 
    MDWx <- rbind(old_MDWx, MDWx)
    MDWx <- remove_duplicates(MDWx, airportCode)
    write.csv(MDWx, paste0('K', airportCode,'.csv'))
  }
}
scrape_airlines <- function(){
cities <- list.files('C:/Users/kkami/Desktop/AIRLINES')

for(i in 1:length(cities)) {
  
 get_air_data(cities[i])

}
}

scrape_airlines()


