ARG ARCH
FROM golang:alpine as gobuild

ARG GOARCH
ARG GOARM

RUN apk update; \
    apk add git gcc build-base; \
    go get -v github.com/cloudflare/cloudflared/cmd/cloudflared

WORKDIR /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

FROM multiarch/alpine:${ARCH}-edge

LABEL maintainer Michael Davis
LABEL name "cloudflared"

ENV DNS1 https://9.9.9.9/dns-query
ENV DNS2 https://1.1.1.1/.well-known/dns-query

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main' > /etc/apk/repositories ; \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories; \
    adduser -S cloudflared; \
    apk add --no-cache ca-certificates bind-tools; \
    rm -rf /var/cache/apk/*;

COPY --from=gobuild /go/src/github.com/cloudflare/cloudflared/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nslookup -po=5054 cloudflare.com 127.0.0.1 || exit 1

USER cloudflared

CMD ["/bin/sh", "-c", "/usr/local/bin/cloudflared proxy-dns --address 0.0.0.0 --port 5054 --upstream ${DNS1} --upstream ${DNS2}"]
