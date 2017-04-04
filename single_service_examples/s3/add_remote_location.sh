#!/bin/bash
BUCKET_NAME=dadams-terraform_remote_state
FILE_PATH=$1
REGION=us-east-1

if [ -z $FILE_PATH ]; then
  echo Usage: add_remote_location.sh PATH
  exit 1
fi

#we don't need backup since bucket versioning is enabled
terraform remote config -backend=s3 -backend-config="bucket=$BUCKET_NAME" -backend-config="key=$FILE_PATH" -backend-config="region=$REGION" -backup="-"
