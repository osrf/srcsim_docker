#!/usr/bin/env bash

# This script is used to upload a host path to S3.
# The script expects 3 arguments:
# --- 1) The image name.
# --- 2) The host path that will be uploaded.
# --- 3) An optional command to execute in the running container. E.g. /bin/bash 
# Example command line:
# ./run_s3bucket_container.bash s3bucket $HOME/myfolder/

# The script also assumes there are 2 files in the host's user home:
# --- $HOME/.passwd-s3fs: contains AWS keys in this format -> public:private
# --- $HOME/.bucketname-s3fs: contains the bucket name to use in S3

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "This script is used to upload a host path to S3."
  echo "The script expects 3 arguments:"
  echo "--- 1) The image name."
  echo "--- 2) The host path that will be uploaded."
  echo "--- 3) An optional command to execute in the running container. E.g. /bin/bash "
  echo "Example command line:"
  echo "$ ./run_s3bucket_container.bash s3bucket HOME/myfolder/"
  echo ""
  echo "The script also assumes there are 2 files in the host's user home:"
  echo "--- HOME/.passwd-s3fs: contains AWS keys in this format -> public:private"
  echo "--- HOME/.bucketname-s3fs: contains the bucket name to use in S3"
  exit 1
fi

IMAGE_NAME=$1
HOST_PATH=$2
COMMAND=$3

# note: --privileged is needed if we want to use s3fs mounts
docker run --rm \
  --device=/dev/fuse \
  --privileged \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v ${HOME}/.passwd-s3fs:/root/.passwd-s3fs \
  -v ${HOME}/.bucketname-s3fs:/root/.bucketname-s3fs \
  -v ${HOST_PATH}:/to-upload \
  ${IMAGE_NAME} \
  ${COMMAND}
