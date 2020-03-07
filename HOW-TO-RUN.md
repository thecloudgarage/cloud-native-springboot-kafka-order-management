# How to Run

This is a step-by-step guide how to run the example:

## Installation

### Preparing a linux host

* Avail of a linux host running ubuntu 18.04. This will be used to run all scripts, deployments, etc...

* Clone this repo and navigate to sub-directory prep-work

* Here you will find a bash script helper.sh. This script installs various tools/utilities

```
sudo su
chmod +x helper.sh
./helper.sh
```
* Tools/Utilies installed
    * Docker
    * Docker Compose
    * AWS CLI 
    * PKS CLI
    * CF CLI
    * KOPS
    * Kubectl
    * OpenJDK 1.8 

* Create the AWS IAM user with admin privileges and obtain the required keys
* Common commands that will be generally used during the activity are stored in the same sub-directory (filename: commands.txt)
* Configure AWS CLI (aws configure) using the obtained keys

### Running Locally via Docker-Compose

* Before starting, login into the respective docker registry and alter the registry value in dockerpush.sh

```
cd microservices-kafka
./mvnw clean package -Dmaven.test.skip=true
cd ..
cd docker
docker-compose build
docker-compose up -d
```

* Kafka & Postgresql entries are made via environmental variables
* Kafka host is auto-injected via "SPRING_KAFKA_BOOTSTRAP_SERVERS' env variable
* Postgresql host is set via "postgresql" env variable (leveraged in application.properties)

### Deploying on k8s (Any cluster is OK, in this case we have used PKS)

* Using PKS CLI create your k8s cluster

```
pks login -a api.pks.thecloudgarage.com -u <username> -p <password> -k
pks create-cluster <cluster-name> --external-hostname <cluster-name>.pks.<domain-name>.com --plan medium --num-nodes 3
pks cluster <cluster-name>
```

* Once cluster is ready, either edit the /etc/hosts or create DNS records for your cluster's Master via the --external-hostname value
* Next start working with kubectl to deploy your applications
* The deploy-everthing.sh script will create all resources in the appropriate sequence
* Note the use of varying sleep timers to resolve any unment resource dependency in the sequence

>>>EDIT THE ENVIRONMENTAL VARIABLES


```
sudo su
pks get-credentials <cluster-name>
kubectl config use-context <cluster-name>
cd k8s
chmod +x deploy-everything.sh
./deploy-everything.sh
```

* Verify the resource creations. If any errors., have fun troubleshooting!

```
kubectl get pods -n kafka-cluster
kubectl get services -n kafka-cluster
kubectl get pvc
kubectl get pods 
kubectl get services
```

* Browse to any of the cluster's worker node's public-ec2-ip:31001 (nodePort value is set for apache web-proxy. You can change it)
* Verify the application workflows

### Observing kafka events

```
kubectl get pods -n kafka-cluster
kubectl exec -it <kafka-pod-value> /bin/bash -n kafka-cluster
kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic order --from-beginning
```

* Typical output: Example event structure
```
{"id":7,"customer":{"customerId":1,"name":"Wolff","firstname":"Eberhard","email":"eberhard.wolff@gmail.com"},"updated":1583563036580,"shippingAddress":{"street":"d1406, brigade gardenia, jardine block,","zip":"560078","city":"bangalore"},"billingAddress":{"street":"d1406, brigade gardenia, jardine block,","zip":"560078","city":"bangalore"},"orderLine":[{"count":10,"item":{"itemId":3,"name":"iPod","price":42.0}},{"count":20,"item":{"itemId":3,"name":"iPod","price":42.0}}],"numberOfLines":2}
```


### Deploying on Cloud Foundry

* Ensure that you are logged into your cloud-foundry platform, e.g. cf login -a api.system.<domain-name>.com --skip-ssl-validation
* The sub-directory pcf-pas has a manifest file that deploys all the microservices and a nginx web-proxy
* Appropriately change the settings in nginx.conf to match your cloud-foundry environment
* Also, change the environment variables in the manifest.yaml to the ec2-public-ip of the worker nodes (nodePort values set)
   
```
cd pcf-pas
cf push
```

## UN-WIND

```
cd pcf-pas
chmod +x delete-all-apps.sh
cd ..
cd docker
chmod +x destroy-everything.sh
pks delete-cluster <cluster-name>
```
