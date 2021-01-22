

#####################################
#                                   #
#                                   #
#    WK 5:  Effective Data Viz      #
#                                   #
#                                   #
####################################


# Libraries
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(patchwork)
library(ggplot2)



#########################
#    Overplotting       #
#########################
# We're going to create a dataset for this sections of the workshop. 

# Dataset:
a <- data.frame( x=rnorm(20000, 10, 1.2), y=rnorm(20000, 10, 1.2), group=rep("A",20000))
b <- data.frame( x=rnorm(20000, 14.5, 1.2), y=rnorm(20000, 14.5, 1.2), group=rep("B",20000))
c <- data.frame( x=rnorm(20000, 9.5, 1.5), y=rnorm(20000, 15.5, 1.5), group=rep("C",20000))
synthetic_data <- do.call(rbind, list(a,b,c))               

# oveplotting is common and occurs when your dataset is too large. See the following scatterplot of the data we just created.  
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point() 

# There doesn't seem to be a relationship between x and y. But if you explore the following steps for addressing overplotting, you will see a relationship emerge. 

### 1. Dot size ###
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(size = 0.2) 


### 2. Transparency ###
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(size = 0.2, alpha = 0.01) 

## -- Q. what argument mnaipulated transparency? is it in ggplot() or in geom_point()?
## -- Q. increase the dot size, does this improve the plot?
## -- TASK: try a few different combinations of `alpha` and `size`.


### 3. Sampling ###
# Sometimes less is more. Plotting a subset of the data (5% here) can help avoid overplotting, and can also greatly reduce the computing time.   

#take a sample of the data
synthetic_data_subset <- sample_frac(synthetic_data, 0.05)

ggplot(synthetic_data_subset, aes(x=x, y=y)) +
  geom_point(size=2)


### 4. Grouping with colour ###
ggplot(synthetic_data, aes(x=x, y=y, color=group)) +
  geom_point( size=2, alpha=0.1) +
  scale_color_viridis(discrete=TRUE) 

# -- NOTE: the colour argument is within the ggplot() function and not in geo_point(). Also that `group` is a variable in the data set and not a specific colour. 
# -- Q. In No. 4 above, where colour is specified in geom_point(), can the colour argument be set to `group`?



### 5. Highlighting just one group ###
# This assumes there is a grouping variable in the data set. 

ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(color="grey", size=2) +
  geom_point(data = synthetic_data %>% filter(group=="B"), color="#69b3a2", size=2)

## -- Q. what argument in geom_point() changes the colour? Test what other common colour names work. 
## -- Q does the Australian/UK spelling of colour work as well?
## -- Q can you put the colour argument in the ggplot() function instead of geom_point()?



### 6. Jittering ###
# Here's the example of jittering that we saw last week. 

ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() 
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() + geom_jitter(width = 0.2)


#########################
#    What is ` aes() `       #
#########################

# The `aes()` function describes how the data variables are mapped to the `geom()` function. `aes()`` can be set within `ggplot()` or in the individual `geom()` layers. For example the following two lines of code create the same plot 

ggplot(mpg, aes(displ, hwy)) + geom_point() # within ggplot()

ggplot(mpg) + geom_point(aes(displ, hwy)) # set within geom_point()

# -- NOTE: When `aes()`` is placed within `ggplot()` the settings becomes the default for all added `geom()`. 


######################################
#  Special note about `+ theme()`  #
#####################################

# `theme()` is a useful layer that can be used to customise features of a plot. Such as font type, font size, title position, subtitle colour, add a caption and many others. These would look like this in a ggplot code. 

plot + 
    theme(plot.title = element_text(face = bold)) # make title bold 

plot + 
    theme(plot.caption = "here's a caption") # add a caption. 

plot + 
    theme(plot.caption = "caption", plot.title = element_text(face = bold)) #theme() can take multiple arguments. 

## -- NOTE: type `theme(` and press tab, to see a drop down list of possible arguments. 


################################
#  Manipulating plot features  #
################################

######### Titles

# using ggtitle()
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + ggtitle("Scatterplot of Some Synthetic Data") 

# split title over two lines 
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + ggtitle("Scatterplot of Some \nSynthetic Data" ) 

# add a subtitle
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + ggtitle("Scatterplot of Some Synthetic Data", subtitle = "This is a subtitle") 

# use lab() - subtitles and captions
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + labs(title = "Scatterplot of Some Synthetic Data", subtitle = "also a subtitle", caption = "labs() lets me add a caption but ggtitle() doesn't")

# centre title
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + ggtitle("Scatterplot of Some Synthetic Data") + 
  theme(plot.title = element_text(hjust = 0.5 ))

# adjust text size, make bold, add a margin around title
ggplot(synthetic_data_subset, aes(x = x, y = y)) + 
  geom_point() + ggtitle("Scatterplot of Some Synthetic Data") + 
  theme(plot.title = element_text(hjust = 0.5, size = 20, face = "bold", margin = margin(10,0,10,0) ))

## -- NOTE: you can also add titles, subtitles etc within ` theme() `. You can see more here - https://www.datanovia.com/en/blog/ggplot-title-subtitle-and-caption/ 



######### Legends
# we'll use the bar chart of the dummy data from last week. 
# Create dummy data 
specie=c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition=rep(c("normal" , "stress" , "Nitrogen") , 4)
value=abs(rnorm(12 , 0 , 15))
dummy_data=data.frame(specie,condition,value)

# Grouped barchart
# to reduce some typing we're going to stor the plot in an object call ed g and then add different layers to it.
g <- ggplot(dummy_data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="dodge", stat="identity")
g

# turn off legend title
g + theme(legend.title = element_blank()) 

