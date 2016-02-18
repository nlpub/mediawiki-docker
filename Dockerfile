FROM brunoric/hhvm:deb-hhvm

RUN \
apt-get update && \
apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" mediawiki-math-texvc librsvg2-bin && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN wget -O- https://getcomposer.org/installer | php -dhhvm.jit=false && mv composer.phar /bin/composer

COPY supervisor-*.conf /etc/supervisor/conf.d/
COPY rc.local /etc/rc.local
