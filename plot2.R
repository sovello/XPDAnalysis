#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#extract data for Baltimore City with fips == "24510"
baltimoreEmissions <- emissions[emissions$fips == 24510,]

#calculate the sums of emissions for each year
emissionSums <- tapply(baltimoreEmissions$Emissions, baltimoreEmissions$year, sum, simplify=F)

emissionDF <- as.data.frame(emissionSums)

emissionDF$Year <- rownames(emissionDF)

##Prepare a png device where to plot the
png(filename="plot2.png", width=480, height=480, units="px")


plot(emissionDF$Year,emissionDF$emissionSums, type="l", main="Baltimore City Emissions",
     xlab="Years", ylab="Total Emissions (in tons)")

##close the png device
dev.off()