#!/bin/bash

#docker run -ti -e PORT=80 -p 8080:80 dmitrievav/hellogo

# You can "disable" RBAC using the command
#kubectl create clusterrolebinding permissive-binding \
#  --clusterrole=cluster-admin \
#  --user=admin \
#  --user=kubelet \
#  --group=system:serviceaccounts;

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --upgrade --service-account tiller

for i in {1..60}
do
  kubectl -n kube-system get pod | grep tiller | grep ' Running' && break \
  || echo Waiting tiller server;
  sleep 1;
  [ $i = 60 ] && echo Tiller server timeout && exit 1
done

helm init --upgrade --service-account tiller
helm repo add dmitrievav https://dmitrievav.github.io/helm/charts
helm repo update dmitrievav

if ! helm status hellogo 2>/dev/null; then
    echo "Creating initial release"
	helm install --wait \
		--name hellogo \
		--namespace default \
		-f helm_values.yaml \
		dmitrievav/statefulapp
else
    echo "Upgrading release"
	helm upgrade --wait \
		hellogo \
		--namespace default \
		-f helm_values.yaml \
		dmitrievav/statefulapp
fi