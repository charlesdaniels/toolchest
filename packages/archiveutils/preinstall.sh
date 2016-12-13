#!/bin/sh

# preinstall for archiveutils

$(acquire-toolchest-dirs)

source "$NET_CDANIELS_TOOLCHEST_LIB/check-command-exists.lib"

DEPENDS="wget parallel md5 shasum"
OPTIONAL=""



for dep in $DEPENDS ; do
  printf "INFO: testing $dep... "
  check_command_exists $dep
  if [ $? -eq 0 ] ; then
    echo "OK"
  else
    echo "ERROR: not found"
    exit 1
  fi
done
  
for dep in $OPTIONAL ; do
  printf "INFO: testing $dep... "
  check_command_exists $dep
  if [ $? -eq 0 ] ; then
    echo "OK"
  else
    echo "WARN: not found (some tools may not work)"
  fi
done