# plot2.R

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

# Plot 2
png(filename = "plot2.png", width = 480, height = 480, units ="px")
with(df, plot( datetime, Global_active_power, xlab = "", 
               ylab = "Global Active Power (kilowatts)", type = 'l') )
dev.off()

