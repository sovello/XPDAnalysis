#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#merging the two datasets will return a very large, hard to manage data set in terms of resourses.
#am going to search for the contamination source and return their SCC
coalRelated <- codes[codes$EI.Sector %in% grep("coal", codes$EI.Sector, perl=T, ignore.case=T, value=T),]

#converting so it is easy to make the comparison
coalRelated$SCC <- as.character(coalRelated$SCC)

#now, am going to return all the records from emissions that have their SCC in the subset SCC from coalRelated
coalRelatedRecords <- emissions[emissions$SCC %in% coalRelated$SCC,]

#calculate sums of emissions from coal related over the years
coalEmissions <- aggregate(coalRelatedRecords$Emissions~coalRelatedRecords$year, FUN=sum, data=coalRelatedRecords)

##Prepare a png device where to plot the
png(filename="plot4.png", width=480, height=480, units="px")

#plot using the base system
plot(coalEmissions[,1], coalEmissions[,2], 
     main="Emissions from Coal Combustion Related Sources",
     xlab="Years", ylab="Total Emissions (in tons)",
     col="blue", type="s")

##close the png device
dev.off()