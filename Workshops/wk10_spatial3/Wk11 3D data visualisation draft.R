


####################################################
#                                                  #
#                                                  #
#    WK 11:  3D data Vis                           #
#                                                  #
#                                                  #
####################################################

####------------- 1.  ------------####


####------------- 2. ------------####

####------------- 3. Raster spatial extent and resolution ------------####

## ------- The data
#The data usee in this workshop contains information on the vegetation at the National Ecological Observatory Network's San Joaquin Experimental Range and Soaproot Saddle field sites. The data we use today is elevation data.  

## ------- What is a raster file 
#Raster or "gridded" data are data that are saved in pixels. In the spatial world, each pixel represents an area on the Earth's surface. 

#To work with rasters in R, we need two key packages, `sp` and `raster`. When you install the `raster` package, `sp` should also install. the `rgdal` package is also useful for working with raster data. `rgdal` allows us to export rasters to GeoTIFF format.



## ---- Install and load libraries

install.packages("raster")
install.packages("sp")
install.packages("rgdal")

library(raster)
library(sp)
library(rgdal)

## -- TASK: Check that your working directory is set. Download data files from.... and save in your working directory. 


# load raster in an R object called 'DEM' which stands for Digital Elevation model
DEM <- raster("NEON-DS-Field-Site-Spatial-Data/SJER/DigitalTerrainModel/SJER2013_DTM.tif")

# look at the raster attributes. 
DEM


# A few things to take notice of in this data:    
  
# * dimensions: the "size" of the file in pixels
# * nrow, ncol: the number of rows and columns in the data (imagine a spreadsheet or a matrix).
# * ncells: the total number of pixels or cells that make up the raster.
# * resolution: the size of each pixel (in meters in this case). 1 meter pixels means that each pixel represents a 1m x 1m area on the earth's surface.
# * extent: the spatial extent of the raster. This value will be in the same coordinate units as the coordinate reference system of the raster.
# * coord ref: the coordinate reference system string for the raster. This raster is in UTM (Universal Trans Mercator) zone 11 with a datum of WGS 84. More on UTM here.


# Now let's explore some key attributes of the raster data. 

## ----- Define min/max values 

# By default this raster doesn't have the min or max pixel values. However, we can add these to the list of attributesusing the `setMinMax()` function.

# calculate and save the min and max values of the raster to the raster object
DEM <- setMinMax(DEM)

# view raster attributes with the min/maz listed under value
DEM


## ---- get-min-max

#You can also view the raster pixels min, max and range using the `cellStates()` function . 

#NOTE: this code may fail if the raster is too large
cellStats(DEM, min)
cellStats(DEM, max)
cellStats(DEM, range)


## ---- View CRS 
# Remember that CRS stands for Coordinate Reference System. 
DEM@crs

#You can see that raster file is located in utm zone 11. The utm coordinate reference system breaks the world into 60 latitude zones.

## ---- View extent
# The extent are the boundaries of the raster file.
DEM@extent


## ---- histogram of elevation values
# it can handly to get an overview of the distribution of values in the raster. 

hist(DEM, main="Distribution of elevation values", 
     col= "purple", 
     maxpixels=22000000)


## ---- Plot raster

# plot the raster using plot()
plot(DEM, 
		 main="Digital Elevation Model, SJER") 

# Plot raster using image()
image(DEM)

#The `image()` function that allows you to control the way a raster is rendered on the screen. The `plot()` function has a base setting for the number of pixels that it will plot (100,000 pixels). Therefore when the image is large `image()` might be better for rendering rasters.

# specify the range of values that you want to plot in the DEM
# just plot pixels between 250 and 300 m in elevation
image(DEM, zlim=c(250,300))

## ---- Customising colour 


# we can specify the colors too
col <- terrain.colors(5)
image(DEM, zlim=c(250,375), main="Digital Elevation Model (DEM)", col=col)

#In the above example, `terrain.colors()` creates a palette of colors. There are other palettes that you can use, including rainbow and `heat.colors()`. See previous tutorials for information on using different palettes

# we can also change the legend categories and breaks

# add a color map with 5 colors
col=terrain.colors(5)

