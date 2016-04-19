# Title: WR575 GPS Track Records Cleaning
# 
# Created by: R. Allen Gilbert Jr.
# 
# Date created: 20160405
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

############################ Set working directory and load libraries ############################

setwd("C:/Users/Allen/Google Drive/01_Thesis/20160401_DryLakes_Survey")

library(ggplot2)
library(tidyr)

############################ Load track files ############################

gpsClean <- ".Data_GPS/Cleaned_SurveyGPS"
fileNames <- list.files(gpsClean, pattern = "*.txt")
dataNames <- gsub("[.]txt","",fileNames)

# for(i in 1:length(fileNames)){
#   assign(dataNames[i], read.csv(file.path(gpsClean,fileNames[i])))
# }

tracks <- read.csv("./dataCombined.csv", header = TRUE)

# with()
# within()
# aggregate()
