#####################################
#         Wk 5 MXB262               #
#         Sem 1 2020                #  
#         1D, 2D Data Viz           #
#         Dr Kate Helmstedt         #
#####################################

# This week we are going to work with an R script instead of an R Markdown file. 
# An R script doesn't have nicely formatted text, and interprets everything as 
# # R code unless it is commented. This is just like an m file in matlab.
# To write a comment use the # at the start of the line. 
# When you run a specific piece of code, the output will appear in the console 
# or the plot will appear in the plot window.

# Scripts are just another way to save R code. You can think of their use a little
# like the difference between exploratory vs explanatory data visualisation.
# When you're just working on your own code and exploring it, creating an R script
# like this one is a really efficient way top keep all your code in one place and 
# comment to yourself and future users of the code. However, hopefully you can see
# that reading these comments isn't as nice as reading a knitted R markdown file, so
# when we prepare R code for presenting to an audience (e.g. your tutors, boss,
# or client; report readers, or blog readers), it's better to use R markdown so you
# can intersperse the code with explanatory text and images.

# To run a whole script, press the 'Run' button in the top right. This isn't helpful
# today, because you need to follow along and see each plot, but for large sections of
# code in your future, that'll be useful. Notice though that errors are hard to spot,
# so you'd only ever run a whole script when you have fully de-bugged and verified it.
# I very rarely run an entire script at once.

# To run a section of code, highlight that section and click 'Run', or 
# copy-paste it into the console. Command + enter runs the current line or selection of code.

# Code for generating a selection of the plots is below. 
# Work through each of the plots and complete the associated activities 
# for each.

# None of these plots or questions need to be submitted for the PS2 assessment, 
# so after you've finished the activities in this script you can see the PS2 questions
# in the R markdown file and continue working on those.

#####################################################################################


#### Set-up #### 

# I suggest keeping a .R file with the installation and loading of the packages you use
# most often. This section of code can be your starter pack -- consider saving it somewhere
# accessible and adding to it as we go. That way, when you change computers you can install
# all your precious packages at once, and at the start of each session you can load them
# back up. I suggest running each `library()` line one by one (put cursor in the line and
# press command + enter) so you can see whether there was an error. This is my standard
# practice, even years into my relationship with R. 

# If any of the packages below don't load using the libary() command, you'll need to 
# install them first on your current computer. 

#install.packages("rwalkr")
#install.packages("ggmosaic")
#install.packages("dplyr")
#install.packages("grattan")

library(ggplot2)
library(devtools)
library(rwalkr)
library(ggmosaic)
library(dplyr)
library(grattan)
library(magrittr)

# Datasets -- today we are using in built datasets for the most part, although towards 
# the end of the activity there are some more that you'll need to load in.
# These datasets are already installed, so you don't need to do anything extra to get them.
# They tend to be nice and clean, and designed well to illustrate specific aspects people need
# to learn and practice in data analysis, data wrangling, and data visualisation.

# You can see the names of all the datasets you have currently loaded (both
# in built in R and those that come along with the packages you've already loaded):

data()

# You can take a quick peek at the datasets using the incredibly useful head()
# command, which shows the first 6 entries of any data (regardless of what  class of data
# it is). Read these lines in one by one (highlight and click Run, or copy paste) to 
# view them, see what the columns refer to, and preview the kind of information stored
# in each entry. These are the main datasets we will used today:

head(mtcars)
head(quakes)
head(mpg)
head(Orange)
head(USArrests)
head(PlantGrowth)
head(Titanic)

# Another dataset that might be interesting to you is 
install.packages("coronavirus")
library(coronavirus)
head(coronavirus)
# Note that this is old data -- if anyone finds an up-to-date data source in package form, let us all know!

############################ 1. CATEGORICAL DATA ##################################################

###
## Barplot  
###

# DATASET: mtcars

# For each of these types of visualisations, we'll give you the ggplot2 command and then
# some questions that require you to explore the visualiation. Run the ggplot2 command, 
# and then edit that line of code to do the questions. You don't need to submit these
# questions, but it'd be useful for you to store the commands here for your own future 
# reference (and don't forget to save this R script). 

ggplot(data = mtcars, mapping = aes(x = as.factor(cyl))) + 
  geom_bar()
 
# --  Q: Use your arrows to move over each bracket, and notice that RStudio will highlight
#           the corresponding bracket. This lets you see how expressions are grouped.
#           Where does the ggplot() command finish? Why does R know to expect more code? 
# --  Q: Try placing line breaks (i.e. press enter) at a few extra spots in the line
#           of code. Does it always work? Can you find a spot that you can put a line break
#           that stops the command from working?
# --  Q: Why has the function `as.factor()` been applied to the `cyl` 
#           variable in the example above? Hint: think about what kinds of data go into
#           bar charts, and you can type '?as.factor' into the console to pull up the 
#           help menu for that command.

