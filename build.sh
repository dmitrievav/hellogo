#!/bin/bash

set -e

rm -f main || true

cat > Dockerfile.compile <<EOF
FROM golang:latest
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
ENV PORT 8080
EXPOSE 8080
CMD ["/app/main"]
EOF
docker build -t temp -f Dockerfile.compile .
rm -f Dockerfile.compile
docker run --name temp --rm -d temp sleep 60
docker cp temp:/app/main ./
docker rm -f temp

IMAGE_PREFIX=dmitrievav
IMAGE_NAME=hellogo
TAG=latest

docker build -t $IMAGE_PREFIX/$IMAGE_NAME:$TAG .
rm -f main
docker push $IMAGE_PREFIX/$IMAGE_NAME:$TAG