FROM golang:alpine AS build-env

ARG GITHUB_TOKEN
ARG TARGETPLATFORM
RUN echo "Building for $TARGETPLATFORM"

ENV TAGS "bindata timetzdata sqlite sqlite_unlock_notify"

RUN apk --no-cache add \
    build-base \
    bash \
    git \
    nodejs \
    npm \
    curl \
    jq

WORKDIR ${GOPATH}/src/code.gitea.io/gitea

# get Gitea source code
COPY download-gitea.sh /usr/bin/download-gitea.sh
RUN /usr/bin/download-gitea.sh "$GITHUB_TOKEN" "$TARGETPLATFORM" && \
    rm /usr/bin/download-gitea.sh

# build environment-to-ini
RUN go build contrib/environment-to-ini/environment-to-ini.go


# based on https://github.com/go-gitea/gitea/blob/main/Dockerfile
FROM alpine

EXPOSE 22 3000

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    gnupg \
    && rm -rf /var/cache/apk/*

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:*" | chpasswd -e

ENV USER=git
ENV GITEA_CUSTOM=/data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/usr/bin/s6-svscan", "/etc/s6"]

COPY --from=build-env /go/src/code.gitea.io/gitea/docker/root /
COPY --from=build-env /go/src/code.gitea.io/gitea/gitea /app/gitea/gitea
COPY --from=build-env /go/src/code.gitea.io/gitea/environment-to-ini /usr/local/bin/environment-to-ini
RUN chmod 755 /usr/bin/entrypoint /app/gitea/gitea /usr/local/bin/gitea /usr/local/bin/environment-to-ini
RUN chmod 755 /etc/s6/gitea/* /etc/s6/openssh/* /etc/s6/.s6-svscan/*
