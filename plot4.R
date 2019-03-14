#install.packages("ggplot2")
library(ggplot2)
setwd("C:/Users/willi/OneDrive/Documents/work-rosetta/Data Science Academy/04 - Exploratory Data Analysis/")

str_zip_filename <- "Exercise Data.zip"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
str_input_filename<-"household_power_consumption.txt"

str_output_filename<-"plot4.png"
str_y_axis<-"Energy sub metering"


# #download and extract data from the zip file
# download.file(url, str_zip_filename, mode = "wb")
# unzip(str_zip_filename, files = NULL)

#Read in the data
#energy_data_raw <- read.table(str_input_filename,header=TRUE,sep=";",colClasses=c(rep("character",2),rep("numeric",7)))
energy_data_raw <- read.table(str_input_filename,header=TRUE,sep=";",colClasses = c(rep("character",2),rep("numeric",7)),na.strings = "?")
#convert date format
energy_data_raw$Date<-as.Date(as.character(energy_data_raw$Date),format ="%d/%m/%Y")

#subset the data for the days we want
good_energy_data <- energy_data_raw[energy_data_raw$Date=="2007-02-01"|energy_data_raw$Date=="2007-02-02",]

#add day name column
good_energy_data$DayName<-weekdays(good_energy_data$Date)

#add POSIX timestamp
str_datetime<-paste(good_energy_data$Date,good_energy_data$Time)
str_datetime_fmt <-"%Y-%m-%d %H:%M:%S"
good_energy_data$timestamp<-as.POSIXct(str_datetime,format=str_datetime_fmt)

#map watts to kilowatts
# good_energy_data$Global_active_power_KW<-as.numeric(good_energy_data$Global_active_power)/1000*2


# #map submetering to numerics too
# good_energy_data$Sub_metering_1<-as.numeric(good_energy_data$Sub_metering_1)
# good_energy_data$Sub_metering_2<-as.numeric(good_energy_data$Sub_metering_2)
# good_energy_data$Sub_metering_3<-as.numeric(good_energy_data$Sub_metering_3)

png(str_output_filename,width=480,height=480,units="px")
par(mfrow=(c(2,2)))
#topleft plot
plot(good_energy_data$timestamp,good_energy_data$Global_active_power,type="n",ylab ="Global Active Power")
lines(good_energy_data$timestamp,good_energy_data$Global_active_power)

#topright plot
plot(good_energy_data$timestamp,good_energy_data$Voltage,type="n",xlab="datetime", ylab ="Voltage")
lines(good_energy_data$timestamp,good_energy_data$Voltage)


#bottomleft plot
plot(good_energy_data$timestamp,good_energy_data$Sub_metering_1,type="n",ylab ="Energy sub metering",ylim = c(0,40),yaxt = "n")
axis(2,at=seq(0,30,by=10))
lines(good_energy_data$timestamp,good_energy_data$Sub_metering_1,col="black")
lines(good_energy_data$timestamp,good_energy_data$Sub_metering_2,col="red")
lines(good_energy_data$timestamp,good_energy_data$Sub_metering_3,col="blue")
legend("topright",
       5,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"),
       lty = 1
       #,box.lty = 0
)

#bottomright plot
plot(good_energy_data$timestamp,good_energy_data$Global_reactive_power,type="n",xlab="datetime",ylab ="Global_reactive_power")
lines(good_energy_data$timestamp,good_energy_data$Global_reactive_power)

dev.off()