## --- TASK: What happens if you change the number of colors in the `terrain.colors()` function?   
## --- TASK: What happens if you change the zlim values in the `image()` function?   
## --- TASK: What are the other attributes that you can specify when using the `image()` function?   


# For continuous data by default, R will assign the gradient of colors uniformly across the full range of values in the data. In our case, our DEM has values between 250m and 500m. However, we can adjust the "breaks" which represent the numeric locations where the colors change if we want too.

# add breaks to the colormap (6 breaks = 5 segments)
brk <- c(250, 300, 350, 400, 450, 500)

plot(DEM, col=col, breaks=brk, main="DEM with more breaks")


## ---- Customise the legend
# First, expand right side of clipping rectangle to make room for the legend
# turn xpd off
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


## --- TASK: Try the code again but only make one of the changes -- reverse order or reverse colors-- what happens?  
  
#The raster plot now inverts the elevations! This is a good reason to understand your data so that a simple visualisation error doesn't have you reversing the slope or some other error.


# Yoiu can also customise the breaks and use less colours. 
col=terrain.colors(4)
#add breaks to the colormap (6 breaks = 5 segments)
brk <- c(200, 300, 350, 400,500)
plot(DEM, col=col, breaks=brk, main="DEM with fewer breaks")


## ---- Raster calculations

#multiple each pixel in the raster by 2
DEM2 <- DEM * 2

DEM2
#plot the new DEM
plot(DEM2, main="DEM with all values doubled")


## ----Cropping raster files 

#There are two main ways to crop a raster fil, by directly drawing a box in the plot area, or manually assigning the extent coordinates to be used to crop the raster. 

### Drawing a box 
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


### Manually asign extent 

#We'll need the extent defined as (xmin, xmax, ymin , ymax) to do this. This appraoch is how we'd crop using a GIS shapefile (with a rectangular shape).

#define the crop extent
cropbox2 <-c(255077.3,257158.6,4109614,4110934)
#crop the raster
DEMcrop2 <- crop(DEM, cropbox2)
#plot cropped DEM
plot(DEMcrop2)



#TASK: Use what you've learnt to plot a Digital Surface Model (DSM)    

# 1. Create an R object called DSM from the raster: DigitalSurfaceModel/SJER2013_DSM.tif. 
# 2. Convert the raster data from m to feet. What is that conversion again? Oh, right 1m = ~3.3ft.
# 3. Plot the DSM in feet using a custom color map.
# 4. Create numeric breaks that make sense given the distribution of the data. Hint, your breaks might represent high elevation, medium elevation, low elevation.



####------------- 4. Raster and colour images ------------####
# A color image raster is a bit different from other rasters in that it has multiple bands. Each band represents reflectance values for a particular color or spectra of light. If the image is RGB, then the bands are in the red, green and blue. These colors together create what we know as a full color image.

# Unlike the last section where you just loaded one file that represented ground elevation. To work with colour images, you need to import multiple files and layer them on top of each other (a 'red' file, a 'green' file and a 'blue' file).

#A raster stack is a collection of raster layers. Each raster layer in the raster stack needs to have the same

# 1. projection (CRS),
# 2. spatial extent and
# 3. resolution.

#In this tutorial, we will stack three bands (3 .tif files) from a multi-band image together to create a composite RGB image.

## ----import-tiffs--------------------------------------------------------

# import tiffs
band19 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band19.tif"
band34 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band34.tif"
band58 <- "NEON-DS-Field-Site-Spatial-Data/SJER/RGB/band58.tif"

## ----list-files-tif------------------------------------------------------

# Select only the .tiff files from the directory to add to the raster stack  
rasterlist <-  list.files('RGB', full.names=TRUE, pattern="tif") 

## ----r-stack-------------------------------------------------------------
# create raster stack
rgbRaster <- stack(band19,band34,band58)

# create stack from the rasterlist created above. 
rstack1 <- stack(rasterlist)

# This has now created a stack of 3 raster files  Let's view them.

## ----view-stack----------------------------------------------------------

# check attributes
rgbRaster

#From the attributes we see the CRS, resolution, and extent of all three rasters.
# plot stack
plot(rgbRaster)

#Notice the different shading between the different bands. This is because the landscape relects in the red, green, and blue spectra differently.

