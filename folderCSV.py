import os, csv

# metadata
with open("C:/Users/ragilbert/Documents/folder.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['filename']) 
    for path, dirs, files in os.walk("P:/metadata"):
        for filename in files:
            writer.writerow([filename])
			
# zip
with open("C:/Users/ragilbert/Documents/folder.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['filename'])
    for path, dirs, files in os.walk("P:/zip"):
        for filename in files:
            writer.writerow([filename])

###########################################################################S

import os, shutil

src_files = os.listdir("P:/metadata")
check_files = open("C:/Users/ragilbert/Documents/metaRemoval.csv")
for filename in src_files:
    full_file_name = os.path.join(src, filename)
    if (os.path.isfile(full_file_name)):
        shutil.copy(full_file_name, dest)

