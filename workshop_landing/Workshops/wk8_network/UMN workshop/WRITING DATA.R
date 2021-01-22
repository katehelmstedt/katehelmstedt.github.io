####################################################
## WRITING DATA FOR ALL GRAPHING AND METRICS #######
# AKeyes - November 27, 2018 #######################

setwd("~/Dropbox/Aislyn_MS/Salt Marsh Project")

# load libraries
library(readr)
library(dplyr)

# Load data
Nodes <- read_csv("CSMweb_Nodes.csv")
ES = read_csv("CSM_ES.csv")
Nodes.new = read.csv("NewCSM_Nodes.csv", header=T, as.is=T)
Edges = read.csv("CSMweb_Links.csv", header=T)

##################################################################################
##### MERGING NODE DATA WITH ES ##################################################
##################################################################################

# Filter data to only include rows (nodes) with adults (StageID==1) and freeliving species (Lifestyle.stage == "free-living) 
Nodes1 = filter(Nodes, StageID == 1)
Nodes1 = filter(Nodes1, Lifestyle.stage == 'free-living')

# Merge filtered food web (Nodes1) with ES data 
New_Nodes = merge(x = Nodes1 , y = ES , by = "SpeciesID", all.x = T)

#Check new data frame for NAs in services
table(New_Nodes$`Wave Attenuation`)
table(New_Nodes$'Shoreline Stabilization')
table(New_Nodes$`Water Filtration`)
table(New_Nodes$`Carbon Sequestration`)

### No NAs, change -1 to 0 for all services
### Add columns to have service values with only 1 or 0 (reassigning -1 to 0)
#Create new column for Wave Attenuation
New_Nodes$WaveAttenuation.New = New_Nodes$`Wave Attenuation`
#Change values in new column (-1 to 0)
New_Nodes$WaveAttenuation.New[New_Nodes$`Wave Attenuation`==-1]=0
New_Nodes$WaveAttenuation.New[New_Nodes$`Wave Attenuation`==1]=1

#Create new column for Shoreline Stabilization
New_Nodes$ShorelineStabilization.New = New_Nodes$`Shoreline Stabilization`
#Change values in new column (-1 to 0)
New_Nodes$ShorelineStabilization.New[New_Nodes$`Shoreline Stabilization`==-1]=0
New_Nodes$ShorelineStabilization.New[New_Nodes$`Shoreline Stabilization`==1]=1

#Create new column for Water Filtration
New_Nodes$WaterFiltration.New = New_Nodes$`Water Filtration`
#Change values in new column (-1 to 0)
New_Nodes$WaterFiltration.New[New_Nodes$`Water Filtration`==-1]=0
New_Nodes$WaterFiltration.New[New_Nodes$`Water Filtration`==1]=1

#Create new column for Carbon Sequestration
New_Nodes$CarbonSequestration.New = New_Nodes$`Carbon Sequestration`
#Change values in new column (-1 to 0)
New_Nodes$CarbonSequestration.New[New_Nodes$`Carbon Sequestration`==-1]=0
New_Nodes$CarbonSequestration.New[New_Nodes$`Carbon Sequestration`==1]=1


#Check for -1s in services
table(New_Nodes$WaveAttenuation.New)
table(New_Nodes$ShorelineStabilization.New)
table(New_Nodes$WaterFiltration.New)
table(New_Nodes$CarbonSequestration.New)

## If all -1 are 0 and there are no NAs, write to csv
### Write to csv - make sure to include detailed file name
write.csv(New_Nodes, "NewCSM_Nodes.csv")

######################################################################################################
###### FILTERING EDGES DATA WITH TO MATCH NEW NODES ##################################################
######################################################################################################

### We want to only include species in edges that are in nodes, filter:
# Filter edges to only include ResourceSpeciesID that match nodes$SpeciesID 
table.r = Edges %>%
  filter(ResourceSpeciesID %in% Nodes.new$SpeciesID)

# Filter table.r to only include ConsumerSpeciesID that match nodes$SpeciesID 
table.c = table.r %>%
  filter(ConsumerSpeciesID %in% Nodes.new$SpeciesID)


### Make 2 new data frames that have (1) nodes and (2) links with only these columns
node.ID = Nodes.new[,2]
head(node.ID)
edges.filtered = table.c[,c(8,7)]
head(edges.filtered)

### Write to csv - make sure to include detailed file name
write.csv(edges.filtered, "CSM.edges.filtered.csv")
write.csv(node.ID, "CSM_Nodes_Only.csv")


######################################################################################################
###### SIMPLE ES DATA FRAME WITH FILTERED NODES  #####################################################
######################################################################################################

ES.df = Nodes.new[,c(2,52:55)]
head(ES.df)

# Write to csv - make sure to include detailed file name
write.csv(ES.df, "CSM_ESsimple.csv")
