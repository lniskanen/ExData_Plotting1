library(data.table)
library(sqldf)

## Set file path
sourceFile<-"./household_power_consumption.txt"
destFile<-"./plot1.png"


## use sql commands to read only part of teh file
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
dataSet<-read.csv2.sql(sourceFile,mySql)

## convert data.frame to data.table
dataSet<-as.data.table(dataSet)


## convert Date and Time to single DateTime column of type POSIXct
dataSet[,DateTime:=as.POSIXct(paste0(dataSet$Date,dataSet$Time),format=format("%d/%m/%Y%H:%M:%S"))]

hist(dataSet$Global_active_power,main="Global Active Power",col="red",xlab="Global Active Power (kW)")

## copy from screen device to PNG file with required resolution
if(file.exists(destFile)) file.remove(destFile)
dev.copy(png, file=destFile,width=480,height=480)

## close png deivce
dev.off()