#Check out the scale bars. What do they represent?
  
#This reflectance data are radiances corrected for atmospheric effects. The data are typically unitless and ranges from 0-1. NEON Airborne Observation Platform data, where these rasters come from, has a scale factor of 10,000.


## ----plot-rgb------------------------------------------------------------
#You can plot a composite RGB image from a raster stack. You need to specify the order of the bands when you do this. In our raster stack, band 19, which is the blue band, is first in the stack, whereas band 58, which is the red band, is last. Thus the order for a RGB image is 3,2,1 to ensure the red band is rendered first as red.

#To plot plot the raster using the rgbRaster() function you need:  

# R object to plot
# to know which layer of the stack is which color
# to use the stretch argument. This enables increased contrast. Options are "lin" & "hist".

# plot an RGB version of the stack
plotRGB(rgbRaster,r=3,g=2,b=1, stretch = "lin")

# See the raster package for other arguments that can help improve/modify the image. 



## ----explore the raster data in other ways --------------------------
# view histogram of reflectance values for all rasters
hist(rgbRaster)

#Note about the warning messages: R defaults to only showing the first 100,000 values, so if you have a large raster you may not be seeing all the values.

## ----crop----------------------------------------------------------
#You can crop all rasters within a raster stack the same way you'd do it with a single raster.

# determine the desired extent
rgbCrop <- c(256770.7,256959,4112140,4112284)

# crop to desired extent
rgbRaster_crop <- crop(rgbRaster, rgbCrop)

# view cropped stack
plot(rgbRaster_crop)


## --- TASK: plot the cropped stag `rgbRaster_crop` as an rgb image


## ----create-r-brick------------------------------------------------------
# In our rgbRaster object we have a list of rasters in a stack. These rasters are all the same extent, CRS and resolution. By creating a raster brick we will create one raster object that contains all of the rasters so that we can use this object to quickly create RGB images. Raster bricks are more efficient objects to use when processing larger datasets. This is because the computer doesn't have to spend energy finding the data - it is contained within the object.

# create raster brick
rgbBrick <- brick(rgbRaster)

# check attributes
rgbBrick

## ----rBrick-size---------------------------------------------------------
# While the brick might seem similar to the stack (see attributes above), we can see that it's very different when we look at the size of the object.

# The brick contains all of the data stored in one object
# The stack contains links or references to the files stored on your computer

# view object size
object.size(rgbBrick)
object.size(rgbRaster)

# view raster brick
plotRGB(rgbBrick,r=3,g=2,b=1, stretch = "Lin")

## ---- write geotiff files ---------------------------------------------------

# We can write out the raster in GeoTIFF format as well. When we do this it will copy the CRS, extent and resolution information so the data will read properly into a GIS program as well. Note that this writes the raster in the order they are in. In our case, the blue (band 19) is first but most programs expect the red band first (RGB).

#One way around this is to generate a new raster stack with the rasters in the proper order - red, green and blue format. Or, just always create your stacks R->G->B to start!!!

## re-order stack
# Make a new stack in the order we want the data in 
orderRGBstack <- stack(rgbRaster$band58,rgbRaster$band34,rgbRaster$band19)

# write the geotiff
# change overwrite=TRUE to FALSE if you want to make sure you don't overwrite your files!
writeRaster(orderRGBstack,"rgbRaster.tif","GTiff", overwrite=TRUE)






#################### DELETE #### This is the code for the task above ##########
# load raster in an R object called 'DEM'
DSM <- raster("NEON-DS-Field-Site-Spatial-Data/SJER/DigitalSurfaceModel/SJER2013_DSM.tif")

# convert from m to ft
DSM2 <- DSM * 3.3

DSM2

# add a color map with 3 colors
col=terrain.colors(3)

# add breaks to the colormap (6 breaks = 5 segments)
brk <- c(700, 1050, 1450, 1800)
plot(DSM2, col=col, breaks=brk, main="Digital Surface Model, SJER (ft)")




## ----challenge-code-plot-crop-rgb, echo=FALSE----------------------------
# plot an RGB version of the cropped stack
plotRGB(rgbRaster_crop,r=3,g=2,b=1, stretch = "lin")
