# plot3.R

datafile <- "household_power_consumption.txt"

# as in book, read column names in first row
names_str   <- readLines( datafile, 1 )
cnames <- strsplit(names_str, ";", fixed = TRUE)
columnnames <- make.names(cnames[[1]])

# having roughly checked appropriate rows in text editor, read enough rows
df <- read.table(datafile, header = TRUE, sep =";", col.names=columnnames, 
                 skip = 66000, nrows = 4000, as.is =TRUE)

library(dplyr)
# proper format for dates 
df <- mutate(df, Date = as.Date(Date, "%d/%m/%Y"))

# retain records of 2007-02-01 and 2007-02-02, must be 24*60 = 2880
df <- filter(df, Date  >= "2007-02-01" & Date  <= "2007-02-02")

# drop column Global_intensity, which is not used for the  plots
df <- select(df, -contains("intensity"))

df <- mutate( df, datetime = paste(Date, Time) )
df$datetime <- strptime(df$datetime, format="%Y-%m-%d %H:%M:%S" ) 

# Plot 3 
png(filename = "plot3.png", width = 480, height = 480, units ="px")
plot ( df$datetime, df$Sub_metering_1, col = 1, 
       xlab = "", ylab = "Energy sub metering", type = 'l')
lines( df$datetime, df$Sub_metering_2, col = 2, type = 'l')
lines( df$datetime, df$Sub_metering_3, col = 4, type = 'l')
legend( "topright" , 
        legend = c("Sub_metering_1", "Sub_metering_2" ,"Sub_metering_3") ,
        col = c(1,2,4), lty = 1 )
dev.off()

