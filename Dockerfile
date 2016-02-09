FROM node
MAINTAINER andrew@ei-grad.ru
EXPOSE 8891

RUN (echo "deb http://ppa.launchpad.net/no1wantdthisname/ppa/ubuntu trusty main"; \
     echo "deb-src http://ppa.launchpad.net/no1wantdthisname/ppa/ubuntu trusty main") \
    >> /etc/apt/sources.list.d/infinality.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E985B27B && \
    sed -i 's/main$/main non-free contrib/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install xvfb \
                       libxcomposite1 libasound2 libdbus-glib-1-2 libgtk2.0-0 \
                       fontconfig-infinality \
                       ttf-dejavu \
                       ttf-mscorefonts-installer && \
    /etc/fonts/infinality/infctl.sh setstyle osx && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# see https://github.com/graingert/slimerjs/issues/34
RUN npm install -g 'slimerjs@0.9.6-2' phantomjs-prebuilt manet && \
    rm -rf /root/.npm

ADD default.yaml /usr/local/lib/node_modules/manet/src/config/default.yaml

RUN mkdir /var/cache/manet /var/cache/phantomjs
VOLUME /var/cache/manet
VOLUME /var/cache/phantomjs
VOLUME /var/cache/slimerjs

CMD ["manet"]
