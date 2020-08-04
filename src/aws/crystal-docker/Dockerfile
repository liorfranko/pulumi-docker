FROM crystallang/crystal
# TODO remove LISTEN_ADDR and LISTEN_PORT, and move them to index.ts
ARG LISTEN_ADDR
ARG LISTEN_PORT
ENV LISTEN_ADDR=$LISTEN_ADDR
ENV LISTEN_PORT=$LISTEN_PORT
COPY ./src /usr/local/src/
CMD crystal /usr/local/src/home.cr