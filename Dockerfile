FROM ubuntu
RUN apt-get update && apt-get install -y curl python3.8
RUN cp /usr/bin/python3.8 /usr/bin/python
RUN curl -fsSL https://get.pulumi.com | sh
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.pulumi/bin"