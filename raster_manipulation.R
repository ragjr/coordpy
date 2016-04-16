# Title: Raster Manipulation for Pseudo Snow Surface
# 
# Created by: R. Allen Gilbert Jr.
# 
# Date created: 20160305
# 
# Purpose: To process a NED 1/3 arc-second elevation surface for use in an agent-based model that models human movement
# across a snow surface.
# 
# Process: The ~10m elevation model is first resampled to 1m cells. Surface roughness is created by adding randomly
# generated values to the existing resampled surface. The user creates a snow surface by adding the desired depth of
# snow to the surface roughness layer and applying a low pass filter to smooth the result. The user creates a depth 
# reference layer by subtracting the surface roughness layer from the snow layer. If the underlying surface roughness
# layer is above the snow surface, the value is set to 0 to indicate a depth of 0. This depth surface is exported 
# for use in the model. Adjustments are made to the snow surface layer by adding the height of those cells that
# were above the snow during the creation of the depth reference layer. Finally, local slope is calculated and exported
# for use in the model.

# Modifications: 20160404
# Changed Title from Raster Manipulation for Thesis

############################ Set working directory and load libraries ############################

setwd("C:/Users/Allen/Google Drive/01_Thesis")

library(raster) # also includes library(sp)
library(rasterVis)
library(rgdal)
library(rgeos)
library(ggplot2)

############################ Load the original 10m DEM ############################

el_10m <- raster("./Model/Movement/NetlogoASCII/elevation.asc") # load the elevation layer
el_10m # provides 10m elevation metadata
plot(el_10m, main = "Elevation [10 m]")

############################ Resample to a 1m DEM ############################

resample <- raster("./Model/Movement/NetlogoASCII/resample.asc")
resample # provides 1m elevation metadata

############################ Create surface roughness ############################

# Open the heterogeneity surface
hetero <- raster("./Model/Movement/NetlogoASCII/elAdj.asc")

# OR create heterogeneity between 1m cells
hetero <- resample + rpois(ncell(resample), lambda = .2) # NOTE: This creates heterogeneity larger than 1m differences.
writeRaster(hetero, filename = './Model/Movement/NetlogoASCII/elAdj.asc', format = 'ascii')

plot(hetero, main = "Heterogeneous")
hist(hetero, main = 'Histogram of Surface Roughness', xlab = 'Elevation [m]')

# observe the difference between the previous 1m elevation and new heterogeneous 1m elevation
comparison <- hetero - resample
plot(comparison, main = "Comparison")

############################ Create snow surface ############################

# User defined variable values
2 -> mDepth       # the depth of snow measure at by the SNOTEL station
9 -> neighborhood # the extent of neighbors around the calculated cell
snowMean = neighborhood^2    # creates the mean  

#create the snow surface
snow <- hetero + mDepth # increase the overall elevation by 2m
snow <- focal(hetero, w = matrix(1/snowMean, nrow = neighborhood, ncol = neighborhood))

plot(snow, main = 'Snow')
hist(snow, main = 'Histogram of Snow Surface', xlab = 'Elevation [m]')

############################ Create depth surface ############################

depth <- snow - hetero
#depth <- if(depth < 0) 0 depth # currently doing thise with ArcGIS Raster Calculator CON(depth < 0, 0, depth)
depthAbove <- raster("./Model/Movement/NetlogoASCII/depth_above.asc")
depthBelow <- raster("./Model/Movement/NetlogoASCII/depth_below.asc")

plot(depth, main = 'Depth')

############################ Adjust snow surface ############################

# Negative depths are protrusions above the snow surface and should be accounted for in the models environment.
# Add the abosolute value of the protruding cells to the snow cell.

snow2 <- snow + abs(depthAbove)
plot(snow2, main = 'Snow and DepthAbove')

snowCompare <- snow2 - snow
plot(snowCompare, main = 'Snow Comparison')

# TODO: Determine a way to project this raster so I can run the slope function on it.
# snow2 <- projectRaster(snow2, crs = crs(depthAbove), res = 1, method = 'ngb') #26913
# snow2 <- projectExtent(snow2, crs = crs(depthAbove))

############################ Create local slope surface ############################

# TODO: snow2 must be projected to run the slope command.
# Currently being accomplished using ArcGIS Raster Calculator.

#create slope surface
# slope <- terrain(snow2, opt = "slope", unit = 'degrees', neighbors = '8')

# writeRaster(slope, filename = './Model/Movement/NetlogoASCII/slope.asc', format = 'ascii')
writeRaster(depthBelow, filename = './Model/Movement/NetlogoASCII/depth.asc', format = 'ascii')
writeRaster(snow2, filename = './Model/Movement/NetlogoASCII/snow.asc', format = 'ascii', overwrite = TRUE)

