FROM mediawiki:stable

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" build-essential dvipng ocaml-nox texlive-fonts-recommended texlive-lang-cyrillic texlive-lang-greek texlive-latex-recommended texlive-latex-extra librsvg2-bin librsvg2-dev python-pygments unzip cron gnupg && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN \
cd /usr/share && \
curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
apt-get install nodejs && \
npm install mathoid@0.7.1 && \
npm cache clean && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

COPY crontab html/robots.txt html/favicon.ico /var/www/html/

RUN \
for ext in Math Description2 OpenGraphMeta; do \
curl -fSLo "$ext.tar.gz" "https://github.com/wikimedia/mediawiki-extensions-$ext/archive/$MEDIAWIKI_BRANCH.tar.gz" && \
tar Cxf "extensions" "$ext.tar.gz" && \
mv -fv "extensions/mediawiki-extensions-$ext-$MEDIAWIKI_BRANCH" "extensions/$ext" && \
rm -fv "$ext.tar.gz"; done && \
a2enmod rewrite && \
crontab <crontab && \
rm -fv crontab
