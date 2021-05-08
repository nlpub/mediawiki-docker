FROM mediawiki:stable

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" tini cron nodejs npm librsvg2-dev fonts-paratype && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN \
MEDIAWIKI_BRANCH="REL$(echo $MEDIAWIKI_MAJOR_VERSION | tr . _)" && \
for ext in Math Description2 OpenGraphMeta; do \
curl -fSLo "$ext.tar.gz" "https://github.com/wikimedia/mediawiki-extensions-$ext/archive/$MEDIAWIKI_BRANCH.tar.gz" && \
tar Czxf "extensions" "$ext.tar.gz" --transform="s/^mediawiki-extensions-$ext-$MEDIAWIKI_BRANCH/$ext/" && \
rm -fv "$ext.tar.gz"; done && \
curl -fSLo "mathoid.tar.gz" "https://github.com/wikimedia/mathoid/archive/master.tar.gz" && \
tar Czxf "extensions/Math/mathoid" "mathoid.tar.gz" --strip-components=1 && \
rm -fv "mathoid.tar.gz" && \
cd "extensions/Math/mathoid" && \
npm install && \
npm cache clean --force && \
echo '@daily /usr/local/bin/php /var/www/html/maintenance/generateSitemap.php -q --fspath "/var/www/html/sitemap" --server "https://nlpub.ru" --urlpath "sitemap" --identifier "nlpub" --skip-redirects' | crontab

# block senstive file access
COPY ./block-files.conf /etc/apache2/conf-enabled

ENTRYPOINT ["/usr/bin/tini", "--", "docker-php-entrypoint"]

CMD apache2-foreground
