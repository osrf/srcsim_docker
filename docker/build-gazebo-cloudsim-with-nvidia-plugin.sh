DOCKER_ARGS=""
# Uncoment this line to rebuild without cache
DOCKER_ARGS="--no-cache"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build ${DOCKER_ARGS} -t gazebo-cloudsim:latest $DIR/gazebo-cloudsim
docker build ${DOCKER_ARGS} -t gazebo-cloudsim-nvidia-docker-plugin:latest $DIR/gazebo-cloudsim-nvidia-docker-plugin
