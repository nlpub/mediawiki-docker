FROM hhvm/hhvm

EXPOSE 9000

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" mediawiki-math-texvc librsvg2-bin curl && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN curl -sL https://getcomposer.org/installer | php -dhhvm.jit=false && mv composer.phar /bin/composer

RUN touch /var/log/cron.log

CMD /usr/bin/hhvm -m server -vServer.Type=fastcgi -vServer.Port=9000
