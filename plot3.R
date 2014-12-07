## Exploratory Data Analysis - Project 1
## Plot 3: make a line plot including all 3 series of sub-metering data,
##          using differing colors, according to sample file specifications
## NOTE: script makes use of data.table library to load and subset dataset


## set URL for file download, then download and unzip in working directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = fileUrl, destfile = "./household_power_consumption.zip")
unzip("./household_power_consumption.zip")


## use fread to rapidly load file into memory
energy_data_all <- fread("household_power_consumption.txt", na.strings = "?")

## subset energy data for the 2 dates were are interested in  plotting
##    (i.e., Feb 1 and Feb 2, 2007)
eData <- energy_data_all[energy_data_all$Date == "1/2/2007" | 
                               energy_data_all$Date == "2/2/2007", ]

## add Datetime field to coerce date and time strings to POSIXct 
##    datatype for subsetted data table
eData2 <- eData[,DateTime:=as.POSIXct(strptime(paste(Date,Time,sep = " "),
                                               format = "%d/%m/%Y %H:%M:%S"))]

## coerce all fields except date and time to numeric using the data table
##    expression functionality
eData_converted <- eData2[, lapply(.SD, as.numeric), by=list(Date,Time,DateTime)]

## activate the png graphics device and specify the parameters of
##    the output file to match the requirements of the assignment sample file
##    (note the sample file is 504x504; however the assignment instructions
##     dictate the file should be 480x480)
png(filename = "plot3.png", width = 480, height = 480, 
    units = "px", bg = "transparent", type = "cairo-png")

## output plot area without actual points, which will be added next;
##    removing the default x-axis label, and including a y-axis label
plot(x = eData_converted$DateTime,
     y = eData_converted$Sub_metering_1, 
     xlab = "",
     ylab = "Energy sub metering",
     type = "n")

## add first line for Sub_metering_1, setting color to black
points(x = eData_converted$DateTime,
       y = eData_converted$Sub_metering_1,
       col = "black", type = "l")

## add second line for Sub_metering_1, setting color to red
points(x = eData_converted$DateTime,
       y = eData_converted$Sub_metering_2,
       col = "red", type = "l")

## add third line for Sub_metering_1, setting color to blue
points(x = eData_converted$DateTime,
       y = eData_converted$Sub_metering_3,
       col = "blue", type = "l")

## add legend in top right of plot
legend("topright", col = c("black","red","blue"), lty=1,
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

## turn off the png graphics device to commit our output
dev.off()