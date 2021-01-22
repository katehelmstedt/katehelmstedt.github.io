


####################################################
#                                                  #
#                                                  #
#    WK 11:  3D data Vis                           #
#                                                  #
#                                                  #
####################################################

############## ------------- 1. CARTOGRAMS   --------------- ##########
#cartograms distord geographical maps by some other variation, often population. This aims to conserve the geographical form that people intuitively understand but show the distribution of the variable of interest by volumn. 

#lets create a cartogram of Africa

## ------- Libraries and data -----------------------------------
#load the `wrld_simpl` dataset from the `maptools` package
library(cartogram)
library(maptools)
data(wrld_simpl)

## ------- normal map -------------------------------------------
# extract polygons for Africa
afr <- wrld_simpl[wrld_simpl$REGION==2,]

# visualise the region's boundaries
plot(afr)

## ------- construct a cartogram ----------------------------------
# construct a cartogram using the `cartogram` package and the 2005 population
# you can ignore the warning messages.
afr_cartogram <- cartogram_cont(afr, "POP2005", itermax=5)

## ------- plot the cartogram ----------------------------------
plot(afr_cartogram)

# we can also colour and customise this using ggplot. But we won't explore this week. 

#unfortunately cartograms don't work well in Australia because we have small areas on the coast with reltively high populations compared to the the relatively unpopulated central areas. The distorted map becomes unrecognisable.  However tessellated Hexmaps can solve this problem. 



############## ------------- 2. TESSELLATED HEXMAPS   --------------- ##########
# Tessellated hexmap transform all regions to the same size and conserve their relative position. This helps conserves the original geography.

## ------- Libraries and data ---------------------------------------------
#install.packages("remotes")
#remotes::install_github("srkobakian/sugarbag")
#install.packages("eechidna")

library(sugarbag) 
library(eechidna)
library(magrittr)
library(dplyr)
library(ggplot2)

# The `sugarbag` package can be used with `ggplot` to creates hexmaps. 

# For this section we will use data from the Australian Electoral Commission, which has conveniently been wrapped into the `eechidna`` package (Exploring Election and Census Highly Informative Data Nationally for Australia). 

#The `nat_data16` dataframe from eechidna contains all the electoral division information and the `abs2016` dataframe contains census data. We will use both of these to explore the 2016 data. 

## ------- TASK 

# What do `nat_data16` and `abs2016` contain? have a look at what variables are in the dataframe. 
glimpse(nat_data16)
glimpse(abs2016)


## ------- Creating a hex map -------------------------------
#creating a hexmap has four steps 
# 1. Extract the regions centroids
# 2. Calculate the hexagons & create grid
# 3. Allocates hexagons to grid.
# 3. Add variables of interest and electoral division info 
# 4. Use ggplot to visualise 

## ------- Centroids --------------------------------------
#This is simply the `lat_c` and `long_c` of each electoral division stored in the `nat_data16` dataframe from the `eechidna` package.

# extract division names and centroid coordinates

division_centroids <- nat_data16 %>%
  dplyr::select(elect_div, longitude = long_c, latitude = lat_c)

## ------- Create grid & calculate hex points ---------------------

# Using the `create_grid()` function, we generate a grid. This function takes the centroid coordinates, calculates 6 points around each centroid, and creates a grid for the hexmap.   The function `hex_size =` defines the diameter of the hexagon in degrees, and `buffer_dist = ` tells the map how much buffer to put around the total map.

grid <- create_grid(centroids = division_centroids, 
                    hex_size = 1, 
                    buffer_dist = 5)


## ------- Allocate centroid info to the grid -------------------
# Combine the division_centroids and grid info using the 'allocate()` function. 
# Type `?allocate` into the console to see what each argument in the functin does. 

hex_allocated <- allocate(centroids = division_centroids,
                  sf_id = "elect_div", # same column used in division_centroids
                  hex_grid = grid,
                  hex_size = 1, # same size used in create_grid
                  hex_filter = 10,
                  focal_points = capital_cities,
                  width = 30, 
                  verbose = TRUE) 

## ------- Combine hexmap object with other info ----------------------

# Combine with `nat_datat16` dataframe 
h1 <- hex_allocated %>%
  fortify_hexagon(hex_size = 1, sf_id = "elect_div") %>%
  left_join(nat_data16, by = "elect_div") 

# combine demographic data. We select just some variables from the `abs2016`  data frame to add.
aus_hexmap <- h1 %>% 
  left_join(abs2016 %>% 
      select(elect_div = DivisionNm, 
          AusCitizen, 
          CurrentlyStudying, 
          MedianFamilyIncome, 
          Unemployed, 
          Renting))


## ------- Visualise -------------------------------------
# the `group = elect_div` argument below overides the default which will group the polygons by x, rather than by elecgoral division. Without it, the map won't work.  

aus_hexmap %>% 
  ggplot(aes(x=long, y=lat, group = elect_div)) +
  geom_polygon(aes(fill = Unemployed)) +
  scale_fill_continuous(type = "viridis") +
  guides(fill = guide_colourbar(title = "% of population renting"))  
  
# Here's a slightly more pretty version. Do you know what each of the arguments does?

