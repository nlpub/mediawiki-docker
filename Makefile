build:
	podman build --tag=nlpub .

deploy:
	podman pod create --name=nlpub --publish=127.0.0.1:8888:80
	podman container create --pod=nlpub --name=nlpub_web --restart=always -v './LocalSettings.php:/var/www/html/LocalSettings.php:ro' -v './html/favicon.ico:/var/www/html/favicon.ico:ro' -v './html/robots.txt:/var/www/html/robots.txt:ro' -v './html/cache:/var/www/html/cache' -v './html/images:/var/www/html/images' -v './html/sitemap:/var/www/html/sitemap:ro' localhost/nlpub
	podman container create --pod=nlpub --name=nlpub_cron --restart=always -v './LocalSettings.php:/var/www/html/LocalSettings.php:ro' -v './html/favicon.ico:/var/www/html/favicon.ico:ro' -v './html/robots.txt:/var/www/html/robots.txt:ro' -v './html/cache:/var/www/html/cache' -v './html/images:/var/www/html/images' -v './html/sitemap:/var/www/html/sitemap' localhost/nlpub /usr/sbin/cron -f
	podman pod restart nlpub

purge:
	podman stop nlpub_web nlpub_cron; podman rm nlpub_web nlpub_cron; podman pod rm nlpub
