#!/bin/bash
set -e

# This script uploads the contents of folder "~/simulation-logs/" to configured S3 bucket.
cp -r .gazebo/log/ /mnt/s3bucket/
echo "$0 executed"
