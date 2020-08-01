# shellcheck disable=SC2128
CODE_LOCATION=$(echo "$BASH_SOURCE" | awk -F 'pulumi-docker' '{print $1 }')
GOOGLE_CREDENTIALS=$(cat /Users/$USER/.shared-network_terraform_user_credentials.json)
docker build --build-arg GOOGLE_CREDENTIALS="$GOOGLE_CREDENTIALS" -t pulumi_docker "$CODE_LOCATION/pulumi-docker/"
docker run -it -p 8082:8082 -v "$CODE_LOCATION/pulumi-docker/src:/usr/local/src/" pulumi_docker