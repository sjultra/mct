#!/bin/bash

# Required global variables
# GCP_PROJECT_ID
# GCP_KEY_ID
# GCP_PRIVATE_KEY
# GCP_ACCOUNT_MAIL
# GCP_CLIENT_ID
# GOOGLE_CLOUD_KEYFILE_JSON
# ARM_CLIENT_ID
# ARM_CLIENT_SECRET
# ARM_TENANT_ID
# ARM_SUBSCRIPTION_ID
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEAFAULT_REGION

set -xe

function login_azure {
    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
    az account set --subscription $ARM_SUBSCRIPTION_ID
}

function login_google {
    mkdir -p $(dirname $GOOGLE_CLOUD_KEYFILE_JSON)

    cat <<EOT >> $GOOGLE_CLOUD_KEYFILE_JSON
{
"type": "service_account",
"project_id": "$GCP_PROJECT_ID",
"private_key_id": "$GCP_KEY_ID",
"private_key": "$GCP_PRIVATE_KEY",
"client_email": "$GCP_ACCOUNT_MAIL",
"client_id": "$GCP_CLIENT_ID",
"auth_uri": "https://accounts.google.com/o/oauth2/auth",
"token_uri": "https://accounts.google.com/o/oauth2/token",
"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/$GCP_ACCOUNT_MAIL"
}
EOT

    gcloud auth activate-service-account --key-file=$GOOGLE_CLOUD_KEYFILE_JSON
    gcloud config set project $GCP_PROJECT_ID
}

function main {
    # install utils
    apt update
    apt install -y wget unzip curl gnupg1 apt-transport-https ca-certificates git lsb-release gnupg jq nano python-pip
    pip install crudini
    # terraform setup
    wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip
    unzip terraform_0.12.6_linux_amd64.zip
    mv terraform /usr/local/bin
    # kubectl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
    # gcloud
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update
    apt-get install -y google-cloud-sdk
    # aws
    curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator
    chmod +x ./aws-iam-authenticator
    mv aws-iam-authenticator /usr/local/bin
    DEBIAN_FRONTEND=noninteractive apt-get install -y awscli
    # Azure CLI
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
    apt update
    apt install -y azure-cli
    ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

    login_azure
    login_google
}

main $@
