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

setwd("C:/Users/Allen/Google Drive/01_Thesis")

library(ggplot2)
library(tidyr)

############################ Load track files ############################

gps <- "./Data_GPS/20160401_surveyGPS"
fileNames <- list.files(gps, pattern = "*.txt")
dataNames <- gsub("[.]txt","",fileNames)

for(i in 1:length(fileNames)){
  assign(dataNames[i], read.csv(file.path(gps,fileNames[i])))
}

for(i in 1:length(dataNames)){
  print(i:dataNames[i])
  #  dataNames[i] <- subset(dataNames[i], select = c(Latitude, Longitude,altitude,ltime))
}

# with()
# within()
# aggregate()

columnNames <- list("UID", "Time", "Lat", "Long", "Elev")
addColumns <- data.frame(columnNames)

track <- subset(read.csv("./Data_GPS/Cleaned_SurveyGPS/etrex_16Q369520_gps21_clean.txt", header = TRUE, sep = ","), select = c(Latitude,Longitude,altitude,ltime))

track <- within(track,
                {
                  ObjectID <- (1:nrow(track))
                })

track.16Q369520 <- data.frame(etrex_16Q369520_gps21 = rep("None", nrow(etrex_16Q369520_gps21)), etrex_16Q369520_gps21[,])
track.16Q369520 <- subset(track.16Q369520, select = c(Latitude, Longitude,altitude,ltime))

track.3835688390 <- data.frame(etrex10_3835688390_012509 = rep("None", nrow(etrex10_3835688390_012509)), etrex10_3835688390_012509[,])

# for(i in 1:length(dataNames)){
#   dataNames[i] <- subset(dataNames[i], select = c(Latitude,Longitude,altitude,ltime))
# }

# I want to subset the new data by select = c(Latitude,Longitude,altitude,ltime)
