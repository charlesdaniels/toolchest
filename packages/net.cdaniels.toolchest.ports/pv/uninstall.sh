#!/bin/sh

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

printf "INFO: unlinking pv... "
rm "$NET_CDANIELS_TOOLCHEST_DIR/local/bin/pv" >> /dev/null 2>&1
echo "DONE"

printf "INFO: cleaning package directory... "
rm -rf "$PACKAGE_PATH/bin/"  >> /dev/null 2>&1
rm -rf "$PACKAGE_PATH/remote"  >> /dev/null 2>&1
echo "DONE"
