############ DATA VISUALIZATION ############ 
# R-Ladies meeting
# 28 February 2019
# Example of how to make a spider / radar plot 
# By Geraldine Klarenberg
# Raw data came from www.vitalsigns.org (crop data for Tanzania) but was heavily cleaned and
# manipulated for this plotting exercise

#### set your working directory #####

# install libraries
#### package from https://github.com/ricardo-bion/ggradar (original ggradar, from CRAN does not work with R 3.3)
devtools::install_github("ricardo-bion/ggradar", 
                         dependencies=TRUE)
# see also http://rstudio-pubs-static.s3.amazonaws.com/5795_e6e6411731bb4f1b9cc7eb49499c2082.html and 
# https://github.com/ricardo-bion/ggradar/blob/master/R/ggradar.R for more instructions on the commands

### Additional info: there seems to be fairly newish packages "ggiraph" and "ggiraphExtra" (interactive), that have 
# a function ggRadar. Have not yet explored this.

# load libraries
library(tidyverse)
library(ggradar)
library(cowplot) # this library contains functions to nicely combine plots in one figure, see 
# https://cran.r-project.org/web/packages/cowplot/index.html
# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
# https://cran.r-project.org/web/packages/cowplot/vignettes/plot_grid.html etc

# Load the files with data
crops_kgha <- read.csv("crop_summary_kgha.csv")
crops_area <- read.csv("crop_summary_area.csv")

######## Make plots for the area per crop #########
# 1. This data is in 'long' format. We need it 'wide' for this plotting
crops_area <- crops_area %>% 
  group_by(landscape_no) %>%
  spread(crop_name,area)
# 2. Turn all NAs in 0
crops_area[is.na(crops_area)] <- 0
# 3. Turn this tibble into a data frame
crops_area <- data.frame(crops_area)
# 4. Make separate data frames for the crop types
crops_area_cereals <- subset(crops_area,select=c("landscape_no","Bulrush.Millet","Finger.Millet","Sorghum","Maize","Paddy","Sesame.Simsim","Wheat"))
crops_area_roots <- subset(crops_area,select=c("landscape_no","Irish.potatoes","Sweet.Potatoes","Cassava","Onions"))
crops_area_fruitvegpulse <- subset(crops_area,select=c("landscape_no","Tomatoes","Banana","sugar.Cane","Beans","Soyabeans","Groundnut"))
# 5. Make the 3 plots
cereal_area <- ggradar(crops_area_cereals, # ggradar needs a number of specifications (that are different from ggplot)
                     grid.mid=30,  # set the value in the middle range of the radar
                     grid.max=60,  # set the outer value
                     group.line.width = 1, # set the width of lines that connect values on each 'spoke'
                     group.point.size = 2, # set the size of the points on each 'spoke'
                     grid.label.size=5, # set the size of labels/values along a 'spoke' 
                     legend.text.size=9,  # set legend text size
                     axis.label.size=3,  # set the size of the text around the radar / spider diagram (the categories)
                     font.radar="Helvetica", # set the font
                     values.radar = c("0", "30", "60"), # define the labels (values) on each 'arm'
                     plot.title="Total area (ha)")+ # add the title 
  theme(plot.title = element_text(size=14)) + # set the text size 
  theme(legend.position = "bottom")  # for this one, keep legend so we can use it later 

roots_area <- ggradar(crops_area_roots,
                    grid.mid=21,
                    grid.max=42, 
                    group.line.width = 1,
                    group.point.size = 2,
                    grid.label.size=5,
                    legend.text.size=9,
                    axis.label.size=3,
                    font.radar="Helvetica",
                    values.radar = c("0", "21", "42"),
                    plot.title="Total area (ha)") +
  theme(legend.position = "none") + 
  theme(plot.title = element_text(size=14))   

veg_area <- ggradar(crops_area_fruitvegpulse,
                  grid.mid=5,
                  grid.max=10, 
                  group.line.width = 1,
                  group.point.size = 2,
                  grid.label.size=5,
                  legend.text.size=9,
                  axis.label.size=3,
                  font.radar="Helvetica",
                  values.radar = c("0", "5", "10"),
                  plot.title="Total area (ha)") +
  theme(legend.position = "none") +
  theme(plot.title = element_text(size=14))  

######## Make plots for the kg/ha per crop #########
# 1. This data is in 'long' format. We need it 'wide' for this plotting
crops_kgha <- crops_kgha %>% 
  group_by(landscape_no) %>%
  spread(crop_name, meankgha)
