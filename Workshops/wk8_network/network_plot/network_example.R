############ DATA VISUALIZATION ############ 
# R-Ladies meeting
# 28 February 2019
# Example of how to make a network plot 
# By Geraldine Klarenberg
# For this exercise we're plotting causality networks (explained in the code a little bit later on;
# not too much detail)

# From http://kateto.net/network-visualization
# See this website for reference guidelines

rm(list=ls(all=TRUE)) 

install.packages("igraph") 
install.packages("network") 
install.packages("visNetwork")
install.packages("threejs")
install.packages("networkD3")

library("igraph") 
library("network") 
library("visNetwork")
library("threejs")
library("networkD3")

# Potential other options for network plots are ggnet2 or ggnetwork

# NOTE: set your working directory to source file location !!!!

# Load the data. This is data on which I did a Granger causality test (a type of statistical test to determine
# causality).
Granger_data <- read.csv("selectGranger_cl2.csv")

# have a look at the data
head(Granger_data)

# this currently a long list, select only the ones with significant causality (p < 0.05) and conditional G analysis
# (the detail on why is not important for this plotting exercise)
sign_Granger_data <- subset(Granger_data, prob <= 0.05 & type=="cond")

# have a look at the data
head(sign_Granger_data)
# the abbreviations in column 2 and 3 are environmental variables (eg MEANT =  mean temperature, MINT =
# minimum temperature, EVI = enhanced vegetation index, SR = species richness etc), and the meaning of the
# dataset is that the analysis indicates the variable in column 2 "causes" the variable in column 3. Now we
# want to show that as a network, with arrows going from the variables in column 2 to the variables in
# column 3.

# we need to change colnames; this is actually required by the package we're using to plot
names(sign_Granger_data)[2] <- "from"
names(sign_Granger_data)[3] <- "to"
names(sign_Granger_data)[6] <- "weight" # change "prob" to "weight" we can use it later on in giving
# importance to certain connections

# have a look at the data again
head(sign_Granger_data)

# save only the data we need: the to-from information, plus the probability (weight)
sign_Granger_data <- data.frame(sign_Granger_data$from,
                                sign_Granger_data$to,
                                sign_Granger_data$weight)

######### TERMINOLOGY
# Nodes are the things you are connecting
# Vertices are the connections

# You need to make a dataframe with your nodes. Note that you can't have names in here that are not being used.
# You'll get an error in "graph_from_data_frame" later on
# id is what the variable is called in your data set, and name is what will show in the plot. I tried at
# first to write names out in full in the plot but it became too crowded so I stuck with the abbreviations
Granger_names=data.frame(cbind(c("EVI", "MAXT","MEANT","MINT","P","PET","SM","SR","AMO","PDO","MEI"),
                               c("EVI", "MAXT","MEANT","MINT","P","PET","SM","SR","AMO","PDO","MEI")))
names(Granger_names)=c("id","name")
# have a look
head(Granger_names)

# Now make a "network dataframe" out of the information we have
# d is the symbolic edge list in first 2 cols, vertices is a dataframe with vertex metadata
Granger_net <- graph_from_data_frame(d = sign_Granger_data,
                                     vertices = Granger_names,
                                     directed=TRUE) # we want arrows
# have a look at this new dataframe, it'll show you the directionality
Granger_net
# if you want to test if your weights were preserved, run:
# as_data_frame(Granger_net,what="edges")
# if there is a column called sign_Granger_data.weight, you're good

#################### Plot the network

# We can make the nodes different sizes and the vertices different widths, based on certain
# data characteristics. We'll make 3 plots: 
# 1) a network where all nodes and vertices have the same size
# 2) a network where some arrows have a different color
# 3) a network with different sized nodes and vertices

# Set the node size
V(Granger_net)$size<-25
# Set the vertice widths
E(Granger_net)$width <- 4

# I want to plot this with a circle layout. There are different layouts available. If you don't
# specify a layout, I think the function will try to place the nodes in the plot in such a way that the 
# connections look okay/optimized. It could also be random; not sure.
# If you type ?layout_with_ in the prompt, RStudio will autofill and show you all the options of layouts
l <- layout_in_circle(Granger_net)

# With naming and coloring nodes - the plot starts with EVI at 3 o'clock (as the location on the circle) 
# and goes counter clockwise over the names listed the list Granger_names

