#load the plotting library
library(ggplot2)

#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#merging the two datasets will return a very large, hard to manage data set in terms of resourses.
#am going to search for the contamination source and return their SCC
vehicleRelated <- codes[codes$EI.Sector %in% grep("vehicle", codes$EI.Sector, perl=T, ignore.case=T, value=T),]

#converting so it is easy to make the comparison
vehicleRelated$SCC <- as.character(vehicleRelated$SCC)

#emission for Baltimore City (fips == "24510") & Los Angeles County, California (fips == "06037")
vehicleRelatedRecords <- emissions[emissions$SCC %in% vehicleRelated$SCC & emissions$fips %in% c("24510","06037"),]

#calculate sums of emissions from vehicle related over the years
vehicleEmissions <- aggregate(vehicleRelatedRecords$Emissions 
                              ~ vehicleRelatedRecords$fips + vehicleRelatedRecords$year, 
                              FUN=sum, data=vehicleRelatedRecords)
colnames(vehicleEmissions) <- c("fips", "year", "Emissions")

##replace for real names
vehicleEmissions$fips <- replace(vehicleEmissions$fips, vehicleEmissions$fips=="24510", "Baltimore City")
vehicleEmissions$fips <- replace(vehicleEmissions$fips, vehicleEmissions$fips=="06037", "Los Angeles County")

##Prepare a png device where to plot the
png(filename="plot6.png", width=480, height=480, units="px")

#create the plot and assign to a variable, as ggplot doesn't save directly
comparisonPlot <- ggplot()+facet_wrap(~fips)+layer(data=vehicleEmissions, mapping=aes(x=year,y=Emissions), geom="line")

#print the plot so that it is saved
print(comparisonPlot)

##close the png device
dev.off()