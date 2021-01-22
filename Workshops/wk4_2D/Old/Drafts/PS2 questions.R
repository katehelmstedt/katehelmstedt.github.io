
################################# ASSESSMENT QUESTIONS ################################


#### 1 
# DATASET: ChickWeight or InsectPrays
# RELATIONSHIP OR FEATURE: Diet type vs chick weight
# PLOT: scatterplot, box + dots, boxplot 
ggplot(ChickWeight, aes(x = Diet, y = weight)) + geom_boxplot() + geom_point()  + geom_jitter()

#### 2 
# DATASET: quakes
# RELATIONSHIP OR FEATURE: the variation of the earth quakes magnitude.
# PLOT: histogram
ggplot(quakes, aes(x = mag)) + geom_histogram() 


### 3 
# DATASET: pressure
# RELATIIONSHIP or FEATURE: pressure vs temperature
# PLOT: scatterplot + line
ggplot(pressure, aes(pressure, temperature)) + geom_point() + geom_line()

### 4 
# DATASET: starwars
# RELATIONSHIP or FEATURE: hair colour of the cast of starwars. Extend this and explore hair vs gender. 
#PLOT: barchart and stacked barchart
ggplot(starwars, aes(hair_color)) + geom_bar()
ggplot(starwars, aes(gender)) + geom_bar()
ggplot(starwars, aes( fill = hair_color, x = gender)) + geom_bar(position = "dodge")

### 5 
# DATASET: mpg
# RELATIONSHIP or FEATURE: show the number of cars from each manufacturer.  + relationship between cty (city miles per gallon) and one other variable (you may need two plots)
#PLOT: barchart + scatterplot
ggplot(mpg, aes(manufacturer)) + geom_bar()
ggplot(mpg, aes(drv, cty)) + geom_point()


### 6 
# DATASET: warpbreaks
# RELATIONSHIP or FEATURE: Tension vs number of breaks.
#PLOT: violin plot + scatterplor
ggplot(warpbreaks, aes(x = tension, y = breaks)) + geom_violin() + geom_point() 


### 7 
# DATASET: residential_property_prices (within the Grattan package)
# RELATIONSHIP or FEATURE: show residential house sale prices over time. 
#PLOT: timeseries or geom_line

x <- residential_property_prices %>% 
  filter(City == 'Brisbane')

ggplot(x, aes(Date, Residential_property_price_index)) + geom_line()

### 8 
# Dataset: residential_property_prices
# TASK: add another city to the stacked bar chart of residental property price index above. 

### 9 
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

