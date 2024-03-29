
####################################################
#                                                  #
#                                                  #
#    Week 7:  Visualising High Dimensional Data    #
#                                                  #
#                                                  #
####################################################


# Libraries
## Load all the packages. Use install.packages("") to install any that don't load. I'd do these one by one
# to see which you do and don't have the first time!
# 

library(tidyverse)
library(kableExtra)
library(babynames)
library(viridis)
library(DT)
library(gridExtra)
library(ggrepel)
library(fmsb)
library(colormap) 
library(patchwork)
library(GGally)
library(ggquiver) 
library(gapminder)
library(ggalluvial)
library(hrbrthemes) # NOTE for mac users: if hrbrthemes is throwing an error for you, you need to install XQuartz https://www.xquartz.org/

#################### SOME NEW FUNCTIONS FOR MANIPULATING DATA ##################

## -- TASK: look up each of the following functions and add a short description of 
# what they do (for your future reference only). 
# Use `?` in the console, the help tab, rstudio cheat sheets, 
# the R4ds book (https://r4ds.had.co.nz/) (we worked through this chapter in previous workshops) 
# or the internet to look them up.

# %>% - pipe
# package: magrittr
# function: 

# %in% - match
# package: base
# function: 

# mutate() - 
# package: dplyr
# function: 

# filter() - 
# package: dplyr
# function: 

# select() - 
# package: dplyr
# function: 

# arrange() - 
# package: dplyr
# function: 


#################### FACETING ###################################### 
# DATA: babynames
# VIS PACKAGE: ggplot2

# The following code creates a subset of the babynames dataset using filter().
US_names <- babynames::babynames %>% 
      filter(name %in% c("Mary","Emma", "Ida", "Ashley", "Amanda", "Jessica",    "Patricia", "Linda", "Deborah",   "Dorothy", "Betty", "Helen")) %>%
      filter(sex=="F")

# A spaghetti plot
ggplot(US_names, aes(x=year, y=n, group=name, color=name)) +
      geom_line() +
      scale_color_viridis(discrete = TRUE) +
      theme(plot.title = element_text(size=14)) +
      ggtitle("A spaghetti chart of popular US names") 

# Its a bit hard to see all the different lines, lets make it clearer and highlight one particular name, and label it: 
# add a new variable (column) called highlight to the dataset using mutate()
US_names_highlight <- US_names %>% 
      mutate(highlight = ifelse(name=="Amanda", "Amanda", "Other"))

# Be patient! This one is a bit slow to load
ggplot(US_names_highlight, aes(x=year, y=n, group=name, color=highlight, size=highlight)) +
      geom_line() +
      scale_color_manual(values = c("#69b3a2", "lightgrey")) +
      scale_size_manual(values=c(1.5,0.2)) +
      theme(legend.position="none") +
      ggtitle("Popularity of US names in the previous 30 years") +
      geom_label( x=1990, y=55000, label="Amanda reached 3550\nbabies in 1970", size=4, color="#69b3a2") +
      theme(plot.title = element_text(size=14))

## -- Q. What does geom_label() do?
## -- Q. What does scale_size_manual() do?
## -- TASK: go through each line of the code in the plot above. Do you know what each function is doing? 
# If not, refer back to last week's workshop to find out. Add a comment using `#` to each line about what 
# the code is doing. 

##### -- Highlighting focuses on one line, but what if we want to see them all? Faceting can help with this. 

# A faceted plot
ggplot(US_names, aes(x=year, y=n, group=name)) +
  geom_line() +
  ggtitle("Popularity of US names in the previous 30 years") +
  facet_wrap(~name)

# It's not the nicest plot, lets make some changes
## -- TASK: Change geom_line() to geom_area()
## -- TASK: add `fill = name` into aes() within ggplot()
## -- TASK: change the colours using `scale_fill_brewer()` see the help file for palettes. 
## -- TASK: Customise one other element of the plot using `theme()`. use the help menu to look up `theme()` 
# and see the different arguments that can be used.

##### Combine approaches 
# Create a new dataset called US_names_repeated, make it the same as the US_names dataset but create one more 
# variable (column) called name_repeated
US_names_repeated <- US_names %>%
  mutate(name_repeated=name)
# This was just to get around the fact that ggplot won't let us use the same variable for 
# two things sometimes, so we just replicated a column so we can use it twice