aus_hexmap %>% 
    ggplot(aes(x=long, y=lat, group = elect_div)) +
    geom_polygon(aes(fill = Renting)) +
    coord_equal() + 
    theme_void() + 
    scale_fill_continuous(type = "viridis") +
    guides(fill = guide_colourbar(title = NULL)) + 
    theme(legend.position = "bottom") + 
    ggtitle("Percentage of Australian population that is renting \n (2016 electoral divisions)")


## ------- TASK  
# change the map to show a different variable from the `abs2016` data, e.g., family income, unemployment etc. 

##Just for comparison. Look at the map when we only use the centroids. using the same code as above but this time `hex_size = 0.1`. 
  
#create centroids & hex dimensions
p1 <- nat_data16 %>% 
    select(elect_div, hex_long = long_c, hex_lat = lat_c) %>%
    fortify_hexagon(hex_size = 0.1, sf_id = "elect_div") %>%
    left_join(nat_data16, by = "elect_div")

#add ABS demographic data 
aus_centroidmap <- p1 %>% 
    left_join(abs2016 %>% 
                select(elect_div = DivisionNm, 
                       AusCitizen, 
                       CurrentlyStudying, 
                       MedianFamilyIncome, 
                       Unemployed, 
                       Renting))
#create hexmap
aus_centroidmap %>% 
    ggplot(aes(x=long, y=lat, group = elect_div)) +
    geom_polygon(aes(fill = Renting)) +
    coord_equal() + 
    theme_void() + 
    scale_fill_continuous(type = "viridis") +
    guides(fill = guide_colourbar(title = "% Renting"))


###### - Possible extention  - ####### 

#https://ropenscilabs.github.io/eechidna/articles/eechidna-intro.html 



###########----- 3. Raster spatial extent and resolution --------############

## ------- The data -------------------------------------------------
# The data used in this workshop contains information on the vegetation at the National Ecological Observatory Network's San Joaquin Experimental Range and Soaproot Saddle field sites. The data we use today is elevation data.  

## ------- What is a raster file ------------------------------------
# Raster or "gridded" data are data that are saved in pixels. In the spatial world, each pixel represents an area on the Earth's surface. 

# To work with rasters in R, we need two key packages, `sp` and `raster`. When you install the `raster` package, `sp` should also install. the `rgdal` package is also useful for working with raster data. `rgdal` allows us to export rasters to GeoTIFF format.

## ------- Install and load libraries -------------------------------

install.packages("raster")
install.packages("sp")
install.packages("rgdal")

library(raster)
library(sp)
library(rgdal)

## ------- TASK -------------------------------
# Check that your working directory is set. Download data files from blackboard and save in your working directory. 

# load raster in an R object called 'DEM' which stands for Digital Elevation model
DEM <- raster("NEON-DS-Field-Site-Spatial-Data/SJER/DigitalTerrainModel/SJER2013_DTM.tif")

# look at a summary of the raster attributes. 
summary(DEM)

#Note the error, summary() takes a sample of the raster file unless you force it to count every cell. This only matters in very large datasets. 

summary(DEM, maxsamp = ncell(DEM))

#look at the raster attributes 
DEM

# A few things to take notice in this data:    
  
# * dimensions: the "size" of the file in pixels
# * nrow, ncol: the number of rows and columns in the data (imagine a spreadsheet or a matrix).
# * ncells: the total number of pixels or cells that make up the raster.
# * resolution: the size of each pixel (in meters in this case). 1 meter pixels means that each pixel represents a 1m x 1m area on the earth's surface.
# * extent: the spatial extent of the raster. This value will be in the same coordinate units as the coordinate reference system of the raster.
# * coord ref: the coordinate reference system string for the raster. This raster is in UTM (Universal Trans Mercator) zone 11 with a datum of WGS 84. More on UTM here.

# Now let's explore some key attributes of the raster data. 

## ----- Define min/max values -------------------------------

# This raster doesn't have the min or max pixel values. But, these can be added using the `setMinMax()` function.

# calculate and save the min and max values
DEM <- setMinMax(DEM)

# view new raster attributes
DEM


## ---- get-min-max -------------------------------

#You can also view the raster pixels min, max and range using the `cellStates()` function . 

#NOTE: this code may fail if the raster is too large
cellStats(DEM, min)
cellStats(DEM, max)
cellStats(DEM, range)


## ---- View CRS - Co-ordinate Reference System ---------------------
DEM@crs

#You can see the raster file is located in utm zone 11. The utm coordinate reference system cuts the world into 60 latitude zones.

## ---- View extent -----------------------------------------------
# Remember that extent are the boundaries of the raster file.
DEM@extent


## ---- histogram of elevation values ------------------------------
# View the distribution of values in the raster.  We use hist() instead of ggplot() because plot() is more compatible with raster files.

hist(DEM, main = "Distribution of elevation values", 
     col = "orange", 
     maxpixels = 22000000)


## ---- Plot raster  --------------------------------------
# There are two ways to visualise the raster image, image() and plot() 
# The `plot()` function has a base setting for the number of pixels that it will plot (100,000 pixels). When the image is large `image()` might be better for rendering rasters. The `image()` function allows you to control the way a raster is rendered on the screen.

