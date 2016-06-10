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
meta <- list(personalUID,transect,phoneMeta,appMeta)

############################ Create datasets ############################

tracksDL <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160401_DryLakes_Tracks.csv", header = TRUE)
tracksDL$uid_person <- as.factor(tracksDL$uid_person)
tracksDL <- tracksDL[which(tracksDL$set == "During"),]

heartDL <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160401_DryLakes_HeartRate.csv", header = TRUE)
heartDL$uid_person <- as.factor(heartDL$uid_person)
heartDL <- heartDL[which(heartDL$set == "During"),]

elevationDL <- read.table("./GIS/ABM_SnowSurvey/Exports/Ideal_Elevation_DL.txt", header = TRUE, sep = "")
elevationDL$uid_person <- as.factor(elevationDL$uid_person)
#raster.elevationDL <- read.asciigrid("./GIS/ABM_SnowSurvey/Exports/el_rt_extract.txt")

surveyDL <- read.csv("./20160401_DryLakes_Survey/WR575_S2016_DryLake_SnowDepthSurvey.csv", header = TRUE)
surveyDL$uid_person <- as.factor(surveyDL$uid_person)

tracksJW <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160430_JoeWright_Tracks.csv", header = TRUE)
tracksJW$uid_person <- as.factor(tracksJW$uid_person)
tracksJW <- tracksJW[which(tracksJW$set == "During"),]

heartJW <- read.csv("./GIS/ABM_SnowSurvey/Exports/20160430_JoeWright_HeartRate.csv", header = TRUE)
heartJW$uid_person <- as.factor(heartJW$uid_person)
heartJW <- heartJW[which(heartJW$set == "During"),]

elevationJW <- read.table("./GIS/ABM_SnowSurvey/Exports/Ideal_Elevation_JW.txt", header = TRUE, sep = "")
elevationJW$uid_person <- as.factor(elevationJW$uid_person)
#raster.elevationJW <- read.asciigrid("./GIS/ABM_SnowSurvey/Exports/el_rt_extract.txt")

surveyJW <- read.csv("./20160430_JoeWright_Survey/WR575_S2016_JoeWright_SnowDepthSurvey.csv", header = TRUE)
surveyJW$uid_person <- as.factor(surveyJW$uid_person)

trackList <- list(tracksDL,tracksJW,heartDL,heartJW)
uids <- list(1001,1002,1004,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017)

############################ Group plots ############################

plot.tracksDL.elevation <- geom_line(data = tracksDL, aes(x = id_time, y = elevation), color = "Red", size = 2)
plot.heartDL.elevation <- geom_line(data = heartDL, aes(x = id_time, y = elevation), color = "Dark Green")
plot.heartDL.heartrate <- geom_point(data = heartDL, aes(x = id_time, y = heartrate), color = "Blue")

############################ Plot All Elevation Function ############################

plot.all.elevation <- function(WD,trackData,heartData,elData,area)
  {
  
  setwd("C:/Users/Allen/Google Drive/01_Thesis")
  setwd(sprintf("./%s", WD))
  
  elData.minEl <- round_any(min(elData$elevation),accuracy = 100,floor)
  elData.maxEl <- round_any(max(elData$elevation),accuracy = 100,ceiling)
  
  plot.base.elData <- ggplot(elData, aes(x = id_time, y = elevation)) +
    geom_ribbon(aes(ymin = elData.minEl,ymax = elevation, alpha = 0.1)) +
    ylim(elData.minEl,elData.maxEl) +
    xlab("Position Index") +
    ylab("Elevation [m]") +
    ggtitle("NED Elevation") +
    facet_wrap(~uid_person)
  
  plot.trackData.elevation <- geom_line(data = trackData, aes(x = id_time, y = elevation), color = "Red", size = 1, alpha = 0.5)
  plot.heartData.elevation <- geom_line(data = heartData, aes(x = id_time, y = elevation), color = "Dark Green")
  
  plot.base.elData + 
    plot.trackData.elevation +
    plot.heartData.elevation +
    xlab("Time [Julian Seconds]")
    ggtitle("Elevation by Individual") +
    theme_light()
  
  ggsave(sprintf("%s_elevation_overview.png", area))
  setwd("C:/Users/Allen/Google Drive/01_Thesis")
}

