#!/bin/bash
set -e

# This entrypoint script expects 2 files in the user home:
# 1) .passwd-s3fs. Used by s3fs mount command. Contains a publicKey:privateKey pair.
# 2) .bucketname-s3fs. Used by this script to find out the name of the S3 bucket to use. 

if [ -f $HOME/.passwd-s3fs ]
then
    chmod 600 $HOME/.passwd-s3fs
    export S3_BUCKET_NAME=$(cat $HOME/.bucketname-s3fs)
    # only setup S3 mounts if we have the credentials
    /usr/bin/s3fs -o use_cache=/tmp ${S3_BUCKET_NAME} /mnt/s3bucket
fi

echo "S3 entrypoint executed"
exec "$@"
