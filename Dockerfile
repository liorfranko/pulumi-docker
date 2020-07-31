FROM gcr.io/prodarch-lab/ansible-docker:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl python3.8 npm
RUN cp /usr/bin/python3.8 /usr/bin/python
RUN curl -fsSL https://get.pulumi.com | sh
RUN npm install -g typescript
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.pulumi/bin"