############################ Plot El & HR Comparison Function ############################

plot.comparison <- function(WD,trackData,heartData,elData,uid,area)
{

  setwd("C:/Users/Allen/Google Drive/01_Thesis")
  setwd(sprintf("./%s", WD))
  
  elData.uid <- elData[which(elData$uid_person == uid),]
  elData.uid <- subset(elData.uid, select = c(3,4))
  elData.uid$exertion <- "NULL"
  elData.uid$panel <- "Elevation"
  
  elMin.uid <- round_any(min(elData.uid$elevation),accuracy = 100,floor)
  elMax.uid <- round_any(max(elData.uid$elevation),accuracy = 100,ceiling)
  
  trackData.uid <- trackData[which(trackData$uid_person == uid),]
  trackData.uid <- subset(trackData.uid, select = c(3,6))
  trackData.uid$exertion <- "NULL"
  trackData.uid$panel <- "Elevation"
  
  heartData.uid.el <- heartData[which(heartData$uid_person == uid),]
  heartData.uid.el <- subset(heartData.uid.el, select = c(4,6,11))
  heartData.uid.el$panel <- "Elevation"
  
  heartData.uid.hr <- heartData[which(heartData$uid_person == uid),]
  heartData.uid.hr <- subset(heartData.uid.hr, select = c(4,6,11))
  heartData.uid.hr$panel <- "Exertion"
  
  combined.uid <- rbind(elData.uid,trackData.uid,heartData.uid.el,heartData.uid.hr)
  
  ggplot(data = combined.uid) +
    facet_grid(panel~., scales = "free") +
    geom_ribbon(data = elData.uid, aes(x = id_time, ymin = elMin.uid, ymax = elevation, alpha = 0.1)) +
    ylab("Comparison") +
    geom_line(data = trackData.uid, aes(x = id_time, y = elevation), color = "Red", size = 2, alpha = 0.5) +
    geom_line(data = heartData.uid.el, aes(x = id_time, y = elevation), color = "Dark Green") +
    geom_line(data = heartData.uid.hr, aes(x = id_time, y = exertion), color = "Blue") +
    ggtitle(sprintf("Personal Identifier: %s", uid)) +
    xlab("Time [Julian Seconds]") +
    theme_light()
  
  ggsave(sprintf("%s_%s_summary.png", area, uid))
  setwd("C:/Users/Allen/Google Drive/01_Thesis")
  #remove(elMin.uid,elMax.uid,combined.uid,elData.uid,tracksDL.uid,heartDL.uid.el,heartDL.uid.hr)
}

# with()
# within()
# aggregate()

#### Calculating between rows ####

df <- data.frame(ID=1:10,Score=4*10:1)

diff(df)

diff(as.matrix(df))

#### remove a row ####

tail(df, -1) - head(df, -1)

#### using apply ####

apply(df, 2, diff)
apply(df[-1], 2, diff)

#### using data.tables ####
DT <- data.table(df)
DT[ , list(ID,Score,Diff=diff(Score))  ]

DT[, lapply(.SD, diff), .SDcols = 1:2]

#### using sql ####

sqldf(paste("SELECT a.ID,a.Score"
            ,"      , a.Score - (SELECT b.Score"
            ,"                   FROM df b"
            ,"                   WHERE b.ID < a.ID"
            ,"                   ORDER BY b.ID DESC"
            ,"                   ) diff"
            ," FROM df a"
)
)

df2 <- data.frame(ID=1:10,grp=rep(c("v","w"), each=5),Score=4*10:1)

sqldf(paste("SELECT a.ID,a.grp,a.Score"
            ,"      , a.Score - (SELECT b.Score"
            ,"                   FROM df2 b"
            ,"                   WHERE b.ID < a.ID"
            ,"                         AND a.grp = b.grp"
            ,"                   ORDER BY b.ID DESC"
            ,"                   ) diff"
            ," FROM df2 a"
)
)