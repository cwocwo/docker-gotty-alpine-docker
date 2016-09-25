FROM alpine:edge
MAINTAINER Tim Haak <tim@haak.co>

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm"

RUN apk -U upgrade && \
    apk --update add \
      bash \
      curl \
      docker  \
      go git \
      musl-dev \
      python py2-pip \
      wget \
      zsh \
      && \
    GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
    mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
    apk del go git musl-dev && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    sed -E -i -e 's/plugins\=.+/plugins=(colored-man-pages colorize cp docker docker-compose)/' /root/.zshrc && \
    pip install docker-compose && \
    rm -rf /tmp/gotty /var/cache/apk/* /tmp/src

CMD /usr/local/bin/gotty --port 8080 --permit-write --credential user:pass /bin/bash
