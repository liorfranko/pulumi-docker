FROM gcr.io/prodarch-lab/ansible-docker:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl python3.8 dirmngr apt-transport-https lsb-release ca-certificates vim
RUN cp /usr/bin/python3.8 /usr/bin/python
RUN curl -fsSL https://get.pulumi.com | sh
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install nodejs
RUN npm install -g typescript
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.pulumi/bin"
ARG GOOGLE_CREDENTIALS
ARG PULUMI_ACCESS_TOKEN
ENV GOOGLE_CREDENTIALS $GOOGLE_CREDENTIALS
ENV PULUMI_ACCESS_TOKEN $PULUMI_ACCESS_TOKEN
WORKDIR /usr/local/src/quickstart
# CMD tsc index.ts -w
# CMD node index.js