# 2. Turn all NAs in 0
crops_kgha[is.na(crops_kgha)] <- 0
# 3. Turn this tibble into a data frame
crops_kgha <- data.frame(crops_kgha)
# 4. Make separate data frames for the crop types (use subset for filtering columns)
crops_kgha_cereals <- subset(crops_kgha,select=c("landscape_no","Bulrush.Millet","Finger.Millet","Sorghum","Maize","Paddy","Sesame.Simsim","Wheat"))
crops_kgha_roots <- subset(crops_kgha,select=c("landscape_no","Irish.potatoes","Sweet.Potatoes","Cassava","Onions"))
crops_kgha_fruitvegpulse <- subset(crops_kgha,select=c("landscape_no","Tomatoes","Banana","sugar.Cane","Beans","Soyabeans","Groundnut"))
# 5. Make the 3 plots
cereal_kgha <- ggradar(crops_kgha_cereals, # ggradar needs a number of specifications (that are different from ggplot)
                       grid.mid=6000,  # set the value in the middle range of the radar
                       grid.max=12000,  # set the outer value
                       group.line.width = 1, # set the width of lines that connect values on each 'spoke'
                       group.point.size = 2, # set the size of the points on each 'spoke'
                       grid.label.size=5, # set the size of labels/values along a 'spoke' 
                       legend.text.size=9,  # set legend text size
                       axis.label.size=3,  # set the size of the text around the radar / spider diagram (the categories)
                       font.radar="Helvetica", # set the font
                       values.radar = c("0", "6000", "12000"), # define the labels (values) on each 'arm'
                       plot.title="Mean yield (kg/ha)")+ # add the title 
  theme(legend.position = "none") +  # remove the legend; we'll add a shared legend later on
  theme(plot.title = element_text(size=14)) # set the text size 

roots_kgha <- ggradar(crops_kgha_roots,
                      grid.mid=3600,
                      grid.max=7200, 
                      group.line.width = 1,
                      group.point.size = 2,
                      grid.label.size=5,
                      legend.text.size=9,
                      axis.label.size=3,
                      font.radar="Helvetica",
                      values.radar = c("0", "3600", "7200"),
                      plot.title="Mean yield (kg/ha)") +
  theme(legend.position = "none") + 
  theme(plot.title = element_text(size=14)) 

veg_kgha <- ggradar(crops_kgha_fruitvegpulse,
                    grid.mid=4050,
                    grid.max=8100, 
                    group.line.width = 1,
                    group.point.size = 2,
                    grid.label.size=5,
                    legend.text.size=9,
                    axis.label.size=3,
                    font.radar="Helvetica",
                    values.radar = c("0", "4050", "8100"),
                    plot.title="Mean yield (kg/ha)") +
  theme(legend.position = "none") +
  theme(plot.title = element_text(size=14))  

########### Now put everything together ########
# We need to extract a legend from one of the plots to add to the final product. See
# https://github.com/hadley/ggplot2/wiki/Share-a-legend-between-two-ggplot2-graphs
# Write a function to save a legend as a separate 'grob' (external graphical element, in Grid terminology),
# which you can then later combine with your plots into one figure
# NOTE: this means that you *do* have to define a legend in one of your plots, extract it, and then we'll
# hide it later on again
g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

# apply the function to one of your plots
mylegend <- g_legend(cereal_area)

# now use plot_grid() from cowplot to put everything together
all_plots <- plot_grid(cereal_area + theme(legend.position = "none"), # now hide the legend for this plot
                       roots_area,
                       veg_area,
                       cereal_kgha,
                       roots_kgha,
                       veg_kgha,
                       nrow=3) # define the number of rows you want
# now you have a figure with all the plots, 2 columns and 3 rows
# add the legend to the bottom of this
all_plots <- plot_grid(all_plots, # all the plots
                       mylegend, # the legend
                       nrow=2, # we want 2 rows: the plots and the legend
                       rel_heights=c(0.95,0.05)) # define the relative heights so the legend is not too large
# Save the plots
pdf("cropinfo_spiderplots.pdf",height=10,width=10)
all_plots
dev.off()

# We have now plotted the total area and total yields of each crop, with the landscapes in different colors, but you
# could also do it the other way around: have landscapes around the radar, and show the crops in different colors