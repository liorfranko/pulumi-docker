# shellcheck disable=SC2128
CODE_LOCATION=$(echo "$BASH_SOURCE" | awk -F 'pulumi-docker' '{print $1 }')
AWS_ACCESS_KEY_ID=$(cat /Users/$USER/.aws/private-aws-access-key-new)
AWS_SECRET_ACCESS_KEY=$(cat /Users/$USER/.aws/private-aws-secret-new)
PULUMI_ACCESS_TOKEN=$(cat /Users/$USER/.pulumi-creds)

docker build \
--build-arg PULUMI_ACCESS_TOKEN="$PULUMI_ACCESS_TOKEN" \
--build-arg AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
--build-arg AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
-t pulumi_docker "$CODE_LOCATION/pulumi-docker/"

docker run -it -v "$CODE_LOCATION/pulumi-docker/src:/usr/local/src/" -v /usr/local/bin/docker:/usr/local/bin/docker -v /var/run:/var/run pulumi_docker