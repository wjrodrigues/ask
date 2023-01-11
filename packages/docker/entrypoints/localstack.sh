#!/bin/sh

set -e

## Bucket's

# Files
aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket profilePictures
aws --endpoint-url=http://localhost:4566 s3api put-bucket-acl --bucket profilePictures --acl public-read
awslocal --endpoint-url=http://localhost:4566 s3api put-bucket-cors --bucket profilePictures --cors-configuration file:///localstack/profile_pictures.json
aws --endpoint-url=http://localhost:4566 s3api get-bucket-cors --bucket profilePictures