ggplot(US_names_repeated, aes(x=year, y=n)) +
  # first, we will plot all the name curves in grey
  geom_line( data=US_names_repeated %>% dplyr::select(-name), aes(group=name_repeated), color="grey", size=0.5, alpha=0.5) +
  # then, we will plot only the name from that facet in blue
  geom_line( aes(color=name), color="#69b3a2", size=1.2 )+
  scale_color_viridis(discrete = TRUE) +
  theme(
    plot.title = element_text(size=14),
    panel.grid = element_blank()
  ) +
  ggtitle("A spaghetti chart of popular US names") +
  facet_wrap(~name)


##################### MULTI-DIMENSIONAL SCATTERPLOT ########################

##### Bubbleplot
# DATA: gapminder
# VIS PACKAGE: ggplot2

## -- Pepare the data: subset, order and add a new variable to the gapminder data using the code below.
gapminder_data <- gapminder %>% 
  filter(year=="2007") %>% 
  dplyr::select(-year) %>%
  mutate(pop=pop/1000000) %>%
  arrange(desc(pop)) %>%
  mutate(country = factor(country, country))

## -- TASK: go through each line of code above and make sure you understand what each line is doing to the data. 
## -- Q. why is `select()` written like this `dplyr::select()`.

# use glimpse() or head() to inspect and compare gapminder with gapminder_data. 
glimpse(gapminder)
glimpse(gapminder_data)
head(gapminder_data)

# Generate bubble plot
ggplot(gapminder_data, aes(x=gdpPercap, y=lifeExp, size = pop, color = continent)) +
    geom_point(alpha=0.7) +
    scale_size(range = c(1.4, 19), name="Population (M)") +
    scale_color_viridis(discrete=TRUE, guide=FALSE) +
    theme_ipsum() +
    theme(legend.position="none") 
  
## -- TASK: Add a plot title and change the axis labels so they are clearer.
## -- TASK: What could you remove from this code to make the country legend appear? What would you change to place the population bubble size legend at the bottom of the plot?
## -- TASK: Remove the population variable from the plot. 
## -- TASK: Create two different versions of this plot which map the variables differently. for example life expectancy on the x axis. 

############################# EMOJIS  #############################
# load the `emoGG` package -- this is not an official package, but it is still great! This is often the case before
# packages have gone through the long approval process. We can install directly from the developer using the 
# devtools package (which  you will need to install and load). Then:

devtools::install_github("dill/emoGG") # (if asked about updating other packages, select 'CRAN only')
library(emoGG)

# a simple dot plot without emojis
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_point()

# re-create dot plot with emojis
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_emoji(emoji="1f337")

# Use `emoji_search` to find the id number for different emojis. 
emoji_search("flower")

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_emoji(emoji="1f940")


#####################  RADAR PLOT  ########################
# DATA: create dummy data
# VIS PACKAGE: fms

# Create synthetic data for the radar plot using the code below 
set.seed(1)
grades_data <- as.data.frame(matrix( sample( 2:20 , 10 , replace=T) , ncol=10))
colnames(grades_data) <- c("maths" , "english" , "biology" , "music" , "R-coding", "data-viz" , "french" , "physics", "statistics", "sport" )

# Take a look at the format of the data we created
head(grades_data)

# each subject in the dataset (column) has to have a max and min for the fms package to be able to draw the plot. the following line of code adds a row of 20 and a row of 0 to the data frame. The first argument `re(20,10)` add a row of 20 replicated 10 times.  

grades_data <- rbind(rep(20,10) , rep(0,10) , grades_data)

# Create a basic radarChart
radarchart(grades_data, 
           title = "Spider Plot of Student Grades")

# Add axis labels 
radarchart(grades_data, 
           title = "Spider Plot of Student Grades",
           axistype=1, # specify the position of the label (select anumber between 0 and 6)
           caxislabels=seq(0,20,5) # set the range of the axis labels
)

#Change polygon and grid line colour
radarchart(grades_data, 
       title = "Spider Plot of Student Grades",
       axistype=1, # axis label position (select anumber between 0 and 6)
       caxislabels=seq(0,20,5),# set the range of the axis labels
       pcol = "forestgreen", # polygon colour. 1 to 8, rgb code `rgb( 0.2,0.5,0.5,0.9)`, colour name
       cglcol="grey" # gridline colour   
) 

