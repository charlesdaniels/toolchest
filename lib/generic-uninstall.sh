#!/bin/sh
########10########20########30## DOCUMENTATION #50########60########70########80
#
#  OVERVIEW
#  ========
#  
#  Uninstalls things installed by generic-install.sh. 
#  
#  Note that this script depends on the current working directory being the
#  package root. If it is not, things will definitely break in unpredictable
#  ways. To this end, you should probably not run this by hand. 
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
  printf "INFO: (bin) unlinking $f... "

  # make sure the thing we are trying to uninstall exists and is a link
  if [ -L "$DEST_FILE" ] ; then
    rm "$DEST_FILE"
  
    if [ $? -ne 0 ] ; then
      echo "FAIL"
      echo "ERROR 42: failed to remove link"
      exit 1
    fi
  elif [ -e "$DEST_FILE" ] ; then
    echo "WARN"
    echo "WARNING 46: $DEST_FILE exists, but is not a symlink, skipping it"
  fi

  echo "DONE"
done

cd ..
if [ -d lib ] ; then
  # for convenience, we go relative to the already calculated directories
  LIB_DIR="$DEST_DIR/../lib/$PACKAGE_NAME"

  cd lib 
  for f in * ; do
    printf "INFO: (lib) unlinking $f... "

    if [ -L "$LIB_DIR/$f" ] ; then
      rm "$LIB_DIR/$f"
    elif [ -e "$LIB_DIR/$f" ] ; then
      echo "WARN"
      echo "WARNING 104: $LIB_DIR/$f exists but is not a symlink!"
    fi
    echo "DONE"
  done
  cd ..
  printf "INFO: removing library... "
  rmdir lib
  echo "DONE"
fi
