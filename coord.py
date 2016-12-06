# Title: Photogrammetric Study Site Coordinate Calculator
# Created by: R. Allen Gilbert Jr.
# Created on: 20161130
# Purpose: This program calculates the approximate intervals images were taken at a study sites used during a Colorado Water Institute funded research project that used photogrammetry to derive snow raster surfaces.

#################### Import modules ####################
import math, cycle

#################### Create global variables ####################
lat = 4487619
lon = 425112
ang = 350
dist = 30

#################### Calculate four corners of the study site ####################
for i in range(3):
        if (ang + 90) <= 360: ang = ang + 90
        else: ang = ang + 90 - 360
        lat = lat + (math.sin(math.radians(ang))*dist)
        lon = lon + (math.cos(math.radians(ang))*dist)
        print str(int(ang)) + " " + str(int(lat)) + " " + str(int(lon))

##def calcAng(ang):
##        if (ang + 90) <= 360: ang = ang + 90
##        else: ang = ang + 90 - 360
##        return ang;

##def calcLat(lat):
##        lat = lat + (math.sin(math.radians(ang))*dist)
##       return lat;

##def calcLon(lon):
##        lon = lon + (math.cos(math.radians(ang))*dist)
##        return lon;


##def sq(lat,lon,ang,dist):
##	print str(lat) + ' ' + str(lon) + ' ' + str(ang)
##	if (ang + 90) <= 360:
##		ang = ang + 90
##	else: ang = ang +90 - 360
##	lat = lat + (math.sin(math.radians(ang))*dist)
##	lon = lon + (math.cos(math.radians(ang))*dist)

##sq(4487619,425112,350,30)

#################### Calculate the interval coordinates ####################
rg = [14,13,16,14]
# rg1 = 14
# rg2 = 13
# rg3 = 16
# rg4 = 14

while rg <= rg:
	d2 = dist / rg
	lat = lat + (math.sin(math.radians(ang)) * d2)
	lon = lon + (math.cos(math.radians(ang)) * d2)
	print str(int(lat)) + "," + str(int(lon))
	rg = rg - 1