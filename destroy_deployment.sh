


WORK_DIR=$(dirname $(readlink -f "$0"))
export TF_WORK_DIR="$WORK_DIR/terraform"
export LOG_DIRECTORY=$(cat $1 |grep LOG_DIRECTORY|sed 's/.*= //')
export LOG_DEPLOYMENT="${LOG_DIRECTORY}/ViewDeployments"


function main {
    pushd $TF_WORK_DIR
    INSTANCE_ID=$(terraform output instance_id)
    aws_region=$(terraform output aws_region)
    azure_region=$(terraform output azure_region)
    gcp_region=$(terraform output azure_region)
    terraform destroy -auto-approve -lock=false | tee "terraform_destroy.log"
    echo "${INSTANCE_ID} - ${aws_region} - ${azure_region} - ${gcp_region}" >> $LOG_DEPLOYMENT
    popd
}