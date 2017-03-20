DOCKER_ARGS=""
# Uncoment this line to rebuild without cache
#DOCKER_ARGS="--no-cache"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker build ${DOCKER_ARGS} -t gazebo:latest $DIR/gazebo
docker build ${DOCKER_ARGS} -t nvidia-gazebo:latest $DIR/nvidia-gazebo
docker build ${DOCKER_ARGS} -t nvidia-gazebo-ros:latest $DIR/nvidia-gazebo-ros
docker build ${DOCKER_ARGS} -t src-cloudsim:latest $DIR/src-cloudsim
docker build ${DOCKER_ARGS} -t s3bucket:latest $DIR/s3bucket
