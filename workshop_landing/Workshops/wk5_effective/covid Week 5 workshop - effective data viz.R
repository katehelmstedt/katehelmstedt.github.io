
#####################################
#         Week 6 MXB262             #
#         Sem 1 2020                #  
#         Effective Data Viz        #
#         Kate Helmstedt            #
#####################################


# Libraries
library(tidyverse)
library(ggthemes)
library(viridis)
library(ggplot2)
library(ggrepel)

## This week, we will be implementing many of the design elements we 
## talked about in lectures. Here our emphasis is not on when they should 
## or should not be used (or the best values for any of them), but on 
## how to implement each in R and ggplot2. The Problem Solving Task assessment
## due next week requires you to marry these two things together -- the 
## theory about when to use them from lectures, and how to implement them 
## in ggplot2 from the workshop. You'll be submitting the plots you designed 
## last week in response to the questions in the .Rmd file 
## 'PS2 part 1 questions.Rmd' plus a re-designed version from this week's 
## content. Please include all responses from last week and this week into 
## one .Rmd file, knit to PDF or html, and upload both as your assignment 
## submission to Blackboard. 


# I am adapting this workshop to pull up-to-date Covid-19 data in. You'll need 
# a couple of advanced packages for this, and you'll need an updated version of
# R (if you downloaded this year, it'll be fine).
# The 'remotes' package lets us download unofficial packages directly
# from the designer through github. This one is so new, it hasn't had time
# to be approved to be made official yet, so that's how we will get it:
install.packages("remotes")
library(remotes)
remotes::install_github('GuangchuangYu/nCov2019') 

# To grab the current data  from the internet (I think it's up to 24 hours old, 
# but pretty current):
current_covid <- get_nCov2019()
historical_covid <- load_nCov2019()

# Examine both by running the `head()` function on each, and typing the name followed 
# by a $ to see what categories it contains. Have a play around with what you can see,
# e.g.
 current_covid$global
 
# I'm going to convert whatever I can in the workshop below to focus on this
# dataset, but some things I need to illustrate don't work as well or aren't as clear,
# so I'll jump back in places to the default datasets I usually use.

# Preparing some data to use later:
 
# Extract Australia's data
global <- historical_covid['global'] # extract global data
Australia <- global[global$country == 'Australia',]

# Extract top 10 country's historical data
n <- global %>% filter(time == time(historical_covid)) %>%
   top_n(10, cum_confirm) %>%
   arrange(desc(cum_confirm))
top10<- global %>% 
   filter(country %in% n$country)
 
global_counts <- current_covid$global
top_global_counts <- global_counts %>% filter(confirm >= 2000) %>%
  arrange(desc(confirm))



#########################
#    What is ` aes() ` #
#########################

# The `aes()` function describes how the data variables are mapped to the `geom()` function. 
# `aes() can be set within `ggplot()` or in the individual `geom()` layers. 
#  When `aes()`` is placed within `ggplot()` the settings becomes the default 
# for all added `geom()`. 
# For example the following two lines of code create the same plot 

# aes() within ggplot()
ggplot(Australia,
        aes(time, cum_confirm)) +
  geom_line() +
  geom_point()

# aes() within geom_point()

ggplot(Australia) +
  geom_line(aes(time, cum_confirm)) +
  geom_point(aes(time, cum_confirm)) # need to include aes() here too, since not overridden in ggplot

# Ignore the warnings about missing values -- the covid19 dataset starts a few days
# before Australia has any recorded cases

# If we have multiple datasets (e.g. multiple countries), we can tell ggplot to 
# include them in the aes() command
ggplot( top10,
        aes(time, cum_confirm, color=country)) +
  geom_line()  


################################
#  Manipulating plot features  #
################################

######### Titles

# using ggtitle()
ggplot(Australia) +
  geom_line(aes(time, cum_confirm))+ 
  ggtitle("Cumultive COVID-19 cases in Australia exponentially increase") 

# split longer titles over two lines 
ggplot(Australia) +
  geom_line(aes(time, cum_confirm))+ 
  ggtitle("Cumultive COVID-19 cases in Australia \n are exponentially increasing in time") 

# add a subtitle
ggplot(Australia) +
geom_line(aes(time, cum_confirm))+ 
  ggtitle("Cumultive COVID-19 cases in Australia exponentially increase", 
          subtitle = "In case you were wondering, this is bad news") 

# use lab() - an altentative to Titles and captions
ggplot(Australia) +
geom_line(aes(time, cum_confirm))+ 
  labs(title = "COVID-19 sucks", 
       subtitle = "this is a subtitle about hating COVID-19", 
       caption = "labs() lets me add a caption but ggtitle() doesn't")

# centre title
ggplot(Australia) +
  geom_line(aes(time, cum_confirm))+ 
  ggtitle("Oh no :|") +
  theme(plot.title = element_text(hjust = 0.5 ))

