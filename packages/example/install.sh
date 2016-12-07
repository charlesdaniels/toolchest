#!/bin/sh

# simple package installer example

# make sure the destination does not already exist
if [ -e "$NET_CDANIELS_TOOLCHEST_DIR/local/bin/coolscript.sh" ] ; then
  echo "ERROR 7: $NET_CDANIELS_TOOLCHEST_DIR/local/bin/coolscript.sh already exists"
  exit 1
fi

printf "INFO: installing coolscript.sh ... " 
ln -s $NET_CDANIELS_TOOLCHEST_DIR/packages/example/coolscript.sh $NET_CDANIELS_TOOLCHEST_DIR/local/bin/coolscript.sh
echo "DONE"