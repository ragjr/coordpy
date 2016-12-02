import os, csv, arcpy

# Define global variables
print('User Account: ' + os.environ.get( "USERNAME" ))
usr = os.environ.get( "USERNAME" )

############# Create text files with filenames #############
# metadata
x = 0
with open('C:/Users/' + usr + '/Documents/metaCleanup.csv', 'wb', 1) as f:
    print('Creating metaCleanup.csv')
    writer = csv.writer(f)
    writer.writerow(['OBJECTID','filename'])
    for path, dirs, files in os.walk("P:/metadata"):
        for filename in files:
            x = x + 1
            writer.writerow([x,filename])

# zip
x = 0
with open('C:/Users/' + usr + '/Documents/zipCleanup.csv', 'wb') as f:
    print('Creating zipCleanup.csv')
    writer = csv.writer(f)
    writer.writerow(['OBJECTID','filename'])
    for path, dirs, files in os.walk("P:/zip"):
        for filename in files:
            x = x + 1
            writer.writerow([x,filename])

############# Copy text data into the default geodatabase #############
# Set local variables to copy 
ws = 'C:/Users/' + usr + '/Documents/'
db = 'C:/Users/' + usr + '/Documents/ArcGIS/Default.gdb'

# create a list of new tables
arcpy.env.workspace = ws
newTables = arcpy.ListTables('*cleanup*')

# create a list of old tables
arcpy.env.workspace = db
oldTables = arcpy.ListTables('*cleanup*')

# delete existing tables
print('Deleting current tables.')
for i in oldTables:
    print('Deleting ' + i)
    arcpy.Delete_management(i)

# import both tables
print("Importing tables to gdb: " + db)
for table in newTables:
	table = ws + table
	arcpy.TableToGeodatabase_conversion(table, db)
