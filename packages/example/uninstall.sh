#!/bin/sh

# simple package installer example

# make sure the caller knows what toolchest it's working with
if ! (: "${NET_CDANIELS_TOOLCHEST_DIR?}") 2>/dev/null; then
  echo "ERROR 7: NET_CDANIELS_TOOLCHEST_DIR is not defined, installation failed"
  exit 1
fi

# setup some convenient shortcuts
PACKAGE_NAME="example"
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
  printf "INFO: unlinking $f... "

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

