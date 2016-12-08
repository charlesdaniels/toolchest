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
  printf "INFO: linking $f... "

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

