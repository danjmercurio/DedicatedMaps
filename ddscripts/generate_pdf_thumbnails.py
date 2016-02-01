#!/usr/bin/python
# by dan mercurio dan.j.mercurio@gmail.com

import os
import PythonMagick

DPI = "72" # Image quality level for ImageMagick
SEARCH_DIRECTORY = "../public/pdf" # Directory to look for PDF files
OUTPUT_DIRECTORY = "thumbs" # Output directory relative to (rails root)/public/pdf

def isPDF(filename):
	return filename.lower().endswith(".pdf")

# Instantiate ImageMagick class
img = PythonMagick.Image()
img.density(DPI) # Set target resolution

os.chdir(SEARCH_DIRECTORY)
print "Looking for PDF files in " + SEARCH_DIRECTORY

for filename in os.listdir(os.getcwd()):
	if isPDF(filename):
		label, extension = os.path.splitext(filename)
		read_path = os.path.join(os.getcwd(), filename)
		write_path = os.path.join(os.getcwd(), OUTPUT_DIRECTORY, label) + ".png"
		if (os.path.exists(write_path)):
			print "File " + write_path + " already exists. Skipping..."
		else:
			img.read(read_path)
			img.write(write_path)
			print "Created thumbnail " + label + ".png from file " + filename + " in " + write_path
	else:
		print "File " + filename + " is not of type PDF. Skipping..."
print "Done."


