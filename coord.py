# Title: Photogrammetric Study Site Coordinate Calculator
# Created by: R. Allen Gilbert Jr.
# Created on: 20161130
# Purpose: This program calculates the approximate intervals images were taken at a study sites used during a Colorado Water Institute funded research project that used photogrammetry to derive snow raster surfaces.

#################### Import modules ####################
import math, os, csv, numpy as np, matplotlib.pyplot as plt

#################### Create global variables ####################
##horticulture farms
##easting = 500146 org(500141)
##northing = 4495706
##ang = 270 degrees
##el = [,,,]
##dist = varies from 30 to 50 meters
##rg = [14,13,16,14]
##d = [40,35,40,35]
##HortFarms = {
##        'easting' : '500146',
##        'northing' : '4495706',
##        'ang' : '270'
##        }

##joe wright
##easting = 424973 org(425112)
##northing = 4487421 org(4487619)
##ang = 130 - 135 degrees
##dist = 32 meters
##el = [,,,]
##JoeWright = {
##        'easting' : '424973',
##        'northing' : '4487421',
##        'ang' : '133'
##        }

print('Note: Calculation is performed clock-wise from your initial coordinate.')

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

## v1.1 - Stable that writes a CSV
##with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
##        print('Creating coordinates.csv')
##        writer = csv.writer(f)
##        writer.writerow(['angle','easting','northing','distInput','sub-iteration'])
##        for r in rg:
##            for d2 in d:
##                di = (float(d2) / r)
##                break
##            if (ang + 90) <= 360: ang = ang + 90
##            else: ang = ang + 90 - 360
##            for i in range(0,r,1):
##                easting = easting + (math.sin(math.radians(ang)) * (di))
##                northing = northing + (math.cos(math.radians(ang)) * (di))
####                writer.writerow([str(int(northing)),str(int(easting)),zone]) ## Use this for conversion input at http://www.engineeringtoolbox.com/utm-latitude-longitude-d_1370.html 
##                writer.writerow(
##                    [str(int(ang)),
##                     str(int(easting)),
##                     str(int(northing)),
##                     zone,
##                     r,
##                     d2,
##                     str(format(di, '.2f')),
##                     str(int(i))])
##        f.close

## v1.2 - Stable that writes a CSV and corrects the following:
## Add a method to specify the number of images per line segment.
## Add a method to specify each line segment distance.
## Something is going wrong with the di calculation and making the lengths longer than intended.
        ## It looks like it's always us 50 instead of going onto the next index in the list d.
##inputs = []
##
##for i in range(4):
##        rg = input('Image interval: ')
##        d = input('Segment distance: ')
##        inputs.append([rg,d])
##
##with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
##        print('Creating coordinates.csv')
##        writer = csv.writer(f)
##        writer.writerow(['angle','easting','northing','zone','interval','initialDist','distInput','sub-iteration'])
##        for i in inputs:
##            r = i[0]
##            di = float(i[1]) / r
##            d2 = i[1]
##            if (ang + 90) <= 360: ang = ang + 90
##            else: ang = ang + 90 - 360
##            for i in range(0,r,1):
##                    easting = easting + (math.sin(math.radians(ang)) * (di))
##                    northing = northing + (math.cos(math.radians(ang)) * (di))
####                writer.writerow([str(int(northing)),str(int(easting)),zone]) ## Use this for conversion input at http://www.engineeringtoolbox.com/utm-latitude-longitude-d_1370.html 
##                    writer.writerow(
##                        [str(int(ang)),
##                         str(format(easting, '.2f')),
##                         str(format(northing, '.2f')),
##                         zone,
##                         r,
##                         d2,
##                         str(format(di, '.2f')),
##                         str(int(i + 1))])
##        f.close

## v1.3 - Developing:
##inputs = []
##
##for i in range(4):
##        rg = input('Image interval: ')
##        d = input('Segment distance: ')
##        inputs.append([rg,d])
##
##with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
##        print('Creating coordinates.csv')
##        writer = csv.writer(f)
##        writer.writerow(['angle','easting','northing','zone','interval','initialDist','distInput','sub-iteration'])
##        for i in inputs:
##            r = i[0]
##            di = float(i[1]) / r
##            d2 = i[1]
##            if (ang + 90) <= 360: ang = ang + 90
##            else: ang = ang + 90 - 360
##            for i in range(0,r,1):
##                    writer.writerow(
##                        [str(int(ang)),
##                         str(format(easting, '.2f')),
##                         str(format(northing, '.2f')),
##                         zone,
##                         r,
##                         d2,
##                         str(format(di, '.2f')),
##                         str(int(i + 1))])
##                    easting = easting + (math.sin(math.radians(ang)) * (di))
##                    northing = northing + (math.cos(math.radians(ang)) * (di))
##
##        f.close

## v1.4 - Developing:

inputs = []

DIR = input('Which directory do you want to examine? ')

with open('C:/Users/' + usr + '/Documents/filenames.csv', 'wb', 1) as f:
    print('Creating filenames.csv')
    writer = csv.writer(f)
    writer.writerow(['filename'])
    for path, dirs, files in os.walk(DIR):
        for filename in files:
            writer.writerow([filename])

files = open('C:/Users/' + usr + '/Documents/filenames.csv')

for i in range(4):
        rg = input('Image interval: ')
        d = input('Segment distance: ')
##        el = input('Point elevation: ')
        inputs.append([rg,d,el])

        with open('C:/Users/' + usr + '/Documents/coordinates.csv', 'wb', 1) as f:
                print('Creating coordinates.csv')
                writer = csv.writer(f)
                writer.writerow(['#Label','X/East','Y/North','Z/Altitude','Error_(m)','X_error','Y_error','Z_error','X_est','Y_est','Z_est'])
##                el1 = i[
                for i in inputs:
                        for filename in files:
                                fi = filename
                        r = i[0]
                        di = float(i[1]) / r
                        d2 = i[1]
##                        el = 
                        if (ang + 90) <= 360: ang = ang + 90
                        else: ang = ang + 90 - 360
                        for i in range(0,r,1):
                            writer.writerow(
                                [fi,
                                 str(format(easting, '.2f')),
                                 str(format(northing, '.2f')),
##                                 el,
                                 '',
                                 '3.28',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',
                                 '',])
                            easting = easting + (math.sin(math.radians(ang)) * (di))
                            northing = northing + (math.cos(math.radians(ang)) * (di))

        f.close

## Implement coordinate conversion using either numPy or pyproj.
## This program currently doesn't print out the initial coordinate.
        ## It may be possible to take the initial input, calculate based off a back azimuth and distance.
## Calculation is done in a right hand circle only.
## Conversion form mils to degrees is mil * 0.05625.
##        yes = 'yes'
##        no = 'no'
##        if input('Is your azimuth in mils? ') == yes: ang = int(input('Initial Angle: ') * 0.05625 - 90)
##        else: ang = input('Initial Angle: ') - 90
## Transition table format to Agisoft reference format.
	## writer.writerow(['#Label','X/East','Y/North','Z/Altitude','Error_(m)','X_error','Y_error','Z_error','X_est','Y_est','Z_est'])
## Include plotting
##        import numpy as np
##        import matplotlib.pyplot as plt
with open('C:/Users/' + usr + '/Documents/coordinates.csv') as f:
        rdr = csv.reader(f, delimiter = ',')
        f.readline()
        for row in rdr:
                x = row[1]
                y = row[2]
                plt.scatter(x,y)

plt.show()

print('Process Complete')
