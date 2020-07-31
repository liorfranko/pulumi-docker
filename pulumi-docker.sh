# shellcheck disable=SC2128
CODE_LOCATION=$(echo "$BASH_SOURCE" | awk -F 'pulumi-docker' '{print $1 }')
docker build -t pulumi_docker "$CODE_LOCATION/pulumi-docker/"
docker run -it pulumi_docker






