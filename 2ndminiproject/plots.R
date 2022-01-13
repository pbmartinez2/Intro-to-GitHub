
setwd("D:/Desktop/specdata")
HPC <- subset(read.table("household_power_consumption.txt",header = TRUE,
                         sep = ";"),Date %in% c("1/2/2007","2/2/2007"))
date_time <- strptime(paste(HPC$Date, HPC$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
HPC <- cbind(date_time, HPC)

# Constructing Plot #1

hist(as.numeric(HPC$Global_active_power),xlab = "Global Active power(kilowatts)",
     col = "red",main = "Global Active Power")
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()

# Constructing Plot #2

plot(HPC$Global_active_power~HPC$date_time, type="l", 
     ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()

# Constructing Plot #3

with(HPC, {
  plot(Sub_metering_1~date_time, type="l",
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~date_time,col='Red')
  lines(Sub_metering_3~date_time,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png,"plot3.png", width=480, height=480)
dev.off()

# Constructing Plot #4

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(HPC, {
  plot(Global_active_power~date_time, type="l", 
       ylab="Global Active Power", xlab="")
  plot(Voltage~date_time, type="l", 
       ylab="Voltage", xlab="datetime")
  plot(Sub_metering_1~date_time, type="l", 
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~date_time,col='Red')
  lines(Sub_metering_3~date_time,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~date_time, type="l", 
       ylab="Global_reactive_power",xlab="datetime")
})

dev.copy(png,"plot4.png", width=480, height=480)
dev.off()

