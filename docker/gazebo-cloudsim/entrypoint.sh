#!/bin/bash
set -e

# source gazebo environment
source "/usr/share/gazebo/setup.sh"
echo "Entrypoint executed"
exec "$@"

