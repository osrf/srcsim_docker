DOCKER_ARGS=""
# Uncoment this line to rebuild without cache
DOCKER_ARGS="--no-cache"

docker build ${DOCKER_ARGS} -t gazebo-cloudsim:latest gazebo-cloudsim
docker build ${DOCKER_ARGS} -t gazebo-cloudsim-nvidia-docker-plugin:latest gazebo-cloudsim-nvidia-docker-plugin

