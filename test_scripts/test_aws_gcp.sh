#!/bin/bash

if [[ -e "$TF_WORK_DIR" ]];then
    pushd $TF_WORK_DIR
else
    echo "Error: Cannot find terraform directory"
    exit 1
fi

function run_test_aws_gcp {
    loadgen_config="$WORK_DIR/deployment_configs/eks/loadgenerator-eks1.yaml"
    
    change_kubectl_context gcp $GCP_K8SA_NAME $GCP_K8SA_REGION
    
    node_port="$(kubectl get services frontend-external-private -o jsonpath='{.spec.ports[0].nodePort}')"
    worker="$(kubectl get pods --selector=app=frontend -o jsonpath='{.items[0].spec.nodeName}')"
    interal_address=$(kubectl get nodes $worker -o json | jq -r '.status.addresses | .[] | select(.type=="InternalIP") | .address')
    
    change_kubectl_context aws $AWS_K8SA_NAME $AWS_K8S_REGION
    git checkout HEAD -- $loadgen_config
    sed -i "s/%FRONTEND_IP%/${interal_address}:${node_port}/g" $loadgen_config
    kubectl apply -f "$loadgen_config"
    
    if [[ "$LOAD_GEN_DURATION" != "0" ]];then
        sleep $LOAD_GEN_DURATION
        kubectl delete pods loadgen
    fi
}

run_test_aws_gcp