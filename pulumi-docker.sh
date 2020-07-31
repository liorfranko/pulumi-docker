# shellcheck disable=SC2128
CODE_LOCATION=$(echo "$BASH_SOURCE" | awk -F 'pulumi-docker' '{print $1 }')
docker build -t pulumi_docker "$CODE_LOCATION/pulumi-docker/"
echo $CODE_LOCATION
docker run -it -v "$CODE_LOCATION/pulumi-docker/start.ts:/usr/local/src/" pulumi_docker