# Description
Docker container created to facilitate the terraform env creation/documentation.

# Usage
Clone this repo:
`git clone https://github.com/ibenrodriguez/j19mct.git`

Go to the Dockerfile directory:
`cd ./j19mct/docker`

Copy GCP and AWS secrets locally:
~~~~ 
cp /path/to/gcp/secret.json ./gcp-secret.json
cp /path/to/aws/secret ./aws-secret  
~~~~
Build the container:
~~~
# GIT_SECRET: Used to clone the repo inside the container (format: ${USER_NAME}:${GIT_PAT})
docker build \
    --build-arg "GIT_SECRET=<git_secret>" \
    --build-arg "GOOGLE_APPLICATION_CREDENTIALS=./gce-secret.json" \
    --build-arg "AWS_SHARED_CREDENTIALS_FILE=./aws-secret" \
    --build-arg "ARM_CLIENT_ID=<arm_client_id>" \
    --build-arg "ARM_CLIENT_SECRET=<arm_client_secret>" \
    --build-arg "ARM_SUBSCRIPTION_ID=<arm_subscription_id>" \
    --build-arg "ARM_TENANT_ID=<arm_tennant_id>" \
    -t multicloud-env .
~~~
Run the container:
~~~
docker run \
    -v "/local/logs/dir:/mct-logs" \
    -e "GLOBAL_LOG_DIR=/mct-logs" \
    -it multicloud-env bash
~~~
