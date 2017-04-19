#!/bin/bash
set -e

# first, execute overriden entrypoint from gazebo
source "/usr/share/gazebo/setup.sh"

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# setup SRC environment
source "/opt/nasa/indigo/setup.bash"
echo "SRC entrypoint executed"

exec "$@"
