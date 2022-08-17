#!/bin/bash -eu
NAMESPACE=$1
BASE_DOMAIN=savvaco.net
IMAGE_TAG=${2:-latest}

cd $(dirname "$0")
aws eks update-kubeconfig --name veeEKS

# Create Kubernetes namespace and switch to it
kubectl create namespace $NAMESPACE || true
kubectl config set-context $(kubectl config current-context) --namespace=$NAMESPACE

# Add Bitnami Helm charts repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install MySQL
helm upgrade -i mysql bitnami/mysql --version 9.2.0 -f helm/mysql.yaml \
  --set-file="initdbScripts.db_init\.sql"=scripts/db_init.sql

# Restore MySQL dump for Wordpress using temporary MySQL pod
kubectl apply -f scripts/mysql-init-pod.yaml
kubectl wait --for=condition=Ready pod/mysql-init
kubectl wait --for=condition=Ready pod/mysql-0 --timeout=10m
kubectl cp scripts/wp_init.sql mysql-init:/tmp/
kubectl exec mysql-init -- sh -c "mysql -uroot -pmysqlrootpass -hmysql < /tmp/wp_init.sql"
kubectl delete -f scripts/mysql-init-pod.yaml

# Install Redis
helm upgrade -i redis bitnami/redis --version 17.0.1 -f helm/redis.yaml

# Install Laravel app
helm upgrade -i lrvl helm/laravel -f helm/laravel/values.yaml \
  --set nginx.ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=laravel.$NAMESPACE.$BASE_DOMAIN \
  --set nginx.ingress.hosts[0].host=laravel.$NAMESPACE.$BASE_DOMAIN \
  --set nginx.ingress.hosts[0].paths[0].path="/" \
  --set nginx.ingress.hosts[0].paths[0].pathType=Prefix \
  --set image.tag=$IMAGE_TAG

# Install Wordpress app
helm upgrade -i wordpress bitnami/wordpress --version 15.0.12 -f helm/wordpress.yaml \
  --set ingress.hostname=wp.$NAMESPACE.$BASE_DOMAIN \
  --set ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=wp.$NAMESPACE.$BASE_DOMAIN \
  --set image.tag=$IMAGE_TAG

# Wait for WP installation and install graphql plugin
kubectl wait --for=condition=Available=True --timeout=10m deployment/wordpress
WP_POD=$(kubectl get pod -l app.kubernetes.io/name=wordpress -o custom-columns=:metadata.name --no-headers)
kubectl exec $WP_POD -- wp plugin install wp-graphql --activate

# Install React app
helm upgrade -i react helm/react -f helm/react/values.yaml \
  --set ingress.annotations."external-dns\.alpha\.kubernetes\.io\/hostname"=$NAMESPACE.$BASE_DOMAIN \
  --set ingress.hosts[0].host=$NAMESPACE.$BASE_DOMAIN \
  --set ingress.hosts[0].paths[0].path="/" \
  --set ingress.hosts[0].paths[0].pathType=Prefix \
  --set image.tag=$IMAGE_TAG
