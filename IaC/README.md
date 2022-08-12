First, you need to apply Terraform in [Terraform](Terraform) directory.

Then, you need to run `deploy.sh` script having Kubernetes namespace name as an argument.
```
./deploy.sh test-namespace
```

The script will create new namespace and install the following components in it using Helm:
- MySQL database
- Redis
- Laravel app (http://laravel.${NAMESPACE}.savvaco.net)
- Wordpress app (http://wp.${NAMESPACE}.savvaco.net)
- React app (http://${NAMESPACE}.savvaco.net)

In order to delete all created resources you can simply delete Kubernetes namespace:
```
kubectl delete ns test-namespace
```
