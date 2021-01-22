################################################################################
### ENVS 410/510                                                             ###
### Visualization: Linking data to geometric objects in ggplot2              ### 
################################################################################

## OBJECTIVE:
## To practice a "grammar of graphics"
## To become familiar with different types of graphs
## To determine the best graph to fit the question and data
## Handy reference: http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html#1.%20Correlation

## First let's load the tidyverse
## This is a suite of useful packages that includes ggplot2 
library(tidyverse)

## Note: deleted a bunch of code here that was related to another topic (Kate H)

################################################################################
### YOUR TURN: CO2 TRENDS                                                    ###
################################################################################

## First we'll read in the data and get it ready to use
## You can find the data and read more about it here: https://climate.nasa.gov/vital-signs/carbon-dioxide/
## In particular, the metadata is at the top of the txt file  if you click on the Download Data button

## Let's import the data directly from the web
## This requires the package data.table
## It may not be on your computer, in which case install it
install.packages("data.table")
library(data.table)

## Let's skip down to the data, which starts at line 61
CO2data <- fread('ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt', skip = 60)
names(CO2data) <- c("year", "month", "decimalDate", "averageCO2", "interpolatedCO2", "trendCO2", "numberDays")


#########################
## Read about the data ##
#########################
## Why are there three different columns for CO2? 
## What does numberDays refer to? 
## What does -99.99 in the average column and -1 in the number of days column mean?



########################
## Visualize the data ##
########################
## How do atmospheric CO2 concentrations change over the time series?
## What category of graph will you use?
## What statistical transformation will you use?
## Does the underlying data differ if you use the interpolated or trend columns? 
## Does the statistical transformation differ if you use the interpolated or trend columns?



########################
## Visualize the data ##
########################
## Which months are the CO2 values at the maximum? Minimum? Why is this?
## What category of graph will you use?
## What statistical transformation will you use? 



################################################################################
### YOUR TURN: TEMPERATURE TRENDS                                            ###
################################################################################

## First we'll read in the data and get it ready to use
## You can find the data and read about it here: https://climate.nasa.gov/vital-signs/global-temperature/

tempdata <- fread('http://climate.nasa.gov/system/internal_resources/details/original/647_Global_Temperature_Data_File.txt')


#########################
## Read about the data ##
#########################
## What information is in each of the three columns?
## Using the names() function to give tempdata descriptive column headings
## Please name the first column year


########################
## Visualize the data ##
########################
## Recreate the graph on the website using all three columns
## Recreate the graph on the website using two columns and a statistical transformation