# There are many other functions that you can use to customise these plots. Here is an example. type `??radarplot` into the console to see a list of all the arguments. 
radarchart(grades_data, axistype=1, 
           pcol=rgb(0.2,0.5,0.5,0.9) ,  # draw the polygon
           cglcol="grey", # set the polygon colour
           cglty=1, # define the line used to draw the polygon
           axislabcol="grey", # define axis label colour
           caxislabels=seq(0,20,5), # set the range of the axis labels
           cglwd=0.8, # grid line width 
           vlcex=0.8, # text size of labels 
           pfcol=rgb(0.2,0.5,0.5,0.5)
)

## -- TASK: change the colour and thickness of the polygon line. 
## -- TASK: Change one other feature (e.g grid line colour or thickness, or type of grid lind label. 
## -- TASK: remove the shading inside the polygon.


########## Two polygons
### -- How can we compare the grades of two students using a spider plot? One solution is to overlay them like the plot below. 

# create data
grades_data_2 <-as.data.frame(matrix( c( sample( 2:20 , 10 , replace=T), sample( 2:9 , 10 , replace=T)) , ncol=10, byrow=TRUE))
colnames(grades_data_2) <- c("math" , "english" , "biology" , "music" , "R-coding", "data-viz" , "french" , "physic", "statistic", "sport" )
grades_data_2[2,2]=19

# add min and max to each subject like the first spider plot
grades_data_2 <-rbind(rep(20,10) , rep(0,10) , grades_data_2)

# Prepare polygon colours
colors_border = c(rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9))
colors_in = c(rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4))

# Customise the radarChart
radarchart(grades_data_2, axistype=1,
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=4, plty=1 , 
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,20,5), cglwd=1.1,
            #custom labels
            vlcex=0.8)

# add a Legend
legend(x=0.85, y=1, legend = c("Shirley", "Sonia"), bty = "n", pch=20 , col=colors_border , text.col = "black", cex=0.9, pt.cex=1.6)

### But this won't work for more than 2 or 3 students. Facetting could address this for a larger dataset. 

#####################  PARALLEL COORDINATES PLOT  ########################
# DATA: iris
# VIS PACKAGE: GGally (ggparcoord() function)

# There is no geom in ggplot to create a parallel coordinate plots, so we will use ggparcoord from the GGally package. The structure of the arguments in ggparcoord() is designed to be very similar to ggplot 
## -- Note: A arallel plot is the equivalent of a spider chart, but with cartesian coordinates. Thus, it is often prefered.

# Lets have a look at the final plot to start with 
ggparcoord(iris, columns = 1:4, groupColumn = 5, order = "anyClass", 
           scale= "globalminmax", showPoints = TRUE, title = "Parallel Coordinate Plot for the Iris Data", alphaLines = 0.3) + 
    scale_color_viridis(discrete=TRUE) +
    theme(plot.title = element_text(size=10))

# lets break this graph down to the minimum required elements 
ggparcoord(iris, columns = 1:4, groupColumn = 5) 

## -- TASK: re-create the first graph by adding each argument or function one by one. Add a description of what each of them do below. 

## arguments that go in aes()
# 1. order = :
# 2. showPoints = :
# 3. alphaLines = :
# 4. scale = :
## functions
# 5. + scale_color_viridis() :
# 6. + theme(plot.title = element_text(size = )) :


## -- TASK: Add x and y labs to the parrallel coordinates plot above. the xlab() and ylab() functions from ggplot will work here. 
## -- TASK: The first plot uses `scale = "globalminmax". Use ??ggparcoord to find what other scales you can use. Try at least two different scales. 

## NOTE: AXIS ORDER - optimizing the order of vertical axis can make the plot clearer. The general aim is to minimise the number of line crossings. 

# See the next two figures, the second is much easier to interpret. Variable order is the only difference.

## order = c(1:4)
ggparcoord(iris,
    columns = 1:4, groupColumn = 5, order = c(1:4),
    showPoints = TRUE, 
    title = "Original",
    alphaLines = 0.3
  ) + 
  scale_color_viridis(discrete=TRUE) +
  theme(
    legend.position="Default",
    plot.title = element_text(size=10)
  ) +
  xlab("")

## order = "anyClass
ggparcoord(iris,
    columns = 1:4, groupColumn = 5, order = "anyClass",
    showPoints = TRUE, 
    title = "Re-ordered",
    alphaLines = 0.3
  ) + 
  scale_color_viridis(discrete=TRUE) +
  theme(
    legend.position="none",
    plot.title = element_text(size=10)
  ) +
  xlab("")