# --  TASK: Use `head(mtcars)` to see what other variables are in the dataset. Create 
#           a new barchart using a different variable in mtcars. 


###
## Ordered Barplot 
###

# Let's do some light manipulation of the mtcars dataset, by summarising the variables.
# This first part is not explicitly so that we can build an ordered barplot, but 
# instead is giving us an opportunity to explore the data and learn about pipes.

head(mtcars)

# Notice that there are only a few options for what the 'carb' variable can be (1-8,
# although you can only see 1, 2, and 4 in these first 6 entries). It'd be useful to see
# what the mean mpg is for each value of carb, so we can test whether these variables 
# are related. The summarise() command can be used here, which is part of the dplyr
# package you loaded earlier. Type ?summarise into the console to see the options for
# how you can summarise the variables (e.g. mean, median, sd, IQR, min, max, etc).

# For a simple count of how many cars there are, run

summarise(mtcars, n())

# The first entry is the dataset, and the second is the summary function you'd like to use.
# We can do more interesting things by grouping the data though. Let's count how many
# cars are in each carb category by using the group_by() function:

summarise(group_by(mtcars,carb), carcount=n())

# In this syntax, I have named the column we are creating with the number of cars 'carcount'.
# So there are 7 cars with carb=1, and 1 car with carb=8. Instead of just counting
# the number of cars, we can explore the relationship between carb and mpg by calculating
# the mean mpg of each of those groups of cars, and store this as the varible name 'carstest':

carstest <- summarise(group_by(mtcars, carb), mpg=mean(mpg))

# Alternatively, this same line of code can be written using the pipe operator, %>%.
# You've seen this a few times, and can basically be thought of as the word 'goes into'.
# So the code below is saying 'mpg goes into the function group_by(XX, carb) as the first
# input variable in the function. That whole function then goes into the function 
# summarise(XX, mpg=mean(mpg)) as the first input variable.
# This is exactly the same as the previous line of code, but some people find it easier
# and neater to use the pipe operator, because you can then build the nested functions
# more clearly. For now, use either form (but you will need to know how to read both).

cars <- mtcars %>% # create a new object containing a summary of mtcars
  group_by(carb) %>% # group by the carbs variable (no. carburetors), and manufacturer
  summarise(mpg=mean(mpg)) # calculate mean mpg for each carb category

# You can verify that carstest and cars are the same by typing each name into the console
# to print them in their entirety.

carstest
cars

# You've stored these two datasets now as data frames with labelled columns, so you can 
# view each column separately using the $:
cars$mpg
cars$carb
  
# There's no way to just automatically order barplots by length or frequency, although
# this is often something we want to do to make the figure clearer. Instead, we need
# to actually rearrange the data, and store the rearranged version back into the 
# dataset.

# Arrange the dataset in increasing order of the mpg variable
cars$carb <- factor(cars$carb, levels = cars$carb[order(-cars$mpg)])

# Create an ordered plot
ggplot(data=cars, aes(x=carb, y=mpg)) +
  geom_bar(stat="identity")

# Depending on what your data looks like, this can be more difficult.
# I'll make some fake data to explore, where it's not so simple to order the bars:
stg <- data.frame(StudentID = c( rep("A", 2), rep("B", 3), rep("A", 2), rep("C", 5), rep("D", 2)  ),
                  SectorID  = c(rep("Team_1", 3), rep("Team_2", 3), rep("Team_3", 5), rep("Team_1", 3)),               
                  ClassID     = c(rep("Class_1", 7), rep("Class_2", 7) )            
)

#T ake a look at that data, and plot it as a simple unordered bar plot

head(stg)
ggplot(stg, aes( x = stg$StudentID) ) + geom_bar()

# First, let's examine the data we will be plotting a bit more carefully
class(stg$StudentID)

# The class of this data is `factor` -- great! Remember that's R's way of saying
# it's a categorical variable, which is what we need for a bar plot.
# 
head(stg$StudentID)

# You can see that this categorical variable has four `levels`, i.e. possible
# values: `A`, `B`, `C`, and `D`. The unordered bar plot above just put them 
# in alphabetical order, but we want to sort them by the bar height (i.e. their 
# frequency). We will create a new data frame that stores the count of each level

cnt <- count(stg$StudentID) # make it
cnt # examine it

# Note that there are two columns: `x` (which is the name of the level), 
# and `freq` (the frequency of the level -- i.e., the height that will be 
# shown in the bar plot). Look now at the object that stores the frequencies:
cnt$freq

