

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





#################################### END #################
## ---- TASK
# plot an RGB version of the cropped stack
plotRGB(rgbRaster_crop,r=3,g=2,b=1, stretch = "lin")



##### _____ ggplot visualisation 
#You can also visualise the raster file using ggplot, but you need to change the format to a data.frame. 



DEM_df <- as.data.frame(DEM, xy = TRUE)
str(DEM_df)

#rendering the ggplot is a little slow. For some reason this plot is all smooshed on the x axis. can't figure it out. 
x <- ggplot() +
  geom_raster(data = DEM_df , aes(x = x, y = y, fill = SJER2013_DTM)) +
  scale_fill_viridis_c() +
  coord_quickmap()

