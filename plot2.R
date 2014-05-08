library(data.table)
library(sqldf)

## Set file path
sourceFile<-"./household_power_consumption.txt"
destFile<-"./plot2.png"


## use sql commands to read only part of teh file
mySql <- "SELECT * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
dataSet<-read.csv2.sql(sourceFile,mySql)

## convert data.frame to data.table
dataSet<-as.data.table(dataSet)


## convert Date and Time to single DateTime column of type POSIXct
dataSet[,DateTime:=as.POSIXct(paste0(dataSet$Date,dataSet$Time),format=format("%d/%m/%Y%H:%M:%S"))]

## Set locale to English for plotting
Sys.setlocale("LC_TIME", "en_US.utf8")

## Plot
plot(dataSet$DateTime,dataSet$Global_active_power, type="l",xlab="Weekday-Hour", ylab="Global Active Power (kilowatts)"
)

## Copy screen device to PNG file
if(file.exists(destFile)) file.remove(destFile)
dev.copy(png, file=destFile,width=480,height=480)

## Close the screen device
dev.off()