pdf("Granger_network.pdf",width=10,height=7)
plot(Granger_net, # call the data
     layout=l, # define the layout
     edge.color="black", # set the vertice (arrow) colors
     vertex.color=c("darkolivegreen4","coral2","plum2","skyblue2","#003F7F","aquamarine3","burlywood3","mintcream","thistle4","thistle1","thistle3"), # set node colors 
     vertex.frame.color="black", # color of the outline of the nodes
     edge.arrow.size=1, # set the size of the arrow head
     edge.arrow.width=2, # set the width of the arrow head
     vertex.label.family="Helvetica", # set the font of the text labels
     vertex.label.color="black", # set the color of the text labels
     vertex.label.cex=2, # set the size of the text labels
     vertex.label.degree=c(0,0,0,-pi/2,pi,pi,pi,pi,pi/2,0,0), # this defines where in relation to the node the text should be put
     # 0 is right, “pi” is left, “pi/2” is below, and “-pi/2” is above
     # if you do not set this, the text will go to the right of the node
     vertex.label.dist=c(5,8,8,4,4,5,5,5,5,6,6), # this defines how far away from the node the label should be put (this was a trial-and-error exercise)
     edge.lty=1, # line type for the vertices. We want a solid line, e.g. 3 is dotted
     edge.curved=FALSE) # we want straight arrows, not curved (not strictly necessary for this plot, but just FYI)
dev.off()

########## Highlight certain vertices (the paths to EVI)

# Find all the vertices that go to or from EVI (see ?incident_edges for an explanation of this function)
inc_edges <- incident_edges(Granger_net,  V(Granger_net)["EVI"], mode="all")
inc_edges
# in this case there are only vertices going to EVI, but if there were any going out, these
# would also be selected

# set the color for the vertices: make a list of colors. In this case, black for all the vertices initially
# ecount(Granger_net) gives you the number of vertices
ecol <- rep("black", ecount(Granger_net))
ecol
# now in this list of colors, use inc_edges to find the locations where the vertices are associated with EVI
# (this information is preserved when calling incident_edges())
# replace the color in these locations with another color, eg orange
ecol[unlist(inc_edges)] <- "orange"
ecol

pdf("Granger_network_EVI.pdf",width=10,height=7)
plot(Granger_net, 
     layout=l, # again use the circle layout
     vertex.color=c("darkolivegreen4","coral2","plum2","skyblue2","#003F7F","aquamarine3","burlywood3","mintcream","thistle4","thistle1","thistle3"), 
     vertex.frame.color="black",
     edge.arrow.size=1,
     vertex.label.family="Helvetica",
     vertex.label.color="black",
     vertex.label.cex=2,
     vertex.label.dist=c(5,8,8,4,4,5,5,5,5,6,6),
     vertex.label.degree=c(0,0,0,-pi/2,pi,pi,pi,pi,pi/2,0,0), #0 is right, “pi” is left, “pi/2” is below, and “-pi/2” is above
     edge.arrow.width=2,
     edge.lty=1,
     edge.curved=FALSE,
     edge.color=ecol) # add the vertice colors
dev.off()

########### Vary node and vertex sizes

# In this example, we vary node size based on the number of connections (more connections = larger node)
# We vary the width of the vertices based on the significance values (lower p = wider vertex) ---> this does
# not really make that much sense from a statistical perspective / interpretation, but it's just
# done to show an example of varying vertex widths

# Compute node degrees (the number of links/connections) and use that as a measure to set node size 
deg <- degree(Granger_net,
              mode = "all") # you can also set this to "out", if for instance you want highlight the variables
# that have an effect on other variables 
deg

# The result is integers, in this case ranging from 0 to 6
V(Granger_net)$size <- deg*10 # in order to set this as a useful size, multiply by 10

# The arrow width represents the p-value, which we renamed to 'weight', of the causality relationship
E(Granger_net)$width <- 0.01 / E(Granger_net)$sign_Granger_data.weight # do the division to turn the numbers 
# for high significance (low p) in large numbers, as these are used for sizing vertex widths. And we want
# relationships with lower p to show up as wider arrows

# Plot
# Note that this is not a very good looking plot (one of the p values is very low, which leads to a very wide
# vertex). A suggestion to improve this plot, could be to number the vertices from highest to lowest p (11 -> 1)
# and use that as vertex widths.

pdf("Granger_network_vary.pdf",width=10,height=7)
plot(Granger_net, # call the data
     layout=l, # still use the circle layout
     edge.color="black", 
     vertex.color=c("darkolivegreen4","coral2","plum2","skyblue2","#003F7F","aquamarine3","burlywood3","mintcream","thistle4","thistle1","thistle3"), # set node colors 
     vertex.frame.color="black", 
     edge.arrow.size=1, # set the size of the arrow head
     #edge.arrow.width=2, # set the width of the arrow head
     vertex.label.family="Helvetica", 
     vertex.label.color="black", 
     vertex.label.cex=2, 
     vertex.label.degree=c(0,0,0,-pi/2,pi,pi,pi,pi,pi/2,0,0), 
     vertex.label.dist=c(5,8,8,4,4,5,5,5,5,6,6), 
     edge.lty=1, 
     edge.curved=FALSE) 
dev.off()
