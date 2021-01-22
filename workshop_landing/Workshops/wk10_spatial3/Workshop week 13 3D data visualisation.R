
####################################################
#                                                  #
#                                                  #
#    Week 10:  3D data Visualisation               #
#                                                  #
#                                                  #
####################################################

############## ------------- 1. CARTOGRAMS   --------------- ##########
# Cartograms distord geographical maps by some other variation, often population. 
# This aims to conserve the geographical form that people intuitively understand but show the 
# distribution of the variable of interest by volume. This is an example of a vector dataset (rather than raster). 

# Create a cartogram of Africa

## ------- Libraries and data -----------------------------------
library(cartogram)
library(maptools)
library(sf)
library(rgeos)

#load the `wrld_simpl` dataset from the `maptools` package. This is just a dataset that comes with the
# package, but since is is so large they don't load it automatically in case you don't end up using it.
# this `data()` function just pulls it out and saves it as the variable name `wrld_simpl`. Then you can 
# use it as if it were just an automaticallly loaded dataset.
data(wrld_simpl)

## ------- normal map -------------------------------------------
# extract polygons for Africa
africa <- wrld_simpl[wrld_simpl$REGION==2,]

# visualise the region's boundaries using the inbuilt plot function in R, which gives a quick and 
# simple way to visualise the vector data
plot(africa)

# examine the dataset
head(africa)

# When you examine the `africa` data, is in a very long list format. There's useful data at the top,
# but then a long list of all of the polygons we see in the figure. It's not the most useful
# data format, nor the type we are used to using throughout this unit. That's true for any
# subset of the inbuilt `wrld_simpl` data. 
# 
# Convert to a format that works with the packages and approaches we have been using 
# (which is called the 'sf' format for spatial data)
africa_sf <- st_as_sf(africa) 


## ------- Construct a cartogram ----------------------------------
## 
# First, we have to deal with the fact that cartograms are a weird, misaligned kind of
# map. They distort the shapes, and R and ggplot want to force us to be really careful to make 
# sure the map we end up producing lines up with the real world placement of these
# newly distorted shapes. For that reason, we have to be careful about the projection
# we use for this spatial data. If we start with a good choice of projection (and one that
# suits the region we are examining), we have more flexibility in creating a weird distorted version.
# So, first choose a projection that is suitable for the whole region we are examining (i.e. Africa)
# (see https://resources.arcgis.com/en/help/main/10.1/018z/pdf/projected_coordinate_systems.pdf
# for projections for specific regions -- match the countries or areas you're interested with
# the projection code listed here)

afrproj <- st_transform(africa_sf, crs = 102022)

# Then, construct a cartogram data using the `cartogram` package -- we will examine the 2005 population

afr_cartogram <- cartogram_cont(afrproj, 'POP2005', itermax=5)

## ------- plot the cartogram ----------------------------------
ggplot() +
  geom_sf(data = afr_cartogram, aes(fill = POP2005))

# We can also colour and customise this using ggplot as we usually do. This is the beauty of ggplot!



###########----- 2. Raster spatial extent and resolution --------############

## ------- The data -------------------------------------------------
# The data used in this workshop contains information on the vegetation at the National Ecological 
# Observatory Network's San Joaquin Experimental Range and Soaproot Saddle field sites. 
# The data we use today is elevation data.  

## ------- What is a raster file ------------------------------------
# Raster or "gridded" data are data that are saved in pixels. In the spatial world, each pixel 
# represents an area on the Earth's surface. 

# To work with rasters in R, we need two key packages, `sp` and `raster`. When you install the `raster` 
# package, `sp` should also install. the `rgdal` package is also useful for working with raster data. 
# `rgdal` allows us to export rasters to GeoTIFF format.

## ------- Libraries -------------------------------

library(raster)
library(sp)
library(rgdal)
library(viridis)

## ------- TASK -------------------------------
# Check that your working directory is set. Download data files from blackboard and save in your 
# working directory. 

