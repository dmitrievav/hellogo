#!/bin/bash

IMAGE_PREFIX=dmitrievav
IMAGE_NAME=hellogo
TAG=latest

docker build -t $IMAGE_PREFIX/$IMAGE_NAME:$TAG .
docker push $IMAGE_PREFIX/$IMAGE_NAME:$TAG