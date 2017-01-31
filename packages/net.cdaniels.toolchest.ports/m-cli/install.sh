#!/bin/sh

# package installer for m-cli

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

INSTALLER_URL="https://raw.githubusercontent.com/rgcr/m-cli/master/install.sh"
PACKAGE_DIR="$PACKAGE_PATH"

# the grep -v prevents m-cli from linking into /usr/local/bin
curl -fsSL "$INSTALLER_URL" | grep -v "/usr/local/bin/m" | INSTALL_DIR="$PACKAGE_DIR/bin" sh

if [ $? -ne 0 ] ; then
  echo "ERROR 23: m-cli installer failed"
  exit 1
fi

printf "INFO: linking m... "
ln -s $PACKAGE_DIR/bin/m $NET_CDANIELS_TOOLCHEST_LOCAL/bin/m
echo "DONE"