# load raster in an R object called 'DEM' which stands for Digital Elevation model
DEM <- raster("NEON-DS-Field-Site-Spatial-Data/SJER/DigitalTerrainModel/SJER2013_DTM.tif")

# A raster is, at its most fundamental, a matrix of some kind of values. The values here are elevations
# (i.e. heights above sea level). We can examine a summary of the raster values: 
summary(DEM) 

# That line takes.......a long time to run, and still only looked at a tiny fraction of the cells.
# I wonder how big the matrix is? We canexamine the raster attributes:
DEM

# A few things to take notice in this data:    
# * dimensions: the "size" of the file in pixels
# * nrow, ncol: the number of rows and columns in the data (imagine a spreadsheet or a matrix).
# * ncells: the total number of pixels or cells that make up the raster (note that rasters can be huge!)
# * resolution: the size of each pixel (in meters in this case). 1 meter pixels means that each 
# pixel represents a 1m x 1m area on the earth's surface.
# * extent: the spatial extent of the raster. This value will be in the same coordinate units as 
# the coordinate reference system of the raster.
# * coord ref: the coordinate reference system string for the raster. This raster is in UTM 
# (Universal Trans Mercator) zone 11 with a datum of WGS 84. We don't delve deeply into this in this unit.

# Now let's explore some key attributes of the raster data. 

## ----- Define min/max values -------------------------------

# Rasters don't natively load in with the min or max pixel values already calculated. 
# View the raster pixels min, max and range using the `cellStats()` function . 
cellStats(DEM, min)
cellStats(DEM, max)
cellStats(DEM, range) # This actually can't run for such a massive dataset! Useful for others though.

# If we think they will be useful, we can add them to the raster using the `setMinMax()` function.
DEM <- setMinMax(DEM)
# view new raster attributes
DEM
# what has changed from last time you examined this object a few lines above?

## ---- Pulling out information from raster data  ---------------------

# When we were using dataframes, remember that we would use the $ notation to pull out different
# parts of the data. Rasters are just a different way to store data, but instead of using the $ notation
# they use an @ notation. It works very similarly to $: type the name of the dataset, then the @ symbol, 
# and you'll get some suggestions.

# E.g. to get the Co-ordinate reference system:

DEM@crs 
# This is just for interest, we don't explore CRS too much in MXB262
# You can see the raster file is located in utm zone 11. The utm coordinate reference system cuts 
# the world into 60 latitude zones.

## ---- View extent -----------------------------------------------
# Remember that extent are the boundaries of the raster file.
DEM@extent

## ---- Exploring the values of the raster ------------------------------

# If you want to see the whole dataset (or, whatever R is able to print):
values(DEM)

# Remember, spatial data is still just data. We can explore it in many of the same ways we have explored
# all other kinds of data throughout the unit. 
# Rather than needing to pull the values out of the raster dataset, just using its name in plotting
# functions communicates that we are just talking about the acutal matrix of data (here, the elevation
# values).

# View the distribution of values in the raster.  We use hist() instead of ggplot() because plot() 
# is more compatible with raster files.

hist(DEM, main = "Distribution of elevation values", 
     col = "orange", 
     maxpixels = 22000000)


## ---- Plot raster  --------------------------------------
# There are two ways to visualise the raster image, image() and plot() 
# The `plot()` function has a base setting for the number of pixels that it will plot (100,000 pixels). 
# When the image is large `image()` might be better for rendering rasters. The `image()` 
# function allows you to control the way a raster is rendered on the screen. Check out the difference:

# `plot()`
plot(DEM, 
		 main="Digital Elevation Model, SJER") 

# Can you observe how large the dataset is by looking at this image? How might a smaller raster (or,
# a smaller data matrix) look different?

# `image()`
image(DEM)

# Using `image()` we can also easily restrict the plot to pixels between 250 and 300m elevation
image(DEM, zlim=c(250,300))

## ---- Customising colour ---------------------------------------

# specify colors
# `viridis(5)` below, creates a palette of colors with 5 categories. 
# There are other palettes that you can use, including rainbow,  `heat.colors()`, and `terrain.colors()`. 
# See previous tutorials for information on using different palettes, and don't forget to never use rainbow.

