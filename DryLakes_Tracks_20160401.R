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
rm(list=ls())

library(ggplot2)
library(tidyr)
library(forecast)
library(plyr)
library(raster)
library(sp)
library(rasterVis)

############################ Create metadatasets ############################

personalUID <- read.csv("./metaPerson.csv", header = TRUE)
transect <- read.csv("./metaAssignment.csv", header = TRUE)
phoneMeta <- read.csv("./metaPhone.csv", header = TRUE)
appMeta <- read.csv("./metaApplication.csv", header = TRUE)

############################ Create datasets ############################

tracksDL <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160401_DryLakes_Tracks.csv", header = TRUE)
tracksDL$uid_person <- as.factor(tracksDL$uid_person)

heartDL <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160401_DryLakes_HeartRate.csv", header = TRUE)
heartDL$uid_person <- as.factor(heartDL$uid_person)

tracksJW <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160430_JoeWright_Tracks.csv", header = TRUE)
tracksJW$uid_person <- as.factor(tracksJW$uid_person)

heartJW <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160430_JoeWright_HeartRate.csv", header = TRUE)
heartJW$uid_person <- as.factor(heartJW$uid_person)

surveyDL <- read.csv("./20160401_DryLakes_Survey/WR575_S2016_DryLake_SnowDepthSurvey.csv", header = TRUE)
surveyDL$uid_person <- as.factor(surveyDL$uid_person)

surveyJW <- read.csv("./20160430_JoeWright_Survey/WR575_S2016_JoeWright_SnowDepthSurvey.csv", header = TRUE)
surveyJW$uid_person <- as.factor(surveyJW$uid_person)

elevationDL <- read.asciigrid("./GIS/ABM_SnowSurvey/Exports/el_rt_extract.txt")

############################ Group plots ############################

ggplot(tracksDL, aes(x = id_time, y = elevation)) + facet_wrap(~uid_person) + geom_line()
ggplot(tracksDL, aes(x = utm_east, y = utm_north)) + facet_wrap(~uid_person) + geom_line()
ggplot(heartDL, aes(x = id_time, y = exertion)) + facet_wrap(~uid_person) + geom_line()

plotDL.trackEL <- ggplot(tracksDL, aes(x = id_time, y = elevation), ymin = min(tracksDL$elevation), color = "Black") +
  geom_area(alpha = 0.5) +
  xlab("Time [Julian Seconds]") +
  ylab("Elevation [m]") +
  facet_wrap(~uid_person)

plotDL.heartEL <- geom_area(data = heartDL, aes(x = id_time, y = elevation), color = "Red", alpha = 0.5)

############################ Rework data frames ############################

tracks.1003 <- tracks[which(tracks$uid_person == "1003"),]
tracks.1003.el <- ts(tracks.1003$elevation, start = min(tracks.1003$id_time), end = max(tracks.1003$id_time))

############################ Interpolation program ############################

test1 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation)
test2 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 2)
test3 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 10)
test4 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 20)
test5 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 50)
test6 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 100)
test7 <- smooth.spline(x = tracks.1003$id_time, y = tracks.1003$elevation, df = 600) # 600 df written however, the max is 127 and the program defaults to that.

get.spline.info <- function(object)
  {
    data.frame(x = object$x, y = object$y, df = object$df)
  }

splineDF <- ldply(list(test1,test2,test3,test4,test5,test6,test7),get.spline.info)
head(splineDF)

############################ Create graphics ############################

tracks.1003.plot <- ggplot(tracks.1003, aes(x = id_time, y = elevation)) + geom_point()
tracks.1003.plot + geom_line(data = splineDF, aes(x = x, y = y, color = factor(round(df,0)), group = df)) +
  scale_color_discrete("Degrees of \nFreedom") +
  xlab("Time [Julian]") +
  ylab("Elevation [m]")

toPlot <- function(testFile)
  {
  testFile.plot <- get.spline.info(testFile)
    tracks.1003.plot + geom_line(data = testFile.plot, aes(x = x, y = y)) +
      xlab("Time [Julian]") +
      ylab("Elevation [m]") +
      ggtitle(round(max(testFile$df),0))
  }

toPlot(test7)

############################ Retreive interpolated data points from the spline model ############################

# How can I take modeled data that used a spline interpolation technique and transform it into a data frame?

elBySec <- ddply(tracks.1003, "id_time", summarize,
                 el.mean = mean(elevation), el.sd = sd(elevation),
                 Length = NROW(elevation),
                 tfrac = qt(p = .90, df = Length - 1),
                 Lower = el.mean - tfrac * el.sd / sqrt(Length),
                 Upper = el.mean + tfrac * el.sd / sqrt(Length)
                )

elInfo <- summary(test7)
elCoef <- as.data.frame(elInfo$coefficients[,1:2])

############################ Include interpolated data points into the base dataset ############################


# with()
# within()
# aggregate()