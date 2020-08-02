# shellcheck disable=SC2128
CODE_LOCATION=$(echo "$BASH_SOURCE" | awk -F 'pulumi-docker' '{print $1 }')
GOOGLE_CREDENTIALS=$(cat /Users/$USER/.shared-network_terraform_user_credentials.json)
AWS_ACCESS_KEY_ID=$(cat /Users/$USER/.aws/private-aws-access-key)
AWS_SECRET_ACCESS_KEY=$(cat /Users/$USER/.aws/private-aws-secret)
# GOOGLE_CREDENTIALS=$(cat /Users/$USER/.gcp-credentials.json)
PULUMI_ACCESS_TOKEN=$(cat /Users/$USER/.pulumi-creds)
docker build --build-arg GOOGLE_CREDENTIALS="$GOOGLE_CREDENTIALS" \
--build-arg PULUMI_ACCESS_TOKEN="$PULUMI_ACCESS_TOKEN" \
--build-arg AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
--build-arg AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
-t pulumi_docker "$CODE_LOCATION/pulumi-docker/"
docker run -it -p 8082:8082 -v "$CODE_LOCATION/pulumi-docker/src:/usr/local/src/" pulumi_docker