library(dplyr)

## First we Read the dataset from the original folder
## using the colClasses parameter to assign the classes of each column.
## We will use character in the first two (Date and Time)
## as it will be easier to use them later
hpc <- read.table("./exdata%2Fdata%2Fhousehold_power_consumption/household_power_consumption.txt", 
                  sep = ";", 
                  header = TRUE, 
                  colClasses = c("character", "character", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", "numeric"), 
                  na.strings = "?")

## Then we set the Timestamp just as dd/mm/yyyy using the column Date
mydf <- mutate(hpc, Timestamp = as.Date(Date, format="%d/%m/%Y"))

## Then we use the Timestamp to Filter the dataframe 
## to use only with the measurements from 2007-02-01 and 2007-02-02
mydf <- filter(mydf, (Timestamp=="2007-02-01") | (Timestamp=="2007-02-02"))

## Then we include the Time of the measurements into the Timestamp column
mydf <- transform(mydf, 
                  Timestamp = strptime(paste(as.character(Date), as.character(Time)), 
                                       "%d/%m/%Y %H:%M:%S"))


## Now that we have cleaned the dataset, 
## we can plot the Energy Sub_metering by day graph

## First we set the device to png
png("plot3.png", width=480, height=480)

## Then we plot the Global Active Power by day graph 
## to the selected device
## Note: type = "l" is for line plots
plot( x=mydf$Timestamp, 
      y=mydf$Sub_metering_1, 
      type="l", 
      xlab= "", 
      ylab = "Energy sub metering",
      col = "black")
lines( x=mydf$Timestamp, 
      y=mydf$Sub_metering_2, 
      col = "red")
lines( x=mydf$Timestamp, 
       y=mydf$Sub_metering_3, 
       col = "blue")
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, 
       lwd=2.5, 
       col=c("black", "red", "blue"))

## And finnaly, we close the device
dev.off()

## Now you should have a file named "plot3.png" in your working directory