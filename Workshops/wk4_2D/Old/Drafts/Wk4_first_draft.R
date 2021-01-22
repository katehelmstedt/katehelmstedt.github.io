#####################################
#         Wk 4 MXB242               #
#         Sem 1 2019                #  
#         2D Data Viz               #
#####################################

# This week we are going to work with an R script instead of an R Markdown file. An R script doesn't have text and interprets everything as R code. To write a comment use the # at the start of the line. When you run a specific piece of code, the output will appear in the console or the plot will appear in the plot window.  

# Code for generating a selection of the plots is below. Work through each of the plots and then complete the activities at the bottom. 


#####################################################################################


#### Set-up #### 

# Packages 
library(ggplot2)
library(devtools)
install.packages("rwalkr")
library(rwalkr)
install.packages("ggmosaic")
library(ggmosaic)
install.packages("dplyr")
library(dplyr)
install.packages("grattan")
library(grattan)
library(magrittr)

# Datasets 
head(mtcars)
head(quakes)
head(mpg)
head(mtcars)
head(Orange)
head(USArrests)
head(PlantGrowth)
head(Titanic)



# Inspiration  - https://www.data-to-viz.com/


############################ 1. CATEGORICAL DATA ##################################################

# 1D 

## Barchart      
# DATASET: mtcars
ggplot(data = mtcars, aes(x=as.factor(cyl))) + geom_bar()
 
# --  Q: Why has the function `as.factor()` been applied to the `cyl` variable in the example above? 
# --  TASK: create a new barchart using a different variable in mtcars. Use `head(mtcars)` to see what other variables are in the dataset. 

# 2D - Both Categorical

## Mosaic Plot
# DATASET: titanic
# prepare the dataset
data(Titanic)
titanic <- as.data.frame(Titanic)
titanic$Survived <- factor(titanic$Survived, levels=c("Yes", "No"))

# generate mosaic plot
ggplot(data=titanic) +
  geom_mosaic(aes(weight=Freq, x=product(Class), fill=Survived))


# 2D - Discrete/Categorical X, Continuous Y

## Barchart
# DATASET: dummy_data (created)
# create the dataset
specie=c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition=rep(c("normal" , "stress" , "Nitrogen") , 4)
value=abs(rnorm(12 , 0 , 15))
dummy_data=data.frame(specie,condition,value)

