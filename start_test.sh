#!/usr/bin/env bash
#Script created to launch Jmeter tests directly from the current terminal without accessing the jmeter master pod.
#It requires that you supply the path to the jmx file
#After execution, test script jmx file may be deleted from the pod itself but not locally.

working_dir="`pwd`"

#Get namesapce variable
tenant=`awk '{print $NF}' "$working_dir/tenant_export"`

jmx="$1"
params="${@:2}"
[ -n "$jmx" ] || read -p 'Enter path to the jmx file ' jmx
[ -n "$params" ] || read -p 'Enter additional CLI parameters (like -Jparam1=value) ' params

if [ ! -f "$jmx" ];
then
    echo "Test script file was not found in PATH"
    echo "Kindly check and input the correct file path"
    exit
fi

test_name="$(basename "$jmx")"
echo "Using test file: $test_name"
echo "Additional parameters for jmeter: $params"

#Get Master pod details
master_pod=`kubectl get po -n $tenant -o jsonpath="{.items[0].metadata.name}" --selector='jmeter_mode=master'`

kubectl cp "$jmx" -n "$tenant" "$master_pod:/$test_name"

## Echo Starting Jmeter load test
echo ""
echo "==="
echo "If you want to interrupt the test, use 'bash jmeter_stop.sh' to do a clean stop"
echo "==="
echo ""

kubectl exec -ti -n $tenant $master_pod -- /bin/bash /load_test "$test_name" $params
