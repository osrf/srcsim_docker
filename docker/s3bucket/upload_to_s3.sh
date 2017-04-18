#!/bin/bash
set -e

# This script uploads the contents of folder "/to-upload/" to configured S3 bucket.
# It is expected that this /to-upload folder to be a volume from a host path.
cp -r /to-upload/ /mnt/s3bucket/
echo "$0 executed"
