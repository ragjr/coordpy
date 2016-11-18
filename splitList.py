# Create a text document with coordinate pairs.
with open("C:/Users/ragilbert/Desktop/stringCoord.txt") as a:
        data = a.read().strip().split(';')
        #data = a.strip().split(',')

data = [x.strip() for x in data];
data = [[float(coord) for coord in pair] for pair in fo]
#data = [x.strip() for x in data.split(',')];

fo = open("C:/Users/ragilbert/My Documents/coordinates.txt","w+");

for i in data:
	fo.write(i + '\n');
        #print i + '\n'
        
fo.close();

##import shapefile
##fo = open("C:/Users/ragilbert/My Documents/coordinates.txt","r");
##fo = [[float(coord) for coord in pair] for pair in fo]
### Create a polygon shapefile
##w = shapefile.Writer(shapefile.POLYGON)
##w.poly(fo)
##w.field('FIRST_FLD','C','40')
##w.field('SECOND_FLD','C','40')
##w.record('First','Polygon')
##w.save('C:/Users/ragilbert/My Documents/test/polygon')
