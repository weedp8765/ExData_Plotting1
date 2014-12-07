## Exploratory Data Analysis - Project 1
## Plot 1: make a histogram of household global minute-averaged active power
##          according to sample file specifications
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

## coerce date field to date datatype for subsetted data table
eData2 <- eData[,Date:=as.Date(strptime(Date,format = "%d/%m/%Y"))]

## coerce all fields except date and time to numeric using the data table
##    expression functionality
eData_converted <- eData2[, lapply(.SD, as.numeric), by=list(Date,Time)]

## activate the png graphics device and specify the parameters of
##    the output file to match the requirements of the assignment sample file
##    (note the sample file is 504x504; however the assignment instructions
##     dictate the file should be 480x480)
png(filename = "plot1.png", width = 480, height = 480, 
    units = "px", bg = "transparent", type = "cairo-png")

## output histogram of global active power, setting parameters for bar colors,
##    the chart title and x-axis label
hist(eData_converted[,Global_active_power], col="red", 
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

## turn off the png graphics device to commit our output
dev.off()