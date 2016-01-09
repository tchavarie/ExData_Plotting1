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
# Convert factor fields needed for plots to numeric
# Create new concatenated Date / Time field dt
library(dplyr)
power <- mutate(power, 
                Date = as.Date(power$Date, "%d/%m/%Y"), 
                Global_active_power = as.numeric(as.character(Global_active_power)), 
                Global_reactive_power = as.numeric(as.character(Global_reactive_power)), 
                Sub_metering_1 = as.numeric(as.character(Sub_metering_1)),
                Sub_metering_2 = as.numeric(as.character(Sub_metering_2)),
                Sub_metering_3 = as.numeric(as.character(Sub_metering_3)),
                Voltage = as.numeric(as.character(Voltage)),
                dt = as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S")
                )


# Subset for date range of interest
power.feb <- subset(power, Date >= "2007-02-01" & Date <= "2007-02-02")

png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))
with(power.feb, plot(dt, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))

with(power.feb, plot(dt, Voltage, type = "l", ylab = "Voltage", xlab = "datetime"))

with(power.feb, {
    plot(dt, Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
    points(dt, Sub_metering_1, type = "l")
    points(dt, Sub_metering_2, type = "l", col = "red")
    points(dt, Sub_metering_3, type = "l", col = "blue")
    legend("topright", lty=c(1,1,1), col = c("black","red","blue"), 
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
})

with(power.feb, plot(dt, Global_reactive_power, type = "l", xlab = "datetime"))

dev.off()