# This is where the fequencies are stored -- this is what we want to use to order 
# the bars. In its current form, the order of cnt$freq is `[freq of A, freq of B, 
# freq of C, freq of D]`. We can use the function `order()` to put those in 
# numerical order for us. The output of `order()` is a sorted list of the indices, 
# in ascending order. For example, if we perform 
order(c(10,8,9)) 

# the output is 2 3 1 -- this is telling us that the second entry in `c(10,8,9)` 
# is the smallest, then the third, then the first.

# If we perform (and note that we aren't storing this variable anywhere, 
# just seeing what happens),
order(cnt$freq)
# we see that the fourth entry is the smallest, then the second, then the first, 
# then the third entry is the largest. If we want to know what levels these 
# correspond to (remembering that those are stored in `cnt$x`), we can look up 
# each of the names of the levels corresponding to the indices, by

cnt$x[order(cnt$freq)]

# So, `D` is the smallest, then `B`, then `A`, then `C`. We can use that 
# ordering function to reorder the elements in `stg$StudentID`:
stg$StudentID <- factor(stg$StudentID, 
                        levels = cnt$x[order(cnt$freq)])

#And when we plot it, we will see the bars have been reordered:
ggplot(stg, aes( x = StudentID) ) + geom_bar()

# There was a lot of info there, to make the steps clear. 
# Jumping just straight to the plotting function, we could have just used this 
# snippet (and this is what you can adapt and build from now that you know what 
# it's doing):
  
stg$StudentID <- factor(stg$StudentID, 
                        levels = cnt$x[order(cnt$freq)])
ggplot(stg, aes( x = StudentID) ) + geom_bar()

# And if instead you'd like them to be sorted in descending order:

stg$StudentID <- factor(stg$StudentID, 
levels = cnt$x[order(cnt$freq, decreasing=TRUE)])
ggplot(stg, aes( x = StudentID) ) + geom_bar()


###
# 2D - Two categorical variables
###

###
## Mosaic Plot
###

# We didn't explicitly cover mosaic plots in the lecture, but this is a plot people
# really like, so take a second to explore it here. Mosaic plots require the ggmosaic
# package, so make sure you've loaded it for this section. Note that a lot of
# additional packages start with 'gg', indicating that they have been made explicitly
# to fit together and play nicely with the ggplot2 methods, features, and whole ecosystem.

# Mosaic plots split the whole dataset into sections based on multiple categories. The
# titanic data used below uses two categories: did they survive, and what class were they in?

library(ggmosaic)

# DATASET: titanic

# Prepare the dataset
# The inbuilt Titanic dataset is stored as a table, which you can see:
class(Titanic) # to print just the type of data it is
Titanic # to print the whole thing

# but ggplot2 needs tibbles or dataframes to plot. It's easy to just convert a well-labelled
# table into a data frame using as.data.frame():
titanic <- as.data.frame(Titanic)

# In that new data frame, the variable indicating whether each person survived or not
# is now stored as a factor, which we need for categorical plots (recall from lecture)
class(titanic$Survived) # to print just the type of data it is
titanic$Survived # to print the whole thing

# generate mosaic plot
ggplot(data=titanic) +
  geom_mosaic(aes(weight=Freq, x=product(Class), fill=Survived))

# --  TASK: Switch the variables indicating whether the passenger survived or not, and the
#           varibale indicating their class. Does this plot give different information?
# --  TASK: Use `head(titanic)` to see what other variables are in the dataset. Instead of
#           colouring based on whether the passenger survived or not, colour based
#           on whether the passenger was an adult or child. Has this given any additional
#           information?


# 2D - Discrete/Categorical X, Continuous Y

###
## Barplot
###

# DATASET: dummy_data (created)
# Create a dummy dataset (dummy data means fake or made up)
species=c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition=rep(c("normal" , "stress" , "Nitrogen") , 4)
value=abs(rnorm(12 , 0 , 15))
dummy_data=data.frame(species,condition,value)

# Grouped barplot
ggplot(dummy_data, aes(fill=condition, y=value, x=species)) + 
  geom_bar(position="dodge", stat="identity")


# Stacked barplot
ggplot(dummy_data, aes(fill=condition, y=value, x=species)) + 
  geom_bar( stat="identity")

# Stacked Percent barplot
ggplot(dummy_data, aes(fill=condition, y=value, x=species)) + 
  geom_bar( stat="identity", position="fill")

###
## Scatter plot
###

# DATASET: ToothGrowth
# First, familiarse yourself with the dataset
head(ToothGrowth)

# Figure out what len, supp, and dose mean by pulling up the help file

?ToothGrowth

# Plot relationship between supplement category and tooth length:
ggplot(ToothGrowth, aes(x = supp, y = len)) + 
    geom_point() 

# -- Add jitter to reveal all the data points `geom_jitter()`, which avoids overplotting

ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() + geom_jitter(width = 0.2)

