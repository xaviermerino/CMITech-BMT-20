#!/bin/bash
#
# entrypoint.sh:
#   1) Prepend our SDK’s lib folder to LD_LIBRARY_PATH
#   2) Start systemd-udevd so our custom USB rules take effect
#   3) Exec whatever command was passed (or drop to bash)
#

# 1) Prepend SDK lib directory to any existing LD_LIBRARY_PATH
export LD_LIBRARY_PATH="/usr/local/CMITech/BMT20/x64/lib:${LD_LIBRARY_PATH}"

# 2) Launch the udev daemon in the background using the correct binary path
/lib/systemd/systemd-udevd --daemon
sleep 1

# 3) Exec the user’s command (or bash, by default)
exec "$@"
