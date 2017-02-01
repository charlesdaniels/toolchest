#!/bin/sh

# invoke the fixwifi command from this package via a GUI
# (this file should be double-click-able)

echo "INFO: will now invoke macosutils-fixiwfi."
macosutils-fixwifi
exit $?