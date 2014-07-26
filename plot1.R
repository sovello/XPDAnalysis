#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#calculate the sums of emissions for each year, return a list (simplify=F)
emissionSums <- tapply(emissions$Emissions, emissions$year, sum, simplify=F)

#convert the list to a data frame and add a column with the years
emissionDF <- as.data.frame(emissionSums)
emissionDF$Year <- rownames(emissionDF)

##Prepare a png device where to plot the
png(filename="plot1.png", width=480, height=480, units="px")

#plotting
plot(emissionDF$Year,emissionDF$emissionSums, type="l", main="Total Emissions in U.S",
     xlab="Years", ylab="Total Emissions (in tons)")

##close the png device
dev.off()