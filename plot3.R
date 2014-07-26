#load the plotting library
library(ggplot2)
#read in the data
emissions <- readRDS("summarySCC_PM25.rds")
codes <- readRDS("Source_Classification_Code.rds")

#extract data for Baltimore City with fips == "24510"
baltimoreEmissions <- emissions[emissions$fips == 24510,]

#calculate the sums of emissions for each year

emissionSums <- aggregate(baltimoreEmissions$Emissions ~ baltimoreEmissions$type + baltimoreEmissions$year, 
                          data=baltimoreEmissions, FUN=sum)
colnames(emissionSums) <- c("type", "year", "Emissions")

##Prepare a png device where to plot the
png(filename="plot3.png", width=480, height=480, units="px")

#create the plot and assign to a variable, as ggplot doesn't save directly
emissionPlot <- ggplot()+facet_wrap(~type)+layer(data=emissionSums, mapping=aes(x=year,y=Emissions), geom="line")

#print the plot so that it is saved
print(emissionPlot)

##close the png device
dev.off()