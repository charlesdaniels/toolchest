#!/bin/sh
########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#  
#  Generic package installer script. This is most useful for simple scripts
#  that don't require complex compilation or dependency checking. This script
#  can simply be symlinked into the package directory (don't forget to call
#  the destination install.sh).
#   
#  This script assumes that all the things you want to be in $PATH are in bin/
#  under the package root, with the names you want them to have.
#  
#  This script will also check to see if lib/ exists under the package root,
#  and if so, will symlink everything in it into local/lib/$PACKAGNAME
#  
#  Note that this script depends on the current working directory being the
#  package root. If it is not, things will definitely break in unpredictable
#  ways. To this end, you should probably not run this by hand. 
#  
#  If the file `preinstall.sh` is present in the top level of the package
#  directory, generic-install will call it before performing the installation.
#  This is particularly useful for checking that dependencies are installed.
#  If the preinstall script exits with a nonzero exit code, generic-install
#  will also exit with a nonzero exit code, without performing the
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
########10########20########30########40########50########60########70########80

# make sure the caller knows what toolchest it's working with
if ! (: "${NET_CDANIELS_TOOLCHEST_DIR?}") 2>/dev/null; then
  echo "ERROR 7: NET_CDANIELS_TOOLCHEST_DIR is not defined, installation failed"
  exit 1
fi

# run preinstall script, if present
if [ -e ./preinstall.sh ] ; then
  ./preinstall.sh 
  if [ $? -ne 0 ] ; then
    echo "ERROR 61: preinstall script failed"
    exit 1
  fi
fi

# setup some convenient shortcuts
PACKAGE_NAME=$(basename `realpath .`)  # ugly hack to get package name
DEST_DIR="$NET_CDANIELS_TOOLCHEST_DIR/local/bin"
SRC_DIR="$NET_CDANIELS_TOOLCHEST_DIR/packages/$PACKAGE_NAME/bin"

# sanity check - make sure we are installing from the toolchest the caller
# thinks we are installing from
if [ `realpath ./bin` != "$SRC_DIR" ] ; then
  echo "ERROR 19: package source directory mismatch. This is really bad. You"
  echo "          seem to have NET_CDANIELS_TOOLCHEST_DIR pointing somewhere"
  echo "          other than your toolchest installation"
  exit 1
fi

# this gives us just the filename (eg. file1 file2 file 3 as opposed to
# bin/file1 bin/file2 bin/file3 and so on)
cd ./bin/

# loop over everything in bin/ and setup the symlinks
for f in * ; do
  SRC_FILE="$SRC_DIR/$f"
  DEST_FILE="$DEST_DIR/$f"
  printf "INFO: (bin) linking $f... "

  # make sure the destination does not already exist
  if [ -e "$DEST_FILE" ] ; then
    echo "FAIL"
    echo "ERROR 34: destination file $DEST_FILE already exists"
    exit 1
  fi

  ln -s "$SRC_FILE" "$DEST_FILE"

  # make sur ethe link operation woked
  if [ $? -ne 0 ] ; then
    echo "FAIL"
    echo "ERROR 42: failed to create link"
    exit 1
  fi

  echo "DONE"
done

# install any libraries if they exists
cd ..
if [ -d lib ] ; then
  # for convenience, we go relative to the already calculated directories
  LIB_DIR="$DEST_DIR/../lib/$PACKAGE_NAME"
  if [ -d "$LIB_DIR" ] ; then
    # lib dir can't already exist
    echo "ERROR 123: lib dir \"$LIB_DIR\" already exists!"
    exit 1
  fi
  mkdir "$LIB_DIR"
  cd lib 
  for f in * ; do
    printf "INFO: (lib) linking $f... "

    if [ -e "$LIB_DIR/$f" ] ; then
      # library in question can't already exist
      echo "FAIL"
      echo "ERROR 132: destination file "$LIB_DIR/$f" already exists!"
      exit 1
    fi

    # do the link operation
    ln -s "$SRC_DIR/../lib/$f" "$LIB_DIR/$f"

    if [ $? -ne 0 ] ; then
      # make sure it worked
      echo "FAIL"
      echo "ERROR 138: failed to create link from \"$SRC_DIR/../lib/$f\" to \"$LIB_DIR/$f\""
      exit 1
    fi
    echo "DONE"
  done
fi
