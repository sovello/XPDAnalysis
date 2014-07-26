#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#merging the two datasets will return a very large, hard to manage data set in terms of resourses.
#am going to search for the contamination source and return their SCC
vehicleRelated <- codes[codes$EI.Sector %in% grep("vehicle", codes$EI.Sector, perl=T, ignore.case=T, value=T),]

#converting so it is easy to make the comparison
vehicleRelated$SCC <- as.character(vehicleRelated$SCC)

#from emissions, we take those related to motor vehicles but only for Baltimore City (fips == "24510")
vehicleRelatedRecords <- emissions[emissions$SCC %in% vehicleRelated$SCC & emissions$fips == "24510",]

#calculate sums of emissions from vehicle related over the years
vehicleEmissions <- aggregate(vehicleRelatedRecords$Emissions~vehicleRelatedRecords$year, 
                              FUN=sum, data=vehicleRelatedRecords)

##Prepare a png device where to plot the
png(filename="plot5.png", width=480, height=480, units="px")

#plot using the base system
plot(vehicleEmissions[,1], vehicleEmissions[,2], 
     main="Emissions from Motor Vehicle Related Sources",
     sub="Motor Vehicle Emissions in Baltimore City - USA",
     xlab="Years", ylab="Total Emissions (in tons)",
     col="blue", type="s")

##close the png device
dev.off()