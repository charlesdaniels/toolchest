#!/bin/sh

# simple uninstaller example

if [ -L $NET_CDANIELS_TOOLCHEST_DIR/local/bin/coolscript.sh ] ; then
  printf "INFO: uninstalling coolscript.sh ... "
  rm $NET_CDANIELS_TOOLCHEST_DIR/local/bin/coolscript.sh
  echo "DONE"
fi