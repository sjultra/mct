#!/bin/bash
# Usage:
# bash ./check_deployment.sh <base_vm>


BASE_VM=$1

if [[ "$BASE_VM" == "" ]];then
    BASE_VM="vm1a"
fi

WORK_DIR=$(dirname $(dirname $(readlink -f "$0")))
TF_WORK_DIR="$WORK_DIR/terraform"

output_file="./output.log"
vpn_log_file="$WORK_DIR/vpn_check.log"
kube_log_file="$WORK_DIR/k8s_pods_check.log"

vms=("vm1a" "vm1b" "vm1c" "vm1d"
    "vm2a" "vm2b" "vm2c" "vm2d"
"vm3a" "vm3b" "vm3c" "vm3d")

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

function change_kubectl_context {
    platform="$1"
    cluster_name="$2"
    region="$3"
    
    if [[ "$platform" == "aws" ]];then
        aws eks --region $region update-kubeconfig --name $cluster_name
        elif [[ "$platform" == "gcp" ]];then
        gcloud container clusters get-credentials $cluster_name --region $region
        elif [[ "$platform" == "azure" ]];then
        az aks get-credentials --name $cluster_name --resource-group $region
    fi
}

function get_cluster_data {   
    export GCP_K8SA_NAME="$(terraform output gcp-k8s1a-name)"
    export GCP_K8SB_NAME="$(terraform output gcp-k8s1b-name)"
    export GCP_K8SA_REGION="$(terraform show -json | jq -r '.values.root_module.resources | .[] | select(.address=="google_container_cluster.k8s1a") | .values.location')"
    export GCP_K8SB_REGION="$(terraform show -json | jq -r '.values.root_module.resources | .[] | select(.address=="google_container_cluster.k8s1b") | .values.location')"
    
    
    export AWS_K8SA_NAME="$(terraform output aws-k8s2a-name)"
    export AWS_K8SB_NAME="$(terraform output aws-k8s2b-name)"
    export AWS_K8S_REGION="$(terraform show -json | jq -r '.values.root_module.resources | .[] | select(.address=="aws_eks_cluster.k8s2a") | .values.arn'|sed 's/arn:aws:eks://'|sed 's/:.*//')"
    
    export AZURE_K8SA_NAME="$(terraform output azure-k8s3a-name)"
    export AZURE_K8SB_NAME="$(terraform output azure-k8s3b-name)"
    export AZURE_RG_NAME="$(terraform output azure-resource-group-name)"
}

function get_cluster_logs {
    cluster_name="$1"
    cluster_region="$2"
    cloud="$3"
    
    change_kubectl_context $cloud $cluster_name $cluster_region
    echo ""
    echo "CLUSTER DATA FOR: $cluster_name"
    echo "Nodes:"
    kubectl get nodes -o wide
    echo "Pods:"
    kubectl get pods -o wide --all-namespaces
}

function check_clusters_data {
    get_cluster_data
    
    get_cluster_logs $GCP_K8SA_NAME $GCP_K8SA_REGION gcp
    get_cluster_logs $GCP_K8SB_NAME $GCP_K8SB_REGION gcp
    get_cluster_logs $AWS_K8SA_NAME $AWS_K8S_REGION aws
    get_cluster_logs $AWS_K8SB_NAME $AWS_K8S_REGION aws
    get_cluster_logs $AZURE_K8SA_NAME $AZURE_RG_NAME azure
    get_cluster_logs $AZURE_K8SB_NAME $AZURE_RG_NAME azure
}

function check_vpn_connection {
    base_name="$(get_value ${BASE_VM}-name)"
    base_public_ip="$(get_value ${BASE_VM}-public-ip)"
    base_private_ip="$(get_value ${BASE_VM}-private-ip)"
    
    vms=(${vms[@]/$BASE_VM})
    
    for vm_id in ${vms[@]}; do
        echo ""
        vm_name="$(get_value ${vm_id}-name)"
        vm_public_ip="$(get_value ${vm_id}-public-ip)"
        vm_private_ip="$(get_value ${vm_id}-private-ip)"
        
        echo "Testing connection from $base_name to $vm_name"
        
        commandSSH="ssh -o 'StrictHostKeyChecking no' -i ~/ssh_private_key auser@${vm_private_ip} hostname"
        echo $commandSSH
        outputSSH=$(ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${base_public_ip} $commandSSH 2> /dev/null)
        if [[ "$outputSSH" == "$vm_name" ]];then
            echo "PASS: Hostname on ${vm_name}(IP:${vm_private_ip}):$hostname matches $vm_name"
        else
            echo "FAIL: ${vm_name}(IP:${vm_private_ip})"
        fi
        
        commandCurl="curl http://$vm_private_ip:80 "
        echo $commandCurl
        outputCurl=$(ssh -i ~/.ssh/id_rsa -o 'StrictHostKeyChecking no' auser@${base_public_ip} $commandCurl 2> /dev/null)
        if [[ $(echo "$outputCurl"|grep "nginx") != "" ]];then
            echo "PASS: NGINX running on ${vm_name}(IP:${vm_private_ip} and can be accessed at http://${vm_public_ip}:80"
        else
            echo "FAIL: NGINX not running on ${vm_name}(IP:${vm_private_ip})"
        fi
        
    done
}


function main {
    pushd $TF_WORK_DIR
    
    terraform output > $output_file
    check_vpn_connection | tee "$vpn_log_file"
    check_clusters_data | tee "$kube_log_file"
    
    popd
}

main
