import math;
lat = 4487619;
lon = 425112;
ang = 350;
dist = 30;

def calcAng(ang):
        if (ang + 90) <= 360: ang = ang + 90
        else: ang = ang + 90 - 360
        return ang;

def calcLat(lat):
        lat = lat + (math.sin(math.radians(ang))*dist)
        return lat;

def calcLon(lon):
        lon = lon + (math.cos(math.radians(ang))*dist)
        return lon;

##def sq(lat,lon,ang,dist):
##	print str(lat) + ' ' + str(lon) + ' ' + str(ang)
##	if (ang + 90) <= 360:
##		ang = ang + 90
##	else: ang = ang +90 - 360
##	lat = lat + (math.sin(math.radians(ang))*dist)
##	lon = lon + (math.cos(math.radians(ang))*dist)

#sq(4487619,425112,350,30)

##for i in range(4):
##	sq(lat,lon,ang,30)
##
##def sq(dist):
##        calcAng
##        calcLat
##        calcLon
