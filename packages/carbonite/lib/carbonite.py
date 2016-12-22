########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#
#  For carbonite usage information, please consult the "carbonite" wrapper
#  script.
#  
#  This file contains the implementation of the carbonite application. It is
#  intended to reside in $NET_CDANIELS_TOOLCHEST_DIR/local/lib/carbonite, and
#  to be executed by a wrapper script placed in $PATH.
#  
#  Documentation for specific functions and whatnot is inlined with the rest
#  of the source in this file.
#  
#  Note that carbonite is not intended to be used outside of a toolchest
#  installation.
#
########10########20########30##### LICENSE ####50########60########70########80
#  Copyright (c) 2016, Charles Daniels
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#
#  1. Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  3. Neither the name of the copyright holder nor the names of its
#     contributors may be used to endorse or promote products derived from
#     this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
########10########20########30## CONFIGURATION #50########60########70########80

carbonite_version = "0.0.1"

########10########20########30########40########50########60########70########80
# boilerplate to load net.cdaniels.toolchest libraries
import subprocess
import os 
import sys

# acquire toolchest installation location
toolchest_path = subprocess.check_output(["toolchest", "dir"]).decode()
toolchest_path = toolchest_path.replace("\n","")
print(toolchest_path)

# get the path of the net.cdaniels.python libraries
python_toolchest = "net.cdaniels.python"
python_toolchest_path = os.path.join(toolchest_path, "local")
python_toolchest_path = os.path.join(python_toolchest_path, "lib")
python_toolchest_path = os.path.join(python_toolchest_path, python_toolchest)

if os.path.exists(python_toolchest_path):
  # we want to be able to import modules from here
  sys.path.append(python_toolchest_path)

carbonite_lib_dir = os.path.join(toolchest_path, "local")
carbonite_lib_dir = os.path.join(carbonite_lib_dir, "lib")
carbonite_lib_dir = os.path.join(carbonite_lib_dir, "carbonite")



########10########20########30########40########50########60########70########80
# imports
import argparse
import sys
import os
import subprocess
import shutil


########10########20########30########40########50########60########70########80
# temputils setup
temputils_bin = "temputils"
temputils_TIMESTAMP = subprocess.check_output(["iso8601date"]).decode()
temputils_APPTAG = "carbonite_{}".format(temputils_TIMESTAMP)
subprocess.call([temputils_bin, temputils_APPTAG, "create"])
working_directory = subprocess.check_output([temputils_bin, temputils_APPTAG, "get"]).decode()
working_directory = working_directory.replace("\n", "")
starting_directory = os.getcwd()


########10########20########30########40########50########60########70########80
# argument parsing

print("INFO: beginning carbonite execution.")

parser = argparse.ArgumentParser(description="create standalone executables from shell scripts")
parser.add_argument("--include",
                    nargs="+",  # accept arbitrarily many positionals
                    default=[],
                    help="files to include in the archive")
parser.add_argument("--payload",
                    help="file to execute when executable is invoked",
                    required=True)
parser.add_argument("--archive_only",
                    action="store_true",
                    help="create payload and manifest, but do not prepend the self extraction script")
parser.add_argument("--extract",
                    action="store_true",
                    help="extract a carbonate archive without invoking the payload")
parser.add_argument("--checksum_format",
                    help="checksum format (md5, sha256 or shasum)",
                    default="sha256")
parser.add_argument("--compression_format",
                    help="compression to use (none, gz, or xz)",
                    default="gz")
parser.add_argument("--output",
                    help="output file",
                    default="DEFAULT")

args = parser.parse_args()

########10########20########30########40########50########60########70########80
# exit functions

# exit_error
# ==========
#
# exit the program after a fatal error has occurred
def exit_error():
  subprocess.call([temputils_bin, temputils_APPTAG, "destroy"])
  sys.stdout.write("INFO: carbonite exiting due to fatal error.")
  exit(1)

# exit_normal
# ===========
#
# exit the program normally
def exit_normal():
  subprocess.call([temputils_bin, temputils_APPTAG, "destroy"])
  sys.stdout.write("INFO: carbonite exiting normally.")
  exit(0)

