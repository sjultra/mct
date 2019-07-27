#!/bin/bash

if [[ -e "$TF_WORK_DIR" ]];then
    pushd $TF_WORK_DIR
else
    echo "Error: Cannot find terraform directory"
    exit 1
fi

function run_test_gcp_gcp {
    loadgen_config="$WORK_DIR/loadgen/loadgen_gke1_to_gke1.yaml"
    
    change_kubectl_context gcp $GCP_K8SA_NAME $GCP_K8SA_REGION
    
    frontend_ip=$(kubectl get pod $(kubectl get pods | awk '/frontend/ {print $1;exit}') --template={{.status.podIP}})
    sed -i "s/%FRONTEND_IP%/$frontend_ip/g" $loadgen_config_a
    
    kubectl apply -f "$loadgen_config_a"
    
    
    change_kubectl_context gcp $GCP_K8SB_NAME $GCP_K8SB_REGION
    
    frontend_ip=$(kubectl get pod $(kubectl get pods | awk '/frontend/ {print $1;exit}') --template={{.status.podIP}})
    sed -i "s/%FRONTEND_IP%/$frontend_ip/g" $loadgen_config_b
    
    kubectl apply -f "$loadgen_config_b"
    
    echo "Info: Waiting $LOAD_GEN_DURATION seccond to run the test"
    sleep $LOAD_GEN_DURATION
    
    kubectl logs loadgen 2>&1 | tee "$LOG_DIRECTORY/loadgen_b_results.log"
    kubectl delete pods --all
    
    change_kubectl_context gcp $GCP_K8SA_NAME $GCP_K8SA_REGION
    kubectl logs loadgen 2>&1 | tee "$LOG_DIRECTORY/loadgen_a_results.log"
    kubectl delete pods --all
}

run_test_gcp_gcp