# Change legend colour, size and to bold
g + theme(legend.title = element_text(colour="chocolate", size=16, face="bold")) 
# Change legend title 
g + scale_fill_discrete(name = "This is a different \nlegend title?")

#everything together 
ggplot(dummy_data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="dodge", stat="identity") + theme(legend.title = element_text(colour="chocolate", size=16, face="bold")) + scale_fill_discrete(name = "This is a different \nlegend title?")

######### Axes

# Axis labels 
ggplot(ToothGrowth, aes(x = supp, y = len)) +
  geom_point() + 
  labs(x = "Tooth Length", y = "Supplement Type") 

# or 

axis_labels <- ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_point() + 
  xlab("Supplement") + 
  ylab("Tooth Length")


## -- NOTE: I've created an object called `axis_labels` so I don't have to type so much. 
axis_labels

# Customise angle shape and size using theme() 

axis_labels + theme(axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5))

# change colour of axis title and labels
axis_labels + theme(
      axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5, colour = 'forestgreen'), 
      axis.title.x = element_text(colour = "blue"))

# Truncate axes
ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() # no truncation
ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + ylim(0,2000000)

#Flip Axes
ggplot(mtcars, aes(x=as.factor(cyl))) + 
  geom_bar() +
  coord_flip()

## -- TASK: Flip the axes of one of the plots above. Barcharts make the most sense. 

######### Dots
# to avoid extra typing, create an object called dots and asign the ggplot() function to it so that you just have to add the different geom layers. 
dots <- ggplot(USArrests, aes(x = UrbanPop, y = Assault)) 

# colour 
dots + geom_point(color="firebrick")

# transparency 
dots + geom_point(alpha = 0.2)

# size 
dots + geom_point(size = 5)

# shape 
dots + geom_point(shape = 4) # add a shape name or a number for example 'cross' or '4'. 

## --TASK:how many different shapes can you find?

# All together 
dots + geom_point(colour = "firebrick", size = 3, alpha = 0.5, shape = 5)


######### Background

# Colour 
ggplot(USArrests, aes(x = UrbanPop, y = Assault)) +
  geom_point() # + theme(panel.background = element_rect(fill = 'grey75')) 

## --TASK: Delete the # in the previous plot to chang ethe background colour to a darker grey.   

# Grid lines 
ggplot(USArrests, aes(UrbanPop, Assault)) + 
  geom_point() + 
  theme(panel.grid.major = element_line(colour = "yellow", size=2),
        panel.grid.minor = element_line(colour = "blue"))

# Margins
ggplot(USArrests, aes(UrbanPop, Assault)) + 
  geom_point() + 
  theme(plot.background=element_rect(fill="darkseagreen"))

# all together
ggplot(USArrests, aes(UrbanPop, Assault)) + 
  geom_point() + 
  theme(panel.grid.major = element_line(colour = "yellow", size=2),
        panel.grid.minor = element_line(colour = "purple"), 
        plot.background = element_rect(fill = "darkseagreen"))

######### Themes 
# Themes change the overall style of the plot. You will need the ggthemes() package created by Jeffrey Arnold. You can also change the appearance of the plot using the theme() function. 

#install.packages("ggthemes")
library(ggthemes)

ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_point() + 
  ggtitle("This plot looks a lot different from the default") +
  theme_economist()

## -- TASK: re-create the plot above using a different theme. Type `theme_` and select tab, a drop down list of themes will appear. 


######### Colours 
library(RColorBrewer)
# Colour must be mapped to a variable using aes(), this can be in ggplot() or in geom(). After you've identified which variable will be coloured you can then use one of the `scale......()` functions to define the colours. 

# map colour using aes() within ggplot() - outline colour
colour_outline <- ggplot(iris, aes(Species, Sepal.Length, colour = Species)) +
  geom_boxplot()
colour_outline # note that I created `colour_outline` so we don't have to keep typing the ggplot() function over and over again. 


# add colour using aes() within geom() - fill colour
colour_fill <- ggplot(iris, aes(Species, Sepal.Length)) + 
  geom_boxplot(aes(fill = Species))  
colour_fill

## --NOTE: Colour has not been specified in the previous two plots. The colours in the plots are default settings. 

# specify colour by adding  ` + scale_colour_manual` (outline) or `+ scale_fill_manual` (fill) 
colour_outline + scale_colour_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))
colour_fill + scale_fill_manual(values = c("#00AFBB", "#E7B800", "#FC4E07"))

# specify colour using a palette. Here we use an existing palette. But you can also create your own. 
colour_fill + scale_fill_brewer(palette = "Dark2")
colour_outline + scale_colour_brewer(palette = "Dark2") # see other palettes here - https://www.r-graph-gallery.com/38-rcolorbrewers-palettes/ 


ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() + geom_jitter(width = 0.2) + scale_colour_gradient()
 
# Colours available in R - http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

######### Vertical and Horizontal Lines 

ggplot(USArrests, aes(x = UrbanPop, y = Assault)) + 
  geom_point() +
  geom_hline(yintercept = 200) + 
  geom_vline(xintercept = 80)



#######################################################################



#########################
#      Assessment       #
#########################

#Go back to your plots from the assessment last week and re-design them using the theory from lectures and techniques from the workshop. In the .Rmd file for submission, for each question include your original image at half size with the code hidden (see below how to do this) and the re-designed one with the code printed. For each question give 1 sentence justification for the type of plot you chose (last week’s material) and 1 sentence justification for the aesthetics you chose (this week’s material).  

# Use ` ech0 = FALSE ` in the very top line of a code chunk to stop the code from being shown in the rendered file. 

# Use ` out.width = "70%" ` or ` out.width = "200px" ` . You can use % or pixels (px), both must be in double quotation marks. 

