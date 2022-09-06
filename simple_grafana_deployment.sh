#!/bin/bash

kubectl create namespace jmeter
kubectl create -n jmeter -f jmeter_influxdb_configmap.yaml
kubectl create -n jmeter -f jmeter_influxdb_deploy.yaml
kubectl create -n jmeter -f jmeter_influxdb_svc.yaml
kubectl create -n jmeter -f jmeter_grafana_deploy.yaml
kubectl create -n jmeter -f jmeter_grafana_svc.yaml
kubectl exec -ti -n jmeter $(kubectl get po -n jmeter -o jsonpath="{.items[0].metadata.name}" --selector='app=influxdb-jmeter') -- influx -execute 'CREATE DATABASE jmeter'
kubectl exec -ti -n jmeter $(kubectl get po -n jmeter -o jsonpath="{.items[0].metadata.name}" --selector='app=jmeter-grafana') -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"jmeterdb","type":"influxdb","url":"http://jmeter-influxdb:8086","access":"proxy","isDefault":true,"database":"jmeter","user":"admin","password":"admin"}'
kubectl port-forward -n jmeter $(kubectl get po -n jmeter -o jsonpath="{.items[0].metadata.name}" --selector='app=jmeter-grafana') 3000