########10########20########30 GENERAL FUNCTIONS 0########60########70########80

# validate_componants
# ===================
#
# Validates that the payload and the files that have been added via --include
# actually exist. Additionally, due to the current implementation of extract-
# execute.lib, the payload filename may not contain spaces.
#
# If any component does not exist, or any part of the validation process
# fails, the program exits via exit_error()
#
# USAGE
# =====
#
# args . . . namespace from the argument parser
#
def validate_componants(args):
  # verified that components are present
  print("INFO: validating components: ")

  if ' ' in args.payload:
    print("ERROR 164: payload filename may not contain spaces")
    exit_error()

  if args.payload not in args.include:
    args.include.append(args.payload)

  for component in args.include:
    sys.stdout.write("\t{}... ".format(component))
    if not os.path.exists(component):
      print("FAIL")
      print("ERROR 90: component {} does not exist".format(component))
      exit_error()
    else:
      print("OK")

  print("INFO: all components present")



########10########20########30########40########50########60########70########80
# create_tarball
# ==============
#
# Add all of the components to a tarball in the temporary directory
#
# USAGE
# =====
#
# args . . . namesapce from the argument parser
#
# RETURNS
# =======
#
# Tuple containing the tarball's manifest, the absolute path to the tarball,
# and the filename of the tarball, in that order
#
def create_tarball(args):
  sys.stdout.write("INFO: generating component archive... ")
  tar_options     = "cvf"
  tar_bin         = "tar"
  tar_archivename = "contents.tar"
  tar_workingdir  = working_directory
  tar_archivepath = os.path.join(tar_workingdir, tar_archivename)
  tar_command     = [tar_bin, tar_options, tar_archivepath]
  tar_command    += args.include

  tar_manifest    = subprocess.check_output(tar_command, stderr=subprocess.STDOUT).decode()
  print("DONE")
  return (tar_manifest, tar_archivepath, tar_archivename)

########10########20########30########40########50########60########70########80
# compress_tarball
# ================
#
# Applies the desired compression program to the tarball. The tarball is
# modified in-place in the temporary directory.
#
# Note that if args.compression_format is not valid, this function will exit
# the program with exit_error().
#
# USAGE
# =====
#
# args . . . . . . . . namespace from the argument parser
#
# tar_archivepath  . . absolute path to the tarball
#
# tar_archivename  . . the filename of the tarball
#
# RETURNS
# =======
#
# Tuple containing the full path to the tarball and the filename of the
# tarball in that order.
#
def compress_tarball(args, tar_archivepath, tar_archivename):

  sys.stdout.write("INFO: compressing component archive with compression {}... "
                   .format(args.compression_format))
  if args.compression_format == "gz":
    subprocess.call(["gzip", tar_archivepath])
    tar_archivepath = tar_archivepath + ".gz"
    tar_archivename = tar_archivename + ".gz"
  elif args.compression_format == "xz":
    subprocess.call(["xz", tar_archivepath])
    tar_archivepath = tar_archivepath + ".xz"
    tar_archivename = tar_archivename + ".xz"
  elif args.compression_format == "none":
    pass
  else:
    print("FAIL")
    print("ERROR 123: no such compression format {}".format(args.compression_format))
    exit_error()

  print("DONE")
  return (tar_archivepath, tar_archivename)

########10########20########30########40########50########60########70########80
# checksum_tarball
# ================
#
# Generates the tarball's checksum using the selected method from args.
#
# Note that if args.checksum_format is not valid, this function will exit the
# program with exit_error().
#
# USAGE
# =====
#
# args . . . . . . . . namespace from argument parser
#
# tar_archivename  . . filename of tarvall
#
# RETURNS
# =======
#
# string containing the tarball's checksum
#
def checksum_tarball(args, tar_archivename):
  os.chdir(working_directory)
  checksum = None
  sys.stdout.write("INFO: generating archive checksum...")
  if args.checksum_format == "md5":
    checksum = subprocess.check_output(["md5", tar_archivename]).decode()
  elif args.checksum_format == "shasum":
    checksum = subprocess.check_output(["shasum", tar_archivename]).decode()
  elif args.checksum_format == "sha256":
    checksum = subprocess.check_output(["shasum", "-a", "256", tar_archivename]).decode()
  else:
    print("FAIL")
    print("ERROR 151: no such checksum method {}".format(args.checksum_format))
    exit_error()

  checksum = checksum.replace("\n", "")
  print("DONE")
  return checksum

