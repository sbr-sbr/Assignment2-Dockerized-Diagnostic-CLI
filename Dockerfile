FROM alpine:latest AS deps

RUN apk add --no-cache bash curl jq util-linux procps-ng

WORKDIR /app

COPY app/diagnostic.sh /usr/local/bin/diagnostic

RUN chmod +x /usr/local/bin/diagnostic

ENTRYPOINT ["/usr/local/bin/diagnostic"]