# `plot()`
plot(DEM, 
		 main="Digital Elevation Model, SJER") 

# `image()`
image(DEM)
# restrict the plot pixels between 250 and 300m elevation
image(DEM, zlim=c(250,300))

## ---- Customising colour ---------------------------------------

# specify colors
# `terrain.colors(5)` below, creates a palette of colors with 5 categories. There are other palettes that you can use, including rainbow and `heat.colors()`. See previous tutorials for information on using different palettes

col <- terrain.colors(5)
image(DEM, zlim=c(250,375), main="Digital Elevation Model (DEM)", col=col)


## --- TASK: Try a different number colour categories in `terrain.colors()`.   
## --- TASK: What happens if you change the zlim values in the `image()` function?   
## --- TASK: What are the other attributes that you can specify when using the `image()` function?   

# add breaks to the colormap (6 breaks = 5 segments)
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
        legend = c("lowest", "a bit higher", "middle ground", "higher yet", "highest"), 
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
        legend = c("Highest", "Higher yet", "Middle","A bit higher", "Lowest"), 
        fill = rev(col))


## --- TASK: 
# Try the code again but only make one of the changes -- reverse order or reverse colors-- what happens?  
  
#The raster plot now inverts the elevations! This is a good reason to understand your data so that a simple visualisation error doesn't have you reversing the slope or some other error.

# You can also customise the breaks and use less colours. 
col=terrain.colors(4)

#add breaks to the colormap (6 breaks = 5 segments)
brk <- c(200, 300, 350, 400,500)
plot(DEM, col=col, breaks=brk, main="DEM with fewer breaks")

# Notice that the legend is no longer uniform.



## ---- Raster calculations -------------------------------------

#multiple each pixel in the raster by 2
DEM2 <- DEM * 2

DEM2

#plot the new DEM
plot(DEM2, main="DEM with all values doubled")


## ---- Cropping raster files -------------------------------------

#There are two main ways to crop a raster file. 1. Drawing a box to define the plot area, or 2. manually assign the extent coordinates.

### 1. Drawing a box 
#To do this, first plot the raster. Then define the crop extent by clicking twice:   
  
#1. Click in the UPPER LEFT hand corner where you want the crop box to begin.
#2. Click again in the LOWER RIGHT hand corner to define where the box ends.


#You'll see a red box on the plot. NOTE that this is a manual process that can be used to quickly define a crop extent.
 
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
# A color image raster is different from other rasters, in that it has multiple bands or multiple colour files layed on top of each other. Each band represents reflectance values for a particular color or spectra of light. If the image is RGB, then the bands (files) are red, green and blue. These colors together create what we know as a full color image.

# Unlike the last section where you just loaded one file that represented ground elevation, in this section we create stack with three colour rasters: a 'red' file, a 'green' file and a 'blue' file.

#All files in a raster stack must have the same: projection (CRS), spatial extent and resolution.

#In this tutorial, we will stack three bands (3 .tif files) together to create a composite RGB image.

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

#Check out the scale bars. What do they represent? ----- This reflectance data are radiances corrected for atmospheric effects. The data are typically unitless and ranges from 0-1. NEON Airborne Observation Platform data, where these rasters come from, has a scale factor of 10,000.


## ---- Plot rgb ------------------------------------------------------------
#Plot a combined RGB image using the raster stack. You need to specify the order of the bands when you do this. In our stack, band 19, which is the blue band, is first in the stack, whereas band 58, which is the red band, is last. Thus the order for the RGB image is 3,2,1 to ensure the red band is rendered first as red.

#To plot the raster using the `rgbRaster()` function you need: an R object to plot, to know which layer of the stack is which color, to use the `stretch()` argument for contrast. 

# plot RGB version
plotRGB(rgbRaster,r=3,g=2,b=1, stretch = "lin")

## ---- Explore the raster data in other ways --------------------------
# view histogram of reflectance values for all rasters
hist(rgbRaster)

# R defaults to only showing the first 100,000 values, so if you have a large raster you may not be seeing all the values.

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
# In our rgbRaster object we have a list of rasters. These rasters are all the same extent, CRS and resolution. By creating a raster brick we will create one raster object that contains all of the rasters so that we can use this object to quickly create RGB images. Raster bricks are more efficient objects to use when processing larger datasets. This is because the computer doesn't have to spend energy finding the data - it is contained within the object.

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

## ---- Write to geotiff files ------------------------------------------------

# Save to geotiff by copying the CRS, extent and resolution information so the data will read properly into a GIS program as well. Note that this writes the raster in the order they are in. In our case, the blue (band 19) is first but most programs expect the red band first (RGB).

# It's a good idea to always create your stacks R->G->B to start!!!

## re-order stack
# Make a new stack in the order we want the data in 
orderRGBstack <- stack(rgbRaster$band58,rgbRaster$band34,rgbRaster$band19)

# write the geotiff
# change overwrite=TRUE to FALSE if you want to make sure you don't overwrite your files!
writeRaster(orderRGBstack,"rgbRaster.tif","GTiff", overwrite=TRUE)



