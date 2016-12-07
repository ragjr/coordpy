# Title: Photogrammetric Study Site Coordinate Calculator
# Created by: R. Allen Gilbert Jr.
# Created on: 20161130
# Purpose: This program calculates the approximate intervals images were taken at a study sites used during a Colorado Water Institute funded research project that used photogrammetry to derive snow raster surfaces.

#################### Import modules ####################
import math, os, csv

#################### Create global variables ####################
##northing = 4487619
##easting = 425112
##ang = 135
##dist = 30

zone = input('What UTM zone are your coordinates? ')
easting = input('Initial Easting: ')
northing = input('Initial Northing: ')
ang = input('Initial Angle: ') - 90

print('User Account: ' + os.environ.get( "USERNAME" ))
usr = os.environ.get( "USERNAME" )

#################### Calculate four corners of the study site ####################
##for i in range(3):
##        if (ang + 90) <= 360: ang = ang + 90
##        else: ang = ang + 90 - 360
##        northing = northing + (math.sin(math.radians(ang))*dist)
##        easting = easting + (math.cos(math.radians(ang))*dist)
##        print str(int(ang)) + " " + str(int(northing)) + " " + str(int(easting))

##def calcAng(ang):
##        if (ang + 90) <= 360: ang = ang + 90
##        else: ang = ang + 90 - 360
##        return ang;

##def calcLat(northing):
##        northing = northing + (math.sin(math.radians(ang))*dist)
##       return northing;

##def calcLon(easting):
##        easting = easting + (math.cos(math.radians(ang))*dist)
##        return easting;


##def sq(northing,easting,ang,dist):
##	print str(northing) + ' ' + str(easting) + ' ' + str(ang)
##	if (ang + 90) <= 360:
##		ang = ang + 90
##	else: ang = ang +90 - 360
##	northing = northing + (math.sin(math.radians(ang))*dist)
##	easting = easting + (math.cos(math.radians(ang))*dist)

##sq(4487619,425112,350,30)

#################### Calculate the interval coordinates ####################
rg = [14,13,16,14]
d = [50,30,50,30]

## Stable that writes a CSV
with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
        print('Creating coordinates.csv')
        writer = csv.writer(f)
        writer.writerow(['angle','easting','northing','distInput','sub-iteration'])
        for r in rg:
            for d2 in d:
                di = (float(d2) / r)
                break
            if (ang + 90) <= 360: ang = ang + 90
            else: ang = ang + 90 - 360
            for i in range(0,r,1):
                easting = easting + (math.sin(math.radians(ang)) * (di))
                northing = northing + (math.cos(math.radians(ang)) * (di))
##                writer.writerow([str(int(northing)),str(int(easting)),zone]) ## Use this for conversion input at http://www.engineeringtoolbox.com/utm-latitude-longitude-d_1370.html 
                writer.writerow(
                    [str(int(ang)),
                     str(int(easting)),
                     str(int(northing)),
                     zone,
                     r,
                     d2,
                     str(format(di, '.2f')),
                     str(int(i))])
        f.close

## Development
## Implement coordinate conversion using either numPy or pyproj.
## This program currently doesn't print out the initial coordinate.
        ## It may be possible to take the initial input, calculate based off a back azimuth and distance.
## Calculation is done in a right hand circle only.
## Conversion form mils to degrees is mil * 0.05625.
yes = 'yes'
no = 'no'
if input('Is your azimuth in mils? ') == yes: ang = int(input('Initial Angle: ') * 0.05625 - 90)
else: ang = input('Initial Angle: ') - 90
## Add a method to specify the number of images per line segment.
    ##rg = [1,1,1,1]
    ##rg[0] = input('Image interval: ')
    ##rg[1] = input('Image interval: ')
    ##rg[2] = input('Image interval: ')
    ##rg[3] = input('Image interval: ')
## Add a method to specify each line segment distance.
    ##d = [1,1,1,1]
    ##d[0] = input('First distance: ')
    ##d[1] = input('Second distance: ')
    ##d[2] = input('Third distance: ')
    ##d[3] = input('Forth distance: ')
## Something is going wrong with the di calculation and making the lengths longer than intended.
        ## It looks like it's always us 50 instead of going onto the next index in the list d.
        

print('Process Complete')
