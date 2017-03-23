FROM alpine:edge
MAINTAINER Tim Haak <tim@haak.co>

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TERM="xterm"
#jq fping haveged htop iftop iotop lsof man mc mtr mysql-client nano netcat nmap postgresql-client rsync screen tmux ssl-cert tar telnet tree vim xz-utils
RUN apk -U upgrade && \
    apk --update add \
      bash \
      curl \
      docker  \
      fping \
      go git \
      htop \
      iftop iotop \
      jq \
      man mc mtr musl-dev mysql-client \
      nano nmap \
      postgresql-client python py2-pip \
      rsync \
      screen \
      wget \
      tar tmux tree \
      vim \
      xz \
      zsh \
      && \
    GOPATH=/tmp/gotty go get github.com/yudai/gotty && \
    mv /tmp/gotty/bin/gotty /usr/local/bin/ && \
    apk del go git musl-dev && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    sed -E -i \
      -e 's/plugins\=.+/plugins=(colored-man-pages colorize cp docker docker-compose)/' \
      -e 's/ZSH_THEME\=.+/ZSH_THEME="timhaak"/' \
      /root/.zshrc && \
    echo 'set-option -g default-shell /bin/zsh' >> /root/.tmux.conf && \
    pip install docker-compose && \
    curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine && \
    rm -rf /tmp/gotty /var/cache/apk/* /tmp/src

ADD ./files/timhaak.zsh-theme /root/.oh-my-zsh/themes/timhaak.zsh-theme
ADD ./files/.aliases /root/.aliases

RUN echo "source /root/.aliases" >> /root/.zshrc

CMD /usr/local/bin/gotty --port 8080 --permit-write --credential user:pass /bin/zsh
