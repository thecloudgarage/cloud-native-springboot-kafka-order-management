#!/bin/bash
export dockerregistry=thecloudgarage
sudo docker tag mskafka_apache $dockerregistry/k8s-springboot-kafka-order-management:mskafka_apache
sudo docker tag mskafka_invoicing $dockerregistry/k8s-springboot-kafka-order-management:mskafka_invoicing
sudo docker tag mskafka_shipping $dockerregistry/k8s-springboot-kafka-order-management:mskafka_shipping
sudo docker tag mskafka_order $dockerregistry/k8s-springboot-kafka-order-management:mskafka_order
sudo docker tag wurstmeister/kafka:2.12-2.3.0 $dockerregistry/k8s-springboot-kafka-order-management:kafka
sudo docker tag wurstmeister/zookeeper:3.4.6 $dockerregistry/k8s-springboot-kafka-order-management:zookeeper
sudo docker tag mskafka_postgres:latest $dockerregistry/k8s-springboot-kafka-order-management:postgres
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_apache
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_invoicing
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_shipping
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:mskafka_order
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:kafka
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:postgres
sudo docker push $dockerregistry/k8s-springboot-kafka-order-management:zookeeper
