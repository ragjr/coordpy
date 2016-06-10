# Title: Dry Lakes Snow Survey Raster Processing
# 
# Created by: R. Allen Gilbert Jr.
# 
# Date created: 20160419
# 
# Purpose: To process a NED 1/3 arc-second elevation surface to visualize elevation gains and losses along a transect.
# 
# Process: The ~10m elevation model is first resampled to 1m cells. Surface roughness is created by adding randomly
# generated values to the existing resampled surface. The user creates a snow surface by adding the desired depth of
# snow to the surface roughness layer and applying a low pass filter to smooth the result. The user creates a depth 
# reference layer by subtracting the surface roughness layer from the snow layer. If the underlying surface roughness
# layer is above the snow surface, the value is set to 0 to indicate a depth of 0. This depth surface is exported 
# for use in the model. Adjustments are made to the snow surface layer by adding the height of those cells that
# were above the snow during the creation of the depth reference layer. Finally, local slope is calculated and exported
# for use in the model.

############################ Set working directory and load libraries ############################

setwd("C:/Users/Allen/Google Drive/01_Thesis/20160401_DryLakes_Survey")

library(ggplot2)
library(tidyr)
library(raster)
library(rasterVis)
library(rgdal)
library(rgeos)

############################ Create surface datasets ############################

el.surface <- raster("./Surfaces/selection.tif")
el.table <- read.delim("./Surfaces/selection.txt", sep = " ", na.strings = "-9999", skip = 6, blank.lines.skip = TRUE, skipNul = TRUE)
el <- read.csv("./Surfaces/idealElevation.csv", header = TRUE, sep = ",")

############################ Plot an idea elevation track ############################

ggplot(el, aes(x = el$X, y = el$X11 )) +
  geom_line() +
  ggtitle("Transect 011") +
  xlab("Elevation [m]") +
  ylab("Distance [m]")