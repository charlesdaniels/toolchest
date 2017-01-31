#!/bin/sh

# package uninstaller for m-cli


PACKAGE_NAME="m-cli"

$(acquire-toolchest-dirs)

PACKAGE_DIR="$NET_CDANIELS_TOOLCHEST_PACKAGES/$PACKAGE_NAME"

if [ -z "$PACKAGE_DIR" ] ; then
  echo "ERROR 13: unable to acquire package directory"
  exi t1
fi

printf "INFO: unlinking m... "
if [ -e $NET_CDANIELS_TOOLCHEST_LOCAL/bin/m ] ; then
  rm $NET_CDANIELS_TOOLCHEST_LOCAL/bin/m
  echo "DONE"
else
  echo "FAIL"
  echo "WARNING 23: m binary does not exist at $NET_CDANIELS_TOOLCHEST_LOCAL/bin/m"
fi

printf "INFO: removing package installation directory... "
if [ -d "$PACKAGE_DIR/bin" ] ; then
  rm -rf "$PACKAGE_DIR/bin"
  echo "DONE"
else
  echo "FAIL"
  echo "WARNING 21: no such installation directory $PACKAGE_DIR/bin"
fi

