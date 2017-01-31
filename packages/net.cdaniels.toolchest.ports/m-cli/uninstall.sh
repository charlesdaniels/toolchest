#!/bin/sh

# package uninstaller for m-cli


PACKAGE_NAME="m-cli"

$(acquire-toolchest-dirs)


if ! (: "${NET_CDANIELS_TOOLCHEST_DIR?}") 2>/dev/null; then
  echo "ERROR 7: NET_CDANIELS_TOOLCHEST_DIR is not defined, installation failed"
  exit 1
fi

if ! (: "${PACKAGE_NAME?}") 2>/dev/null; then
  echo "ERROR 68: PACKAGE_NAME is not defined, installation failed"
  exit 1
fi

if ! (: "${PACKAGE_PATH?}") 2>/dev/null; then
  echo "ERROR 7: PACKAGE_PATH is not defined, installation failed"
  exit 1
fi

PACKAGE_DIR="$PACKAGE_PATH"

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

