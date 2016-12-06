# Title: Photogrammetric Study Site Coordinate Calculator
# Created by: R. Allen Gilbert Jr.
# Created on: 20161130
# Purpose: This program calculates the approximate intervals images were taken at a study sites used during a Colorado Water Institute funded research project that used photogrammetry to derive snow raster surfaces.

#################### Import modules ####################
import math, os, csv

#################### Create global variables ####################
lat = 4487619
lon = 425112
ang = 260
dist = 30

print('User Account: ' + os.environ.get( "USERNAME" ))
usr = os.environ.get( "USERNAME" )

#################### Create text files with filenames ####################
with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
    print('Creating coordinates.csv')
    writer = csv.writer(f)
    writer.writerow(['longitude','latitude'])
##    for path, dirs, files in os.walk("P:/metadata"):
##        for filename in files:
##            x = x + 1
##            writer.writerow([x,filename])

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
d = [50,30,50,30]
x = 0

## (d2 * i) is increasing exponentially as it progresses along the total distance.

## Stable
for r in rg:
        d2 = float(dist) / r
        print d2
        if (ang + 90) <= 360: ang = ang + 90
        else: ang = ang + 90 - 360
	for i in range(0,r,1):
		i = i + 1
		lat = lat + (math.sin(math.radians(ang)) * (d2 * i))
                lon = lon + (math.cos(math.radians(ang)) * (d2 * i))
                print str(int(ang)) + "," + str(int(lat)) + "," + str(int(lon)) + "," + str(int(i * d2))

## Development
for r in rg:
        for d2 in d:
                di = d2 / r
                break
        if (ang + 90) <= 360: ang = ang + 90
        else: ang = ang + 90 - 360
	for i in range(0,r,1):
		lat = lat + (math.sin(math.radians(ang)) * (di))
                lon = lon + (math.cos(math.radians(ang)) * (di))
                print str(int(lon)) + "," + str(int(lat))
##                print str(int(ang)) + "," + str(int(lat)) + "," + str(int(lon)) + "," + str(int(di)) + "," + str(int(i))
                x = x + 1
                writer.writerow([x,filename])
