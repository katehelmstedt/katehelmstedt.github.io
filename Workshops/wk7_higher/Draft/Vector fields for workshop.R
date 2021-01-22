
library(ggquiver) 
library(ggplot2)

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

# TASK: play with different densities of arrows to generate plots like those in the lecture slides on 
# the slide titled "Main viz choice: density"


