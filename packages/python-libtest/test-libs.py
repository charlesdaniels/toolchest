
########10########20########30########40########50########60########70########80
# boilerplate to load net.cdaniels.toolchest libraries
import subprocess
import os 
import sys

# acquire toolchest installation location
toolchest_path = subprocess.check_output(["acquire-toolchest-dirs", "dironly"]).decode()
toolchest_path = toolchest_path.replace("\n","")

# toolchest_path now points to the toolchest installation folder - you can
# import libraries relative to this by first doing sys.path.append(somepath),
# then import libraryname. Remember that the most correct way to do path
# concatenation is with os.path.join().

########10########20########30########40########50########60########70########80

# this is testing code, don't copy paste it! 

print("toolchest path appears to be: {}".format(toolchest_path))