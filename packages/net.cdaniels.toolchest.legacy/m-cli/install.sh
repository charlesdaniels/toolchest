#!/bin/sh

# package installer for m-cli

PACKAGE_NAME="m-cli"

$(acquire-toolchest-dirs)

INSTALLER_URL="https://raw.githubusercontent.com/rgcr/m-cli/master/install.sh"
PACKAGE_DIR="$NET_CDANIELS_TOOLCHEST_PACKAGES/$PACKAGE_NAME"

echo $OSTYPE | grep darwin > /dev/null 
if [ $? -ne 0 ] ; then
  echo "ERROR 17: m-cli may only be installed on macOS operating systems"
  echo "INFO: reported OSTYPE is $OSTYPE"
  exit 1
fi

# the grep -v prevents m-cli from linking into /usr/local/bin
curl -fsSL "$INSTALLER_URL" | grep -v "/usr/local/bin/m" | INSTALL_DIR="$PACKAGE_DIR/bin" sh

if [ $? -ne 0 ] ; then
  echo "ERROR 23: m-cli installer failed"
  exit 1
fi

printf "INFO: linking m... "
ln -s $PACKAGE_DIR/bin/m $NET_CDANIELS_TOOLCHEST_LOCAL/bin/m
echo "DONE"