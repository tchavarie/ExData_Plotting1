# Create data directory and download Electric power consumption data
if(!file.exists("./data")) {dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/powerConsumption.zip", method="curl")

# Unzip files
unzip("./data/powerConsumption.zip", exdir = "./data")

# Load Electric power consumption data
power <- read.table("./data/household_power_consumption.txt", 
                    na.strings = "NA", sep = ";", header = TRUE)

# Convert the Date field using as.Date   
library(dplyr)
power <- mutate(power, Date = as.Date(power$Date, "%d/%m/%Y"))


# Subset for date range of interest
power.feb <- subset(power, Date >= "2007-02-01" & Date <= "2007-02-02")

# Plot
png(filename = "plot3.png", width = 480, height = 480)
with(power.feb, {
    plot(as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"), as.numeric(as.character(Sub_metering_1)), 
         type = "n", ylab = "Energy sub metering", xlab = "")
    points(as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"), as.numeric(as.character(Sub_metering_1)), type = "l")
    points(as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"), as.numeric(as.character(Sub_metering_2)), type = "l", col = "red")
    points(as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"), as.numeric(as.character(Sub_metering_3)), type = "l", col = "blue")
    legend("topright", lty=c(1,1,1), col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
})
dev.off()



