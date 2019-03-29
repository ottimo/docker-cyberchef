FROM node:alpine
MAINTAINER Martijn Pepping <martijn.pepping@automiq.nl>

RUN addgroup cyberchef -S && \
    adduser cyberchef -G cyberchef -S && \
    apk update && \
    apk add git nodejs python2 make g++ && \
    rm -rf /var/cache/apk/* && \
    npm install -g grunt-cli && \
    npm install -g http-server && \
    npm install -g increase-memory-limit

RUN cd /srv && \
    git clone -b master https://github.com/gchq/CyberChef.git && \
    cd CyberChef && \
    rm -rf .git && \
    apk del git && \
    increase-memory-limit && \
    npm install --unsafe-perm && \
    chown -R cyberchef:cyberchef /srv/CyberChef

USER cyberchef

RUN cd  /srv/CyberChef && \
    grunt prod

# npm run postinstall && \

EXPOSE 8000

WORKDIR /srv/CyberChef/build/prod
ENTRYPOINT ["http-server", "-p", "8000"]