col <- viridis(5)
image(DEM, zlim=c(250,375), main="Digital Elevation Model (DEM)", col=col)

## --- TASK: Try using `terrain.colors()` instead, a popular choice when plotting land.
## --- TASK: Try a different number colour categories in `terrain.colors()`.   
## --- TASK: What happens if you change the zlim values in the `image()` function?   
## --- TASK: What are the other attributes that you can specify when using the `image()` function?   

# Add breaks to the colormap (6 breaks = 5 segments)
# It would make sense to manually set the values at which the colour changes if there were particular semantic
# definitions of each height. e.g. Very high, Kinda high, Not super high, Kinda low, Pretty darn low. 
# Or, e.g. flood probabilities (now or with climate change)

brk <- c(250, 300, 350, 400, 450, 500)

plot(DEM, col=col, breaks=brk, main="DEM with more breaks")

## ---- Customise the legend ----------------------------------------
# First, expand right side of the image by clipping the rectangle to make room for the legend and then turn xpd off
par(xpd = FALSE, mar=c(5.1, 4.1, 4.1, 4.5))

# Second, plot w/ no legend
plot(DEM, col=col, breaks=brk, main="DEM with a Custom (but flipped) Legend", legend = FALSE)

# Third, turn xpd back on to force the legend to fit next to the plot.
par(xpd = TRUE)

# Fourth, add a legend outside of the plot
legend(par()$usr[2], 4110600,
        legend = c("Pretty darn low", "Kinda low", "Not super high", "Kinda high", "Very high"), 
        fill = col)

# Notice that the legend is in reverse order in the previous plot. Let’s fix that. 

# Flip the legend
# Expand right side of clipping rect to make room for the legend
par(xpd = FALSE,mar=c(5.1, 4.1, 4.1, 4.5))
#DEM with a custom legend
plot(DEM, col=col, breaks=brk, main="DEM with a Custom Legend",legend = FALSE)
#turn xpd back on to force the legend to fit next to the plot.
par(xpd = TRUE)
#add a legend - but make it appear outside of the plot
legend( par()$usr[2], 4110600,
        legend = c("Very high", "Kinda high", "Not super high","Kinda low", "Pretty darn low"), 
        fill = rev(col))


## --- TASK: 
# Try the code again but only make one of the changes -- reverse order or reverse colors-- what happens?  
  
# The raster plot now inverts the elevations! This is a good reason to understand your data so that a simple 
# visualisation error doesn't have you reversing the slope or some other error.

# You can also customise the breaks and use fewer colours. 
col=viridis(4)

#add breaks to the colormap (6 breaks = 5 segments)
brk <- c(200, 300, 350, 400, 500)
plot(DEM, col=col, breaks=brk, main="DEM with fewer breaks")

# Notice that the legend is no longer uniform -- what has caused that?

## ---- Raster calculations -------------------------------------

# Raster files are just matrices, so we can manipulate them using simple arithmetic (note that the notation can be 
# different to what we're used to with matrices though)

# multiply each pixel in the raster by 2
DEM2 <- DEM * 2

DEM2

#plot the new DEM
plot(DEM2, main="DEM with all values doubled")


## ---- Cropping raster files -------------------------------------

# There are two main ways to crop a raster file. 1. Drawing a box to define the plot area, or 
# 2. manually assign the extent coordinates.

### 1. Drawing a box 
# To do this, first plot the raster. Then define the crop extent by clicking twice:   
  
# 1. Click in the UPPER LEFT hand corner where you want the crop box to begin.
# 2. Click again in the LOWER RIGHT hand corner to define where the box ends.


# You'll see a red box on the plot. NOTE that this is a manual process that can be used to quickly define a crop extent.
 
#TASK: Crop the DEM plot using the code below

#plot the DEM
 plot(DEM)
#Define the extent of the crop by clicking on the plot
 cropbox1 <- drawExtent()
