#!/bin/sh

# wrapper script for tomdoc.sh

$(acquire-toolchest-dirs)

SCRIPT_PATH="$NET_CDANIELS_TOOLCHEST_PACKAGES/net.cdaniels.toolchest.ports/tomdoc.sh/remote/tomdoc.sh"
if [ ! -x "$SCRIPT_PATH" ] ; then
	chmod +x "$SCRIPT_PATH"
fi

"$SCRIPT_PATH" "$@"
