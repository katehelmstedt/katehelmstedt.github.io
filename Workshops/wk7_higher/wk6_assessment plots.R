# Wk 6 Assessment

########### BUBBLE PLOT
## 1
# DATA: 
gender_pay_gap <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/school_earnings.csv")
# RELATIONSHIP: Pay gap and annual salary for women and annual salary for men.
# PLOT
ggplot(gender_pay_gap, aes(x=Women, y=Men, size = Gap)) +
  geom_point(alpha=0.7) +
  scale_size(range = c(1.4, 19), name="Gender Pay Gap") +
  scale_color_viridis(discrete=TRUE, guide=FALSE) +
  theme(legend.position="none") 


## 2
# DATA: airquality 
# RELATIONSHIP" any three or four variables in the airquality dataset 
# PLOT
ggplot(airquality, aes(x = Solar.R, y = Wind, size = Ozone)) +
  geom_point()


########### FACETTING
# DATA: CO2
# RELATOIONSHIP: CO2 uptake vs CO2 concentration across different plans. 
ggplot(CO2, aes(x = conc, y = uptake)) + geom_point() + facet_wrap(~Plant)


# DATA: iris 
### ?
# DATA: babynames
# RELATIONSHIP: re-create the facetted babynames plot with 5 names from your class. 
# subset to the data to 10 years before and 10 years after your birth. 


########### SPIDER PLOT
# DATA: iris
# code for preparing the data
iris_setosa <- iris %>% 
  filter(Species == "setosa") %>% 
  select(-Species) %>% 
  summarise(Sepal.Length = mean(Sepal.Length), 
            Sepal.Width = mean(Sepal.Width), 
            Petal.Length = mean(Petal.Length), 
            Peal.Width = mean(Petal.Width))

# RELATIONSHIP : compare petal dimensions between 2 or more species. 
# HINT: you will need to create a separate dataset for each species

# PLOT 
iris_setosa <- rbind(rep(5.7,4) , rep(0,4) , iris_setosa)

radarchart(iris_setosa, axistype=1, 
           pcol=rgb(0.2,0.5,0.5,0.9) ,  # draw the polygon
           cglcol="grey", # set the polygon colour
           cglty=1, # define the line used to draw the polygon
           axislabcol="grey", # define axis label colour
           caxislabels=seq(0,20,5), # set the range of the axis labels
           cglwd=0.8, # grid line width 
           vlcex=0.8, # text size of labels 
           pfcol=rgb(0.2,0.5,0.5,0.5))


########### PARALLEL COORDINATES
# DATA - state.x77
#RELATIONSHIP: explore relationships between the variables in the dataset. 
# Using a parallel coordinates plot see if you can identify any trends. 

# PLOT
ggparcoord(state.x77, columns = 2:7) 
