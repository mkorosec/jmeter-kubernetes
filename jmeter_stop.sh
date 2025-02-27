#!/usr/bin/env bash
#Script writtent to stop a running jmeter master test
#Kindly ensure you have the necessary kubeconfig

working_dir=`pwd`

#Get namesapce variable
tenant=`awk '{print $NF}' $working_dir/tenant_export`

master_pod=`kubectl get po -n jmeter -o jsonpath="{.items[0].metadata.name}" --selector='jmeter_mode=master'`

kubectl -n $tenant exec -ti $master_pod bash -- /jmeter/apache-jmeter-5.5/bin/stoptest.sh
