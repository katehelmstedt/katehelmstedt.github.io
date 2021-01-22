# Question 1:  goes along with the blog post at https://www.jessesadler.com/post/gis-with-r-intro/

#### Let's use this as a base for building a similar problem for the spatial assessment

### Load packages and data
library(tidyverse)
library(sp)
library(sf)
library(rnaturalearth)

# This is the data for the example. It is simple. Can you please edit the csv files (use find-> replace)
# to change this example to Australian cities, change 'writer' to some kind of agricultural product,
# and different dates? Please change
# the quantities a bit so that the figure is noticably different to the one on the sebsite in 
# case they find it and try to plagurise it.

letters <- read_csv("data/correspondence-data-1585.csv")
locations <- read_csv("data/locations.csv")

########################
## Preparing the data ##
########################

# we need to step them through this process without actually telling them what to do. 
# I want this assessment to be hard. 
# But, some of this is new, particularly the idea of labelling some things as 'source'
# and some as 'destination. 
# Do you think it is enough for us to give thme the letter data, give them this cleaning code
# (with explanations) and then suggest they do soemthing similar for the new data we
# are giving them?
# If that is too simple, maybe an aspatial example of this using mtcars? The CRAN help file for
# `tally()` looks like it might have soem examples, but we'll need to make sure it matches
# all the steps below

# Letters per source
sources <- letters %>% 
  group_by(source) %>% 
  count() %>% 
  rename(place = source) %>% 
  add_column(type = "source") %>% 
  ungroup() 

# Letters per destination
destinations <- letters %>% 
  group_by(destination) %>% 
  count() %>% 
  rename(place = destination) %>% 
  add_column(type = "destination") %>% 
  ungroup()

# Bind the rows of the two data frames
# and change type column to factor
letters_data <- rbind(sources, destinations) %>% 
  mutate(type = as_factor(type))

# Join letters_data to locations
geo_data <- left_join(letters_data, locations, by = "place")

##################################
## Spatial data with sf package ##
##################################

# Create sf object with geo_data data frame and CRS -- make sure something like this is in the 
# teaching part of the workshop
points_sf <- st_as_sf(geo_data, coords = c("lon", "lat"), crs = 4326)

# Get coastal and country world maps as sf objects
# In the teaching part of the MXB262 workshop, we just show them how to grab the world
# map -- let's include both of these there, and they will need to know where to look to get it
coast_sf <- ne_coastline(scale = "medium", returnclass = "sf")
countries_sf <- ne_countries(scale = "medium", returnclass = "sf")


#################################
## Mapping with sf and ggplot2 ##
#################################

# Make sure, but I think the rest of this can be completely hands off if we have designed the
# teaching part of the workshop correctly

### Basic ggplot2 plot with geom_sf ###
ggplot() + 
  geom_sf(data = coast_sf) + 
  geom_sf(data = points_sf,
          aes(color = type, size = n),
          alpha = 0.7,
          show.legend = "point") +
  coord_sf(xlim = c(-1, 14), ylim = c(44, 55))

### Plot map with coastlines (lines) data ###
# Load ggrepel package
library(ggrepel)

ggplot() + 
  geom_sf(data = coast_sf) + 
  geom_sf(data = points_sf, 
          aes(color = type, size = n), 
          alpha = 0.7, 
          show.legend = "point") +
  coord_sf(xlim = c(-1, 14), ylim = c(44, 55),
           datum = NA) + # removes graticules
  geom_text_repel(data = locations, 
                  aes(x = lon, y = lat, label = place)) +
  labs(title = "Correspondence of Daniel van der Meulen, 1585",
       size = "Letters",
       color = "Type",
       x = NULL,
       y = NULL) +
  guides(color = guide_legend(override.aes = list(size = 6))) +
  theme_minimal()

### Plot map with countries (polygons) data ###
ggplot() + 
  geom_sf(data = countries_sf,
          fill = gray(0.8), color = gray(0.7)) + 
  geom_sf(data = points_sf, 
          aes(color = type, size = n), 
          alpha = 0.7, 
          show.legend = "point") +
  coord_sf(xlim = c(-1, 14), ylim = c(44, 55),
           datum = NA) + # removes graticules
  geom_text_repel(data = locations, 
                  aes(x = lon, y = lat, label = place)) +
  labs(title = "Correspondence of Daniel van der Meulen, 1585",
       size = "Letters",
       color = "Type",
       x = NULL,
       y = NULL) +
  guides(color = guide_legend(override.aes = list(size = 6))) +
  theme_bw()



### Question 2:
# This textbook uses a different mapping package, but can we adapt the questions and the re-organised 
# data at the end for questions in ggplot and sf?

# https://geocompr.robinlovelace.net/adv-map.html





