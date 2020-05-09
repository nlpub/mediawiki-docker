FROM mediawiki:stable

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" tini cron nodejs npm librsvg2-dev && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

COPY crontab html/robots.txt html/favicon.ico /var/www/html/

RUN \
for ext in Math Description2 OpenGraphMeta; do \
curl -fSLo "$ext.tar.gz" "https://github.com/wikimedia/mediawiki-extensions-$ext/archive/$MEDIAWIKI_BRANCH.tar.gz" && \
tar Czxf "extensions" "$ext.tar.gz" --transform="s/^mediawiki-extensions-$ext-$MEDIAWIKI_BRANCH/$ext/" && \
rm -fv "$ext.tar.gz"; done && \
crontab < crontab && \
rm -fv crontab

RUN \
curl -fSLo "mathoid.tar.gz" "https://github.com/wikimedia/mathoid/archive/master.tar.gz" && \
tar Czxf "extensions/Math/mathoid" "mathoid.tar.gz" --strip-components=1 && \
rm -fv "mathoid.tar.gz" && \
cd "extensions/Math/mathoid" && \
npm install && \
npm cache clean --force

ENTRYPOINT ["/usr/bin/tini", "--", "docker-php-entrypoint"]

CMD apache2-foreground