# Grouped
ggplot(dummy_data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar(position="dodge", stat="identity")


# Stacked
ggplot(dummy_data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity")

# Stacked Percent
ggplot(dummy_data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity", position="fill")



## Scatter plot
# DATASET: ToothGrowth
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() 

# -- Add jitter to reveal all the data points `geom_jitter()`.

ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_point() + geom_jitter(width = 0.2)

# -- Q: How do you change the size of the jitter?
# -- Q: Use a scatterplot to explore the relatinship between ToothGrowth and a different variable. Use `head(ToothGrowth)` to see what other variables are in the dataset. 


### Box Plots
#DATASET: ToothGrowth
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_boxplot() + geom_dotplot()

# Dot + Box 
ggplot(ToothGrowth, aes(supp, len)) + geom_boxplot() + 
  geom_dotplot(binaxis='y', 
               stackdir='center', 
               dotsize = .5, 
               fill="red") +
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
  labs(title="Box plot + Dot plot", 
       subtitle="Tooth Growth of Guinea Pigs Fed 3 Different Vitamin C Supplement Concentrations" ,
       x="Vitamin C Concentration",
       y="Tooth Growth")

### Violin Plots. 
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_violin() 

# -- TASK: Create a Dot + Violin plot.



######################################### 2. CONTINUOUS DATA ###########################################

# 1D

## Histogram      
# DATASET: mpg , PlantGrowth
ggplot(mpg, aes(cty)) + geom_histogram()
ggplot(PlantGrowth, aes(weight)) + geom_histogram(binwidth = 0.2)

# -- The number of bins in a ggplot histogram is automatically set to 30. You often need to adjust this by adding `binwidth = `. 
# -- TASK: Remove `binwidth = 0.2` from the PlantGrowth histogram above and see what the default plot looks like. 
# -- TASK: Add the binwidth command to the mpg histogram, try a few different widths. 

## Density Plot    
# DATASET: mpg
ggplot(mpg, aes(cty)) + geom_density()

# -- TASK: Create a density plot for a different variable within mpg. 

# 2D - Both Continuous

### Scatter Plot
# DATASET: USArrest

ggplot(USArrests, aes(x = UrbanPop, y = Assault)) + geom_point() 

# -- TASK: connect each of the dots using geom_line()


### Smooth (lm)
# DATASET: midwest

ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() #+ geom_smooth() #+ ylim(0, 50000)

# -- TASK: Remove the first `#`, in-front of `+ geom_smooth)`, to add a linear model trend line
# -- TASK: Remove the second `#` to remove the outliner by only showing population up to 50,000
# -- TASK: Reduce the x axis so it shows from 0 to 0.1.


########################################## 3. TIMESERIES ######################################

# -- Using the `rwalkr` package you are going to collect your own data from Melbourne city's Pedestrian counters. 

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

# -- TASK: Create a timeseries plot of your birthday week.

## Stacked Area Plot (line chart)
# DATASET: economics
ggplot(economics, aes(x=date)) + 
  geom_area(aes(y=psavert+uempmed, fill="psavert")) + 
  geom_area(aes(y=uempmed, fill="uempmed")) + 
  labs(title="Area Chart of Returns Percentage", 
       caption="Source: Economics", 
       y="Returns %")   # title and caption



################################# ASSESSMENT QUESTIONS ################################


#### 1 
# DATASET: ChickWeight or InsectPrays
# RELATIONSHIP OR FEATURE: Diet and chick weight
# PLOT: scatterplot, box + dots, boxplot 
ggplot(ChickWeight, aes(x = Diet, y = weight)) + geom_boxplot() + geom_point()  + geom_jitter()

#### 2 
# DATASET: quakes
# RELATIONSHIP OR FEATURE: the variation of all quakes in the dataset. 
# PLOT: histogram
ggplot(quakes, aes(x = mag)) + geom_histogram() 


### 3 
# DATASET: pressure
# RELATIIONSHIP or FEATURE: pressure and temperature
# PLOT: scatterplot + line
ggplot(pressure, aes(pressure, temperature)) + geom_point() + geom_line()

### 4 
# DATASET: starwars
# RELATIONSHIP or FEATURE: hair colour or gender of the starwars cast. Extend to explore hair and gender. 
#PLOT: barchart and stacked barchart
ggplot(starwars, aes(hair_color)) + geom_bar()
ggplot(starwars, aes(gender)) + geom_bar()
ggplot(starwars, aes( fill = hair_color, x = gender)) + geom_bar(position = "dodge")

### 5 
# DATASET: mpg
# RELATIONSHIP or FEATURE: number of cars from each manufacturer in the dataset. + relationship between cty (city miles per gallon) and one other variable
#PLOT: barchart + scatterplot
ggplot(mpg, aes(manufacturer)) + geom_bar()
ggplot(mpg, aes(drv, cty)) + geom_point()


### 6 
# DATASET: warpbreaks
# RELATIONSHIP or FEATURE: Tension and the number of times the wool breaks.
#PLOT: violin plot + scatterplor
ggplot(warpbreaks, aes(x = tension, y = breaks)) + geom_violin() + geom_point() 


### 7 
# DATASET: residential_property_prices (within the Grattan package)
# RELATIONSHIP or FEATURE: residential house sale prices over time. 
#PLOT: timeseries or geom_line

x <- residential_property_prices %>% 
  filter(City == 'Brisbane')

ggplot(x, aes(Date, Residential_property_price_index)) + geom_line()

### 8 
# DATASET: type `data()` into the console to see a list of all data available in R base or other packages. 
# Explore any dataset you like. 


############################## END ########################################




### 1. Box + dots 
ggplot(ChickWeight, aes(x = Diet, y = weight)) + geom_boxplot() + geom_point()  + geom_jitter()


### 2. Histograms 
ggplot(quakes, aes(x = mag)) + geom_histogram() 
ggplot(warpbreaks, aes(x = breaks)) + geom_histogram(binwidth = 4)

### 3. Scatterplot 
ggplot(pressure, aes(pressure, temperature)) + geom_point() + geom_line()

### 5 Barchart
ggplot(mpg, aes(manufacturer)) + geom_bar()
ggplot(starwars, aes(hair_color)) + geom_bar()