# adjust text size, make bold, add a margin around title
ggplot(Australia) +
  geom_line(aes(time, cum_confirm))+ 
  ggtitle("Oh no :|")  + 
  theme(plot.title = element_text(hjust = 0.5, size = 20, 
                                  face = "bold", margin = margin(10,0,10,0) ))

## -- NOTE: you can also add titles, subtitles etc within ` theme() `. 
# You can see more here - https://www.datanovia.com/en/blog/ggplot-title-subtitle-and-caption/ 


######### Legends

# Remember that `<-` is how we assign (or store) values or snippets of code to a 
# variable name. You can do this with plots too! Remember though that the line that 
# assigns or stores will NOT then also run the code or print the result -- you need 
# to them type the variable name in order to see the output

# For example
# First store it
test1 <- 3 + 4
# Then display it
test1
# Then use it
test1 + 5

# First store it
g <- ggplot(top10, aes(time, cum_confirm, color=country)) +
  geom_line()  
# Then display it
g
# Then use it:

# turn off legend title
g + theme(legend.title = element_blank()) 

# Change legend colour, size and to bold
g + theme(legend.title = element_text(colour="chocolate", size=16, face="bold")) 

# Change legend title -- here, we need to match the input (i.e. color) to the
# attribute we assigned it to above. See how we used `color = country` here? We
# now use `labs(color = )` to change the title of the legend.
g + labs(color = "This is a different legend title") 
  
# everything together 
ggplot(top10, aes(time, cum_confirm, color=country)) +
  geom_line()  + 
  theme(legend.title = element_text(colour="chocolate", size=16, face="bold")) + 
  labs(color = "Infected country")


######### Axes

# Axis labels 
ggplot(top10, aes(time, cum_confirm, color=country)) +
  geom_line() + 
  labs(x = "Time", y = "Cumulative confirmed cases") 

## -- NOTE: I'll create an object called `axis_labels` so I don't have to type so much.
## Not only am I kind of lazy, but this also helps to make more readable code. The person 
## reading the code just has to read once how I created axis_labels, understand and agree
## with it once, and then doesn't have to see all that code every time.

# First store it
axis_labels <- ggplot(top10, aes(time, cum_confirm, color=country)) +
  geom_line() + 
  labs(x = "Time", y = "Cumulative confirmed cases") 

# Then display it
axis_labels

# Then use it:

# Customise angle shape and size using theme() 
axis_labels + theme(axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5))

# change colour of axis title and labels
axis_labels + theme(
      axis.text.x = element_text(angle = 50, size = 10, vjust = 0.5, colour = 'forestgreen'), 
      axis.title.x = element_text(colour = "blue"))

#### Maniulate axes

# Truncate axes 
ggplot(top10, aes(time, cum_confirm, color=country)) +
  geom_line() + ylim(0,20000)

# Flip Axes
ggplot(top_global_counts, aes(y=confirm, x=name)) + 
geom_bar(position="dodge", stat="identity") 

# flipped
ggplot(top_global_counts, aes(y=confirm, x=name)) + 
  geom_bar(position="dodge", stat="identity") +
  coord_flip()

## -- TASK: Use the method from last week to sort this bar plot 

######### Scatterplot options
# to avoid extra typing, create an object called dots and assign the ggplot() function 
# to it so that you just have to add the different geom layers. 
dots <- ggplot(Australia, aes(time, cum_confirm)) 

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
ggplot(Australia,aes(time, cum_confirm)) +
  geom_line() #  + theme(panel.background = element_rect(fill = 'grey75')) 

## --TASK: Uncomment the previous plot to change the background colour to a darker grey.   

# Grid lines 
ggplot(Australia,aes(time, cum_confirm)) +
  geom_line() + 
  theme(panel.grid.major = element_line(colour = "yellow", size=2),
        panel.grid.minor = element_line(colour = "blue"))

# Margins
ggplot(Australia,aes(time, cum_confirm)) +
  geom_line() + 
  theme(plot.background=element_rect(fill="darkseagreen"))

# all together
ggplot(Australia,aes(time, cum_confirm)) +
  geom_line() + 
  theme(panel.grid.major = element_line(colour = "yellow", size=2),
        panel.grid.minor = element_line(colour = "purple"), 
        plot.background = element_rect(fill = "darkseagreen"))


######################################
#  Themes  #
#####################################

# `theme()` is a useful layer that can be used to customise features of a plot. 
# You can customize the non-data aspects of the plot with themes. 
# Such as font type, font size, title position, subtitle colour, add a caption and many others
# This is a way to keep all plots within your
# document, website, thesis, or publication the same. This of it as a coded style guide -- plots will keep the
# theme and be recognisable as parts of a whole.

ggplot(Australia,aes(time, cum_confirm)) +
  geom_line() + 
  theme_bw()

# ggplot2 has 8 built in themes
# TASK: re-plot the graph with another built-in theme (type "theme_" and options will pop up)

# You can also control the individual components of the plot within a theme, like text size:

ggplot(Australia) +
  geom_line(aes(time, cum_confirm)) + 
  theme(text = element_text(size = 16))

