FROM crystallang/crystal
ARG LISTEN_ADDR
ARG LISTEN_PORT
ENV LISTEN_ADDR=$LISTEN_ADDR
ENV LISTEN_PORT=$LISTEN_PORT
COPY ./src /usr/local/src/
CMD crystal /usr/local/src/home.cr