#crop the raster, then plot the new cropped raster
DEMcrop1 <- crop(DEM, cropbox1)
 
#plot the cropped extent
plot(DEMcrop1)


### 2. Manually asign extent 

# define extent as (xmin, xmax, ymin , ymax). 

#define the crop extent
cropbox2 <-c(255077.3,257158.6,4109614,4110934)
#crop the raster
DEMcrop2 <- crop(DEM, cropbox2)
#plot cropped DEM
plot(DEMcrop2)


####------------- 4. Raster and colour images ------------------------####
# A color image raster is different from other rasters, in that it has multiple bands or multiple colour files 
# layed on top of each other. Each band represents reflectance values for a particular color or spectra of light. 
# If the image is RGB, then the bands (files) are red, green and blue. These colors together create what we know 
# as a full color image.

# Unlike the last section where you just loaded one file that represented ground elevation, in this section we create 
# stack with three colour rasters: a 'red' file, a 'green' file and a 'blue' file.

# All files in a raster stack must have the same: projection (CRS), spatial extent and resolution.

# We will stack three bands (3 .tif files) together to create a composite RGB image.

## ---- Import tiffs --------------------------------------------------------

# import tiffs for each band
band19 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band19.tif"
band34 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band34.tif"
band58 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band58.tif"

## ---- Create r stack ---------------------------------------------------------
# create stack of stack
rgbRaster <- stack(band19,band34,band58)

# This has now created a stack of 3 raster files  Let's view them.

## ---- View stack ----------------------------------------------------------

# check attributes
rgbRaster

# we see the CRS, resolution, and extent of all three rasters.
# plot stack
plot(rgbRaster)

# The different shading in the different images shows the different red, green and blue reflectance. 

#Check out the scale bars. What do they represent? ----- This reflectance data are radiances corrected 
# for atmospheric effects. The data are typically unitless and ranges from 0-1. NEON Airborne Observation 
# Platform data, where these rasters come from, has a scale factor of 10,000.


## ---- Plot rgb ------------------------------------------------------------
#Plot a combined RGB image using the raster stack. You need to specify the order of the bands when you do this. 
# In our stack, band 19, which is the blue band, is first in the stack, whereas band 58, which is the red band, 
# is last. Thus the order for the RGB image is 3,2,1 to ensure the red band is rendered first as red.

# To plot the raster using the `rgbRaster()` function you need: an R object to plot, to know which layer of the stack 
# is which color, to use the `stretch()` argument for contrast. 

# Plot RGB version, and prepare to be amazed
plotRGB(rgbRaster,r=3,g=2,b=1, stretch = "lin")

## ---- Explore the raster data in other ways --------------------------
# View histogram of reflectance values for all rasters
hist(rgbRaster)

## ---- Crop the image --------------------------------------------------------
#You can do the same as above.

# define the desired extent
rgbCrop <- c(256770.7,256959,4112140,4112284)

# crop
rgbRaster_crop <- crop(rgbRaster, rgbCrop)

# view cropped stack
plot(rgbRaster_crop)

## --- TASK: plot `rgbRaster_crop` as an rgb image


## ----Create an R brick ------------------------------------------------------
# In our rgbRaster object we have a list of rasters. These rasters are all the same extent, CRS and resolution. 
# By creating a raster brick we will create one raster object that contains all of the rasters so that we can use 
# this object to quickly create RGB images. Raster bricks are more efficient objects to use when processing 
# larger datasets. This is because the computer doesn't have to spend energy finding the data - it is contained 
# within the object.

# create raster brick
rgbBrick <- brick(rgbRaster)

# check attributes
rgbBrick

## ---- R brick size---------------------------------------------------------
# While the brick might seem similar to the stack (see attributes above), we can see that it's very different when we look at the size of the object.

# The brick contains all of the data stored in one object
# The stack contains links or references to the files stored on your computer

# view object size
object.size(rgbBrick)
object.size(rgbRaster)

# view raster brick
plotRGB(rgbBrick,r=3,g=2,b=1, stretch = "Lin")

