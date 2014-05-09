library(data.table)
library(sqldf)

## Set file path
sourceFile<-"./household_power_consumption.txt"
destFile<-"./plot4.png"


## use sql commands to read only part of teh file
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
dataSet<-read.csv2.sql(sourceFile,mySql)

## convert data.frame to data.table
dataSet<-as.data.table(dataSet)


## convert Date and Time to single DateTime column of type POSIXct
dataSet[,DateTime:=as.POSIXct(paste0(dataSet$Date,dataSet$Time),format=format("%d/%m/%Y%H:%M:%S"))]

## Set locale to English for plotting
Sys.setlocale("LC_TIME", "en_US.utf8")


par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(1, 1, 1, 1))

with(dataSet,{

  ## Plot 1,1
  plot(dataSet$DateTime,dataSet$Global_active_power, type="l",xlab="Weekday-Hour", 
       ylab="Global Active Power (kilowatts)")
  
  ## Plot 1,2
  plot(dataSet$DateTime,dataSet$Voltage,type="l",ylab="Voltage",xlab="datetime",col="black")
  
  ## Plot 2,1
  with(dataSet, plot(dataSet$DateTime,dataSet$Sub_metering_1,type="l",col="black",ylab="Energy sub metering", xlab=" "))
  with(subset(dataSet), lines(dataSet$DateTime,dataSet$Sub_metering_2,type="l",col="red"))
  with(subset(dataSet), lines(dataSet$DateTime,dataSet$Sub_metering_3,type="l",col="blue"))
  legend("topright", box.lwd = 0,box.col = "white",lty= c(1), col = c("black", "red","blue"), legend =c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
  
  
  ## Plot 2,2
  plot(dataSet$DateTime,dataSet$Global_reactive_power,type="l",ylab="Global_reactive_power",xlab="datetime",col="black",bty="n")
  
})

## Copy screen device to PNG file
if(file.exists(destFile)) file.remove(destFile)
##dev.copy(png, file=destFile,width=480,height=480)
png(destFile, width=480, height=480)

## re-plot for png screen

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(1, 1, 1, 1))

with(dataSet,{
  
  ## Plot 1,1
  plot(dataSet$DateTime,dataSet$Global_active_power, type="l",xlab="Weekday-Hour", 
       ylab="Global Active Power (kilowatts)")
  
  ## Plot 1,2
  plot(dataSet$DateTime,dataSet$Voltage,type="l",ylab="Voltage",xlab="datetime",col="black")
  
  ## Plot 2,1
  with(dataSet, plot(dataSet$DateTime,dataSet$Sub_metering_1,type="l",col="black",ylab="Energy sub metering", xlab=" "))
  with(subset(dataSet), lines(dataSet$DateTime,dataSet$Sub_metering_2,type="l",col="red"))
  with(subset(dataSet), lines(dataSet$DateTime,dataSet$Sub_metering_3,type="l",col="blue"))
  legend("topright",box.lwd = 0,box.col = "white", lty= c(1), col = c("black", "red","blue"),
         legend =c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
  
  
  ## Plot 2,2
  plot(dataSet$DateTime,dataSet$Global_reactive_power,bty="n",type="l",
       ylab="Global_reactive_power",xlab="datetime",col="black",bty="n")
  
})


## Close the screen device
dev.off()