# There's a bunch more in the ggthemes() package created by Jeffrey Arnold. Install and load the package.

# The theme from fivethirtyeight.com
ggplot(Australia) +
  geom_line(aes(time, cum_confirm)) + 
  theme_fivethirtyeight()

# The theme from The Economist
ggplot(Australia) +
  geom_line(aes(time, cum_confirm)) + 
  theme_economist()

# The theme from Excel (why?)
ggplot(Australia) +
  geom_line(aes(time, cum_confirm)) + 
  theme_excel()

## -- TASK: re-create the plot above using a different theme. Type `theme_` and select tab, a drop down list of themes will appear. 


######### Colours 
library(RColorBrewer)
# Colour must be mapped to a variable using aes(), this can be in ggplot() or in geom(). 
# After you've identified which variable will be coloured you can then use one of the 
# `scale......()` functions to define the colours. 

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

ggplot(Australia) +
  geom_line(aes(time, cum_confirm))  +
  geom_hline(yintercept = 1000)

######## Annotations: It can be useful to label individual observations, and groups.
# Replace the legend with in-text
irislabels <- iris %>%
  group_by(Species) %>%
  summarize_all(mean)

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + 
  geom_point() + geom_text(data  = irislabels, aes(x=Sepal.Length, y=Sepal.Width, label = Species)) + 
  theme(legend.position = "none")

# Add a figure number
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + 
  geom_point() + annotate("text", x=4.2, y=4.4, label = "A")

# TASK: Make the annotated "A" larger



# #########################
#    Overplotting       #
#########################
# We're going to create a dataset for this section of the workshop -- it 
# intentionally has overplotting problems, but you'll also see these kinds 
# of problems in your real-world and simulation datasets.

# Dataset:
a <- data.frame( x=rnorm(20000, 10, 1.2), y=rnorm(20000, 10, 1.2), group=rep("A",20000))
b <- data.frame( x=rnorm(20000, 14.5, 1.2), y=rnorm(20000, 14.5, 1.2), group=rep("B",20000))
c <- data.frame( x=rnorm(20000, 9.5, 1.5), y=rnorm(20000, 15.5, 1.5), group=rep("C",20000))
synthetic_data <- do.call(rbind, list(a,b,c))               

# Oveplotting is common and occurs when your dataset is too large. 
# See the following scatterplot of the data we just created.  
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point() 

# There doesn't seem to be a relationship between x and y. But if you 
# explore the following steps for addressing overplotting, you will 
# see a relationship emerge. 

# First, when we suspect there might be an overplotting issue, we can view the 
# point density using the ggplotpointdensity package. Install it and load the
# library now. Then:
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_pointdensity() 

# We can see areas of high density here (in lighter blue with this default
# colour scheme). Now that we have identified an overplotting issue, there are a 
# couple of options for viewing the data in a more representitive way:

### 1. Dot size
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(size = 0.2) 

### 2. Transparency
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(size = 0.2, alpha = 0.01) 

## -- Q. what argument manipulated transparency? is it in ggplot() or in geom_point()?
## -- Q. increase the dot size, does this improve the plot?
## -- TASK: try a few different combinations of `alpha` and `size`.

### 3. Sampling
# Sometimes less is more. Plotting a subset of the data (5% here) can help avoid overplotting, 
# and can also greatly reduce the computing time.   

# take a sample of the data
synthetic_data_subset <- sample_frac(synthetic_data, 0.05)

ggplot(synthetic_data_subset, aes(x=x, y=y)) +
  geom_point(size=2)

## -- Q. did this help you see the data? Did you lose much information? When might this not be a good idea?

### 4. Grouping with colour
ggplot(synthetic_data, aes(x=x, y=y, color=group)) +
  geom_point( size=2, alpha=0.1) +
  scale_color_viridis(discrete=TRUE) 

# -- NOTE: the colour argument is within the ggplot( aes() ) function and not in geo_point(). 
# Also that `group` is a variable in the data set (look back up at where we simulated it), 
# and not a specific colour. 

### 5. Highlighting just one group ###
# This assumes there is a grouping variable in the data set. 
ggplot(synthetic_data, aes(x=x, y=y)) +
  geom_point(color="grey", size=2) +
  geom_point(data = synthetic_data %>% filter(group=="B"), color="#69b3a2", size=2)

## -- Q. what argument in geom_point() changes the colour? Test what other common colour names work. 
## -- Q does the Australian/UK spelling of colour work as well?
## -- Q can you put the colour argument in the ggplot() function instead of geom_point()?
## -- Q. Can the colour argument in geom_point() be set to `group`, similarly to No. 4 above?

### 6. Jittering ###
# Here's the example of jittering that we saw last week. This is another way to deal with overplotting

ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() 
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() + geom_jitter(width = 0.2)


#######################################################################



#########################
#      Assessment       #
#########################

## See the Rmarkdown file for details on Problem Solving Task 2 (will be released in Week 6)
