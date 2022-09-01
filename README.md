# Jmeter Cluster Support for Kubernetes and OpenShift

## Prerequisits

Kubernetes > 1.16

OpenShift version > 3.5

## TL;DR
Ensure your jmeter test is using a backend listener that is pointing to jmeter-influxdb

```bash
./dockerimages.sh
./jmeter_cluster_create.sh
./dashboard.sh
./start_test.sh
./jmeter_stop.sh
```

Please follow the guide "Load Testing Jmeter On Kubernetes" on our medium blog post:

https://goo.gl/mkoX9E