# -- Q: How do you change the size of the jitter?
# -- TASK: Use a scatterplot to explore the relatinship between length
#       and a different variable. Use `head(ToothGrowth)` to see what other 
#       variables are in the dataset. 
# -- Q: Which categorical variable seems to have the biggest effect on tooth length?

#####
### Box Plots
#####

#DATASET: ToothGrowth

# First, a basic box plot (hiding the data we saw before)
ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_boxplot() 

# Now let's stop hiding that data! Dot + Box plot 
ggplot(ToothGrowth, aes(supp, len)) + 
  geom_boxplot() + 
  geom_dotplot(binaxis='y', 
               stackdir='center')

# -- TASK: Use a box and dot plot to explore the relatinship between length
#       and a different variable. Use `head(ToothGrowth)` to see what other 
#       variables are in the dataset. 

#####
### Violin Plots. 
#####

ggplot(ToothGrowth, aes(x = supp, y = len)) + 
  geom_violin() 

# -- TASK: Add the boxplot to the center of the violin plots (i.e. show both). Note that
#         you can change the width of the boxplots by half by setting 'width=0.5' into the 
#         geom function. Choose a width that works to not obscure any information.
# -- TASK: Create a Dot + Violin plot.

####
## Lollipop Chart
####

# DATASET: mpg
# Calculate average City Miles per Gallon.
cars <- mpg %>% 
  group_by( manufacturer) %>% 
  summarise(cty = mean(cty))

# plot
ggplot(cars, aes(x=manufacturer, y=cty)) + 
  geom_point(size=3) + 
  geom_segment(aes(x=manufacturer, 
                   xend=manufacturer, 
                   y=0, 
                   yend=cty)) 

######################################### 2. CONTINUOUS DATA ###########################################


## Histogram      
# DATASET: mpg , PlantGrowth

ggplot(mpg, aes(cty)) + 
  geom_histogram()

ggplot(PlantGrowth, aes(weight)) + 
  geom_histogram(binwidth = 0.2)

# The number of bins in a ggplot histogram is automatically set to 30. 
# You often need to adjust this by adding `binwidth = `, or `bins = `. 
# -- TASK: Remove `binwidth = 0.2` from the PlantGrowth histogram above and 
#           see what the default plot looks like. 
# -- TASK: Add bins command to the mpg histogram, try a few different numbers. 

###
## Density Plot  
###

# DATASET: mpg
ggplot(mpg, aes(cty)) + 
  geom_density()

# -- TASK: Create a density plot for a different variable within mpg. 

###
# 2D - Both Continuous
###

####
### Scatter Plot
####

# DATASET: USArrests

# First, familiarise yourself with the dataset
head(USArrests)

ggplot(USArrests, aes(x = UrbanPop, y = Assault)) + 
  geom_point()

# -- TASK: connect each of the dots using geom_line(). In this case, does it make sense to
#     join the points together using a line? Has this added clarity?

### Smooth (lm)
# DATASET: midwest

# First, familiarise yourself with the dataset
head(midwest)

ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point() #+ 
  #geom_smooth() #+ 
  #ylim(0, 50000)

# -- TASK: Remove the comments for geom_smooth to add a linear model trend line
# -- TASK: Remove the comments to limit the populations to 50,000, which will remove the outlier
# -- TASK: Reduce the x axis to explore cities with areas only up to 0.1.

########################################## 3. TIMESERIES ######################################

# -- Using the `rwalkr` package you are going to collect your own data from 
# Melbourne city's pedestrian counters. 

library(rwalkr)

# Change the start_date and end_date to your birthday last year. 
start_date <- as.Date("2018-08-30")
end_date <- as.Date("2018-08-31")

# Pull the pedestrian counts for your birthday last year
ped_walk <- melb_walk(from = start_date , to = end_date )
ped_walk

# Simple timeseries line
ggplot(data = subset(ped_walk, Sensor == "Melbourne Central")) +
  geom_line(aes(x = Date_Time, y = Count))

# -- TASK: Create a timeseries plot of your birthday week (not just day).

## Stacked Area Plot 1
# DATASET: economics
ggplot(economics, aes(x=date)) + 
  geom_area(aes(y=pop, fill="pop")) + 
    geom_area(aes(y=unemploy, fill="unemploy")) + 
      labs(y="thousands") 

## Stacked Area Plot 2
# DATASET: residential_property_prices
# Re-arrange the data
property <- residential_property_prices %>% 
  spread(City, Residential_property_price_index)

#create plot  
ggplot(property, aes(x = Date)) + 
  geom_area( aes( y = Sydney, fill = "Sydney")) +
  geom_area( aes( y = Brisbane, fill = "Brisbane")) +
  ylab("Residential Property Price Index")