########10########20########30########40########50########60########70########80
# encode_tarball
# ==============
#
# Encodes the tarball using the base64 command
#
# USAGE
# =====
#
# args  . . . . . . . namespace from argument parser
#
# tar_archivepath . . full path to tarball
#
# RETURNS
# =======
#
# string containing base64 encoded representation of the tarball
#
def encode_tarball(args):
  sys.stdout.write("INFO: encoding archive... ")
  base64_text = subprocess.check_output(["base64", tar_archivepath]).decode()
  print("DONE")
  return base64_text

########10########20########30########40########50########60########70########80
# generate_textarchive
# ====================
#
# Generates the text of the carbonite file. this includes the metadata
# (payload, checksum, compression method, checksum type, carbonite version),
# as well as the manifest, and the base64 encoded representation of the
# tarball.
#
# USAGE
# =====
#
# args . . . . . . . . namespace from argument parser
#
# checksum . . . . . . checksum for tarball
#
# tar_manifest . . . . manifest for tarball
#
# base64_text  . . . . base64 representation of tarball
#
# RETURNS
# =======
#
# String containing the non-script portion of the carbonite file.
#
def generate_textarchive(args, checksum, tar_manifest, base64_text):
  sys.stdout.write("INFO: generating text archive... ")
  archive_text  = "BEGIN CARBONITE INFO\n"
  archive_text += "PAYLOAD {}\n".format(args.payload)
  archive_text += "CHECKSUM {}\n".format(checksum)
  archive_text += "COMPRESSION {}\n".format(args.compression_format)
  archive_text += "CHECKSUM_TYPE {}\n".format(args.checksum_format)
  archive_text += "CARBONITE_VERSION {}\n".format(carbonite_version)
  archive_text += "END CARBONITE INFO\n"
  archive_text += "BEGIN CARBONITE MANIFEST\n"
  archive_text += tar_manifest
  archive_text += "END CARBONITE MANIFEST\n"
  archive_text += "BEGIN CARBONITE DATA\n"
  archive_text += base64_text
  archive_text += "END CARBONITE_DATA"
  print("DONE")
  return archive_text

########10########20########30###### MAIN ######50########60########70########80

if args.output == "DEFAULT":
  args.output = args.payload + ".carbonite"

if args.extract:
  print("ERRPR 341: not yet implemented")
  exit_error()

validate_componants(args)
tar_manifest, tar_archivepath, tar_archivename = create_tarball(args)
tar_archivepath, tar_archivename = compress_tarball(args, tar_archivepath, tar_archivename)
checksum = checksum_tarball(args, tar_archivename)
base64_text = encode_tarball(args)
archive_text = generate_textarchive(args, checksum, tar_manifest, base64_text)

carbonite_output_path = os.path.join(working_directory, args.output)
final_output_path = os.path.join(starting_directory, args.output)

if args.archive_only:
  sys.stdout.write("INFO: archive_only toggled, producing output...")
  with open (carbonite_output_path, "w") as f:
    f.write(archive_text)

  shutil.copy2(carbonite_output_path, final_output_path)
  print("DONE")
  exit_normal()

sys.stdout.write("INFO: generating standalone executable... ")
shutil.copy2(os.path.join(carbonite_lib_dir, "extract-execute.lib"),
             carbonite_output_path)

with open (carbonite_output_path, "a") as f:
    f.write(archive_text)

shutil.copy2(carbonite_output_path,final_output_path)
subprocess.call(["chmod", "+x", final_output_path])
print("DONE")

exit_normal()


