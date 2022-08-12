#!/bin/bash -eu
NAMESPACE=$1
BASE_DOMAIN=savvaco.net
kubectl create namespace $NAMESPACE || true
kubectl config set-context $(kubectl config current-context) --namespace=$NAMESPACE
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade -i mysql bitnami/mysql --version 9.2.0 -f helm/mysql.yaml --set-file="initdbScripts.db_init\.sql"=scripts/db_init.sql
helm upgrade -i redis bitnami/redis --version 17.0.1 -f helm/redis.yaml
helm upgrade -i lrvl helm/laravel -f helm/laravel/values.yaml \
  --set nginx.ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=laravel.$NAMESPACE.$BASE_DOMAIN \
  --set nginx.ingress.hosts[0].host=laravel.$NAMESPACE.$BASE_DOMAIN \
  --set nginx.ingress.hosts[0].paths[0].path="/*" \
  --set nginx.ingress.hosts[0].paths[0].pathType=ImplementationSpecific
helm upgrade -i react helm/react -f helm/react/values.yaml \
  --set ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=$NAMESPACE.$BASE_DOMAIN \
  --set ingress.hosts[0].host=$NAMESPACE.$BASE_DOMAIN \
  --set ingress.hosts[0].paths[0].path="/*" \
  --set ingress.hosts[0].paths[0].pathType=ImplementationSpecific
helm upgrade -i wordpress bitnami/wordpress --version 15.0.12 -f helm/wordpress.yaml \
  --set ingress.hostname=wp.$NAMESPACE.$BASE_DOMAIN \
  --set ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=wp.$NAMESPACE.$BASE_DOMAIN \
