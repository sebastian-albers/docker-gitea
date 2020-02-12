FROM resin/armhf-alpine

ARG VERSION=1.11.0

EXPOSE 22 3000

ENV USER git
ENV GITEA_CUSTOM /data/gitea

# install packages
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
    tzdata \
    jq

# add user 'git' and group 'git'
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
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

# get Gitea Docker files
RUN curl -SL https://github.com/go-gitea/gitea/archive/v$VERSION.tar.gz | \
    tar xz gitea-$VERSION/docker --exclude=gitea-$VERSION/docker/Makefile --strip-components=3

# get Gitea
RUN mkdir -p /app/gitea && \
    curl -SLo /app/gitea/gitea https://github.com/go-gitea/gitea/releases/download/v$VERSION/gitea-$VERSION-linux-arm-6 && \
    chmod 0755 /app/gitea/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]

CMD ["/bin/s6-svscan", "/etc/s6"]
