#!/bin/bash

cat > Dockerfile.gore <<EOF
FROM golang:latest
RUN go get -u github.com/motemen/gore
CMD ["gore"]
EOF

docker build -t gore -f Dockerfile.gore .
rm -f Dockerfile.gore
docker run --name gore --rm -ti gore