#!/bin/bash

WORK_DIR=$(dirname $(dirname $(readlink -f "$0")))
TF_WORK_DIR="$WORK_DIR/terraform"

output_file="./output.log"

function get_value {
    key=$1
    
    value=$(cat $output_file | grep $key | awk '{split($0,a," = "); print a[2]}')
    if [[ "$value" == "" ]];then
        echo "Error: Cannot find value for $key"
        exit 1
    else
        echo $value
    fi
}
function get_ips {
    
    export GCP_K8SA_NAME="$(terraform output gcp-k8s1a-name)"
    export GCP_K8SB_NAME="$(terraform output gcp-k8s1b-name)"
    export GCP_K8SA_REGION="$(terraform show -json | jq -r '.values.root_module.resources | .[] | select(.address=="google_container_cluster.k8s1a") | .values.location')"
    export GCP_K8SB_REGION="$(terraform show -json | jq -r '.values.root_module.resources | .[] | select(.address=="google_container_cluster.k8s1b") | .values.location')"
    
    
    gcloud container clusters get-credentials $GCP_K8SA_NAME --region $GCP_K8SA_REGION
    node_port="$(kubectl get services frontend-external-private -o jsonpath='{.spec.ports[0].nodePort}')"
    worker="$(kubectl get pods --selector=app=frontend -o jsonpath='{.items[0].spec.nodeName}')"
    export K8SA_interal_address=$(kubectl get nodes $worker -o json | jq -r '.status.addresses | .[] | select(.type=="InternalIP") | .address')
    export K8SA_external_address=$(kubectl get service frontend-external -o json |jq -r '.status.loadBalancer.ingress[0].ip')
    
    
    gcloud container clusters get-credentials $GCP_K8SB_NAME  --region $GCP_K8SB_REGION
    node_port="$(kubectl get services frontend-external-private -o jsonpath='{.spec.ports[0].nodePort}')"
    worker="$(kubectl get pods --selector=app=frontend -o jsonpath='{.items[0].spec.nodeName}')"
    export K8SB_interal_address=$(kubectl get nodes $worker -o json | jq -r '.status.addresses | .[] | select(.type=="InternalIP") | .address')
    export K8SB_external_address=$(kubectl get service frontend-external -o json |jq -r '.status.loadBalancer.ingress[0].ip')
    
    export vm1a_name="$(get_value vm1a-name)"
    export vm1a_public_ip="$(get_value vm1a-public-ip)"
    export vm1a_private_ip="$(get_value vm1a-private-ip)"
    
    export vm1c_name="$(get_value vm1c-name)"
    export vm1c_public_ip="$(get_value vm1c-public-ip)"
    export vm1c_private_ip="$(get_value vm1c-private-ip)"
    
    export vm2a_name="$(get_value vm2a-name)"
    export vm2a_public_ip="$(get_value vm2a-public-ip)"
    export vm2a_private_ip="$(get_value vm2a-private-ip)"
    
    export vm3a_name="$(get_value vm3a-name)"
    export vm3a_public_ip="$(get_value vm3a-public-ip)"
    export vm3a_private_ip="$(get_value vm3a-private-ip)"
    
    export vm1b_name="$(get_value vm1b-name)"
    export vm1b_public_ip="$(get_value vm1b-public-ip)"
    export vm1b_private_ip="$(get_value vm1b-private-ip)"
    
    export vm1d_name="$(get_value vm1d-name)"
    export vm1d_public_ip="$(get_value vm1d-public-ip)"
    export vm1d_private_ip="$(get_value vm1d-private-ip)"
    
    export vm2b_name="$(get_value vm2b-name)"
    export vm2b_public_ip="$(get_value vm2b-public-ip)"
    export vm2b_private_ip="$(get_value vm2b-private-ip)"
    
    export vm3b_name="$(get_value vm3b-name)"
    export vm3b_public_ip="$(get_value vm3b-public-ip)"
    export vm3b_private_ip="$(get_value vm3b-private-ip)"
}

function check_connectivity {
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm1a_public_ip}"
    outputSSH=$($commandSSH 2> /dev/null)
    echo "***"
    echo "Test 1 - from Internet to VM1A public IP  ${vm1a_public_ip}"
    echo $outputSSH
    echo "***"
    
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm1c_private_ip}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 2 - from VM1A to VM1C private ${vm1c_private_ip}"
    echo $outputSSH
    echo "***"
    
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm2a_private_ip}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 3 - from VM1A to VM2A private ${vm1c_private_ip}"
    echo $outputSSH
    echo "***"
    
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm1b_public_ip}"
    outputSSH=$($commandSSH 2> /dev/null)
    echo "***"
    echo "Test 4 - from Internet to VM1B public IP  ${vm1a_public_ip}"
    echo $outputSSH
    echo "***"
    
    
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm1d_private_ip}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 5 - from VM1B to VM1D private ${vm1d_private_ip}"
    echo $outputSSH
    echo "***"
    
    
    commandSSH="nmap -A -Pn -oG - -p 22,80 ${vm2b_private_ip}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 6 - from VM1B to VM2B private ${vm1c_private_ip}"
    echo $outputSSH
    echo "***"
    
    
    
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SA_interal_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 7 - from VM1A to K8SA private ${K8SA_interal_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SA_interal_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm3a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 8 - from VM3A to K8SA private ${K8SA_interal_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SA_external_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 9 - from VM1A to K8SA public ${K8SA_external_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SA_external_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm3a_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 10 - from VM3A to K8SA public ${K8SA_external_address}"
    echo $outputSSH
    echo "***"
    
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SB_interal_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 11 - from VM1B to K8SB private ${K8SB_interal_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SB_interal_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm3b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 12 - from VM3B to K8SB private ${K8SB_interal_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SB_external_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm1b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 13 - from VM1B to K8SB public ${K8SB_external_address}"
    echo $outputSSH
    echo "***"
    
    commandSSH="nmap -A -Pn -oG - -p 80 ${K8SB_external_address}"
    outputSSH=$(timeout 16 ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${vm3b_public_ip} $commandSSH 2> /dev/null)
    echo "***"
    echo "Test 13 - from VM3B to K8SB public ${K8SB_external_address}"
    echo $outputSSH
    echo "***"
}

function main {
    pushd $TF_WORK_DIR
    terraform output > $output_file
    get_ips
    popd
    while true
    do
        check_connectivity | tee "connectivity_test.log"
    done
}

main
