ECR Repo:- 
php-fpm -> https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/250144837585/vus/php-fpm?region=eu-west-1

php-cli -> https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/250144837585/vus/php-cli?region=eu-west-1

nginx -> https://eu-west-1.console.aws.amazon.com/ecr/repositories/private/250144837585/vus/nginx?region=eu-west-1

>There is no automation in place to build images and deploy to ECR and update the respective >docker compose file
>
>Following steps are performed manually
>1. Build docker image. (I am using EC2 instance with docker installed to build docker image -> https://eu-west-1.console.aws.amazon.com/ec2/v2/home?>region=eu-west-1#InstanceDetails:instanceId=i-0cd2c1e908b44044a)
>2. Tag with incremental version. Example if ECR repo already has version tag as v1.1 , then tag build image with v1.2
>3. Push to ECR repo
>4. Update docker compose file manually for each environment with updated version

<strong>Note:</strong> _Images build on windows environment could possibly cause container to throw error. Instead it is advised to use Linux/Ubuntu docker environment to build and push images_

Steps to build 
1. php-fpm 
    
    ```
    cd php-fpm

    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 250144837585.dkr.ecr.eu-west-1.amazonaws.com

    docker build -t vus/php-fpm .

    docker tag vus/php-fpm:latest 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/php-fpm:v1
    
    docker push 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/php-fpm:v1
    ```

2. php-cli
    ```
    cd php-cli

    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 250144837585.dkr.ecr.eu-west-1.amazonaws.com  

    docker build -t vus/php-cli .   

    docker tag vus/php-cli:latest 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/php-cli:v1

    docker push 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/php-cli:v1

    ```

3. nginx
    ```
    cd nginx
    
    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 250144837585.dkr.ecr.eu-west-1.amazonaws.com  

    docker build -t vus/nginx .

    docker tag vus/nginx:latest 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/nginx:v1

    docker push 250144837585.dkr.ecr.eu-west-1.amazonaws.com/vus/nginx:v1
    ```

| Image            	| Base Image               	| Created Date    	| Description                                                                        	|
|------------------	|--------------------------	|-----------------	|------------------------------------------------------------------------------------	|
| vus/php-fpm:v3.2 	| php:8.1.4-fpm-alpine3.15 	| 28th April 2022 	| Upgrade base image version from php:7.4-fpm-alpine3.12 to php:8.1.4-fpm-alpine3.15 	|
| vus/php-cli:v3.6 	| php:8.1.4-cli-alpine3.15 	| 28th April 2022 	| Upgrade base image version from php:7.4-cli-alpine3.12 to php:8.1.4-cli-alpine3.15 	|

Note:- Images build on windows environment could possibly cause container to throw error. Instead it is advised to use Linux/Ubuntu docker environment to build and push images

<strong>Note:</strong>

> We found that adding newrelic to vus php cli containers was causing high memory hence we are using php-cli image version v3.5 for cli containers which don't have newrelic 
> ~~but for scheduler we are using image version v3 which has newrelic in it~~.We are now using php-cli:v3.5 for cli and scheduler containers.

~~If you are building image for scheduler just use the same image under docker/php-cli but uncomment newrelic portion~~
