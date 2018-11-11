# hellogo

It is a simple Dockerized "hello world" app written on go.

## Run locally

```
docker run -ti -e PORT=80 -p 8080:80 dmitrievav/hellogo
```

Then open http://127.0.0.1:8080

## Run on Minikube

__Prerequisites:__
- You need up and running Minikube.
- Something like dnsmasq to point \*.minikube to minikube IP. Modifying /etc/hosts works as well, but not very convenient.
- installed kubectl
- installed helm

```
./run.sh
```