## -- TASK: what other `order` can you use? See the help file for ggparcoord

#####################  ALLUVIAL DIAGRAM / SANKY PLOT ########################
# DATA: UCBAdmissions
# PACKAGE: ggalluvium()
# NOTE: alluvial plots require some customisation, they are a little more tricky than the geoms in ggplot(). You will have seen some of the functions below, such as `scale_fill_brewer()` in last weeks workshop

UCB <- as.data.frame(UCBAdmissions)

#have a quick look at the data
glimpse(UCB)
head(UCB)

# One of the massive benefits of ggplot2 is that it can build plots up iteratively, by combining
# multiple discrete functions using `+`. Throughout this workshop, we are going to take advantage of that
# and assign parts of plots to variable names to minimise typing. Remember that in R, 
katerules<-10
# assigns the number 10 to the variable name katerules. Now when I type
katerules
# I just see 10. And I can use it as if it is 10:
katerules+3
# Plots work the same. In this first example, we will assign a line plot to the name 'alluvial_0'.
# Assigning it is not the same thing as running it! To then see the plot, we need to type the 
# variable name into the console, which will print the saved plot.

# map the variables using ggplot()
alluvial_0 <- ggplot(UCB, aes(y = Freq, axis1 = Gender, axis2 = Dept))
alluvial_0

# add geom_alluvial(), use `fill = admit`` to add colour, and `width` to set the width of the layers (stratum)
alluvial_1 <- alluvial_0 + geom_alluvium(aes(fill = Admit), width = 1/12)
alluvial_1

# add axis bars and label them. `width` sets the width of the vertical bars
alluvial_2 <- alluvial_1  + 
  geom_stratum(width = 1/12, fill = "black", color = "grey") + # adds verticle bar with grey outline and black fill. 
  geom_label(stat = "stratum", infer.label = TRUE) # labels the axis bars
alluvial_2

# change labels on the x axis
alluvial_3 <- alluvial_2 +
  scale_x_discrete(limits = c("Gender", "Dept"), expand = c(.05, .05))
alluvial_3

# Plot 4 - Change colour of layers 
alluvial_4 <- alluvial_3 + 
  scale_fill_brewer(type = "qual", palette = "Set1") 
alluvial_4

## -- TASK: write out the entire final plot without any of the 'alluvial_' assigned variables, and verify it produces the same plot 
## -- TASK: add a title to the plot. 
## -- TASK: change the colour - use ??RColorBrewer to find a list of inbuilt palettes (half way down page)


########### VECTOR FIELDS #############

# Quiver plots of mathematical functions
# A quiver plot displays velocity vectors as arrows with 
# components (u,v) at the points (x,y).

# First, explore some of the functions and elements we will use here:
# (note that we aren't saving any of these, I'm just giving you an idea
# of how we would explore what's happening in the code below -- useful
# for this specific example, but also good practice every time you
# come across a complex function with sub-components that you haven't seen
# before)
seq(from=0,to=pi,length=13)
expand.grid(x=seq(from=0,to=10, length=11), 
            y=seq(from=0,to=30, length=11))

# Now the actual function (remember that the pipe operator says
# 'use that as the first input variable in the next function)

# First, we need to define all of the points at which we want an arrow to start 
# -- this describes the density of the arrows in the final plot (you can play with this 
# by changing the start point, end point, and the length of the vectors x and y here). 
# There will be as many arrows as there are rows in the data, and each row of the data needs
# to have two entries -- one giving the x position of the start of the arrow, and one
# giving the y position of the start of the arrow.
expand.grid(x=seq(from=0,to=pi,length=13), 
            y=seq(from=0,to=pi,length=13)) %>%
  # Feed that into a ggplot function that also defines the mathematical
  # functions defining u and v, which determine the length and direction of the arrow
  ggplot(aes(x=x, y=y, u=cos(x), v=sin(y))) +
  # And finally, feed these into the geom from the ggquiver package, geom_quiver
  geom_quiver()

# As with any vector field, the functions for u and v can be any functional combination of x and y:
expand.grid(x=seq(from=0,to=10,length=11), 
            y=seq(from=0,to=10,length=11)) %>%
  ggplot(aes(x=x, y=y, u=x^2-y, v=x+y^2)) +
  geom_quiver()

# TASK: play with different densities of arrows to generate plots of the vector field in the lecture slides on 
# the slide titled "Main viz choice: density"
