# Load Libraries
library(tidyverse)
library(tidyr)
library(geosphere)
library(oce)

# Load data files
jan2023_data <- read.csv("/Users/licinio/Desktop/Cyclistic Study Case/DATA/RAW DATA/202301-divvy-tripdata.csv")
feb2023_data <- read.csv("/Users/licinio/Desktop/Cyclistic Study Case/DATA/RAW DATA/202302-divvy-tripdata.csv")
mar2023_data <- read.csv("/Users/licinio/Desktop/Cyclistic Study Case/DATA/RAW DATA/202303-divvy-tripdata.csv")

# Join all data in 1 file
cyclistic_2023<- rbind(jan2023_data, feb2023_data, mar2023_data)

# Check data
View(cyclistic_2023)
head(cyclistic_2023)
colnames(cyclistic_2023)

########## Clean Data ############

#Remove NA values
cyclistic_2023 <- drop_na(cyclistic_2023)

# Separate the dates into month, day, year and day of the week:

cyclistic_2023$date <- as.Date(cyclistic_2023$started_at) 
cyclistic_2023$month <- format(cyclistic_2023$date, "%m")
cyclistic_2023$day <- format(cyclistic_2023$date, "%d")
cyclistic_2023$year <- format(cyclistic_2023$date, "%Y")
cyclistic_2023$day_of_week <- format(cyclistic_2023$date, "%A")


# New columns with the duration of the ride, distance traveled, and speed:

#First the ride lenght in seconds:
cyclistic_2023$started_at <- as.POSIXct(cyclistic_2023$started_at, format = "%Y-%m-%d %H:%M:%S")
cyclistic_2023$ended_at <- as.POSIXct(cyclistic_2023$ended_at, format = "%Y-%m-%d %H:%M:%S")
cyclistic_2023$ride_length <- difftime(cyclistic_2023$ended_at,cyclistic_2023$started_at)

#Then the ride distance traveled in km
cyclistic_2023$ride_distance <- distGeo(matrix(c(cyclistic_2023$start_lng, cyclistic_2023$start_lat), ncol = 2), 
                                            matrix(c(cyclistic_2023$end_lng, cyclistic_2023$end_lat), ncol = 2))
cyclistic_2023$ride_distance <- cyclistic_2023$ride_distance/1000

#At last the speed in Km/h
cyclistic_2023$ride_speed = c(cyclistic_2023$ride_distance)/as.numeric(c(cyclistic_2023$ride_length), units="hours")

# I will remove some columns that will not be necessary for analisys process
cyclistic_2023 <- cyclistic_2023[, !(names(cyclistic_2023) %in% c("start_station_name", "start_station_id", "end_station_name", "end_station_id"))]

# Rename member_casual column to user_type as is better to understand
names(cyclistic_2023)[names(cyclistic_2023) == "member_casual"] <- "user_type"

# Join Latitude and longitude for start and finish of rides
cyclistic_2023$start_coordinates <- paste(cyclistic_2023$start_lat, cyclistic_2023$start_lng, sep = ", ")
cyclistic_2023$end_coordinates <- paste(cyclistic_2023$end_lat, cyclistic_2023$end_lng, sep = ", ")

# Removing some more columns no longer necessary 
cyclistic_2023 <- cyclistic_2023[, !(names(cyclistic_2023) %in% c("start_lat", "start_lng", "end_lat", "end_lng"))]

# There are some values that are negative or 0 that need to be erased in ride lenght this was maybe for error or manutence
cyclistic_2023 <- cyclistic_2023[as.numeric(as.character(cyclistic_2023$ride_length)) > 0, ]

cyclistic_2023 <- cyclistic_2023[as.numeric(as.character(cyclistic_2023$ride_distance)) > 0, ]

cyclistic_2023 <- cyclistic_2023 %>%
  filter(ride_length > 50) # this will remove all rides that were less than 50 seconds as i think rides less than this were not actual rides

cyclistic_2023 <- cyclistic_2023 %>%
  filter(ride_distance > 0.1) # this will remove all rides less than 0.1 kms 

# I will remove some columns that will not be necessary for analisys process
cyclistic_2023 <- cyclistic_2023[, !(names(cyclistic_2023) %in% c("start_station_name", "start_station_id", "end_station_name", "end_station_id"))]

# Finally i will save the csv cleaned file
write.csv(cyclistic_2023, "/Users/licinio/Desktop/Cyclistic Study Case/DATA/cyclistic_2023_cleaned_v4.csv", row.names = FALSE)


####### Starting the Analysis ########

# Calculate the average ride length by user type
avg_ride_length <- cyclistic_2023 %>%
  group_by(user_type) %>%
  summarize(avg_ride_length = mean(ride_length))

# Create a bar plot of average ride length by user type
ggplot(avg_ride_length, aes(x = user_type, y = avg_ride_length, fill = user_type)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Ride Length by User Type",
       x = "User Type",
       y = "Average Ride Length (seconds)",
       fill = "User Type")

# Calculate the average ride distance by user type and month
avg_ride_distance <- cyclistic_2023 %>%
  group_by(user_type, month) %>%
  summarize(avg_ride_distance = mean(ride_distance))

ggplot(avg_ride_distance, aes(x = month, y = avg_ride_distance, fill = user_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Ride Distance by User Type and Month",
       x = "Month",
       y = "Average Ride Distance (meters)",
       fill = "User Type")

# Group the data by user_type and day_of_week, and count the number of rides
days_order <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
rides_by_day <- cyclistic_2023 %>%
  group_by(user_type, day_of_week) %>%
  summarize(total_rides = n()) %>%
  mutate(day_of_week = factor(day_of_week, levels = days_order))

# Create a stacked bar plot of rides by day of week and user type
ggplot(rides_by_day, aes(x = day_of_week, y = total_rides, fill = user_type)) +
  geom_bar(position = "dodge", stat = "identity", width = 0.8) +
  labs(title = "Number of Rides by Day of Week and User Type",
       x = "Day of Week",
       y = "Number of Rides",
       fill = "User Type")

ride_frequency <- cyclistic_2023 %>%
  group_by(user_type) %>%
  count()

ride_frequency


ride_frequency_day <- cyclistic_2023 %>%
  group_by(user_type, day_of_week) %>%
  count()

ggplot(ride_frequency_day, aes(x = day_of_week, y = n, fill = user_type)) +
  geom_col(position = "dodge") +
  labs(x = "Day of Week", y = "Total Rides", fill = "User Type") +
  scale_x_discrete(limits = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")) +
  theme_bw()

ride_frequency_hour <- cyclistic_2023 %>%
  group_by(user_type, hour = hour(started_at)) %>%
  count()

ggplot(ride_frequency_hour, aes(x = hour, y = n, color = user_type)) +
  geom_line() +
  labs(x = "Hour of Day", y = "Total Rides", color = "User Type") +
  theme_bw()