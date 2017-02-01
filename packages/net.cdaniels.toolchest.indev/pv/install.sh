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

TIMESTAMP=`iso8601date`
LOG_DIR="$NET_CDANIELS_TOOLCHEST_DIR/local/log/"
LOG_FILE="$LOG_DIR/$PACKAGE_NAME.$TIMESTAMP.install.log"

if [ ! -e remote/pv.tar.gz ] ; then
  echo "ERROR 19: dependancy pv.tar.gz was not fetched."
  exit 1
fi

printf "extracting files... "
cd remote
tar -xf pv.tar.gz
if [ $? -ne 0 ] ; then
  echo "FAIL"
  echo "ERROR 28: failed to extract pv.tar.gz"
  exit 1
else
  echo "DONE"
fi
rm pv.tar.gz
mv pv-* pv
cd pv
printf "INFO: building pv... "
./configure >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ] ; then
  echo "ERROR 43: failed to configure pv"
  echo "DEBUG: log file is: $LOG_FILE"
  exit 1
fi
make >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ] ; then
  echo "ERROR 49: failed to build pv"
  echo "DEBUG: log file is: $LOG_FILE"
  exit 1
fi
echo "DONE"

cd ../..
mkdir bin/
mv remote/pv/pv bin/pv
ln -s "$PACKAGE_PATH/bin/pv" "$NET_CDANIELS_TOOLCHEST_DIR/local//bin/pv"

rm -rf ./remote

exit 1
