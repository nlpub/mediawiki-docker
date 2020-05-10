build:
	podman build --tag=nlpub .

IMAGE ?= docker.io/nlpub/mediawiki

deploy:
	podman pod create --name=nlpub --publish=127.0.0.1:8888:80
	podman container create --pod=nlpub --name=nlpub_web --restart=always -v './LocalSettings.php:/var/www/html/LocalSettings.php:ro' -v './html/favicon.ico:/var/www/html/favicon.ico:ro' -v './html/robots.txt:/var/www/html/robots.txt:ro' -v './html/cache:/var/www/html/cache' -v './html/images:/var/www/html/images' -v './html/sitemap:/var/www/html/sitemap:ro' $(IMAGE)
	podman container create --pod=nlpub --name=nlpub_cron --restart=always -v './LocalSettings.php:/var/www/html/LocalSettings.php:ro' -v './html/favicon.ico:/var/www/html/favicon.ico:ro' -v './html/robots.txt:/var/www/html/robots.txt:ro' -v './html/cache:/var/www/html/cache' -v './html/images:/var/www/html/images' -v './html/sitemap:/var/www/html/sitemap' $(IMAGE) /usr/sbin/cron -f

purge:
	podman stop nlpub_web nlpub_cron; podman rm nlpub_web nlpub_cron; podman pod rm nlpub

systemd:
	mkdir -p "$(HOME)/.config/systemd/user"
	for service in $$(podman generate systemd nlpub -f -n); do sed -re 's/^(WantedBy=).*$$/\1default.target/g' -i "$$service" && mv -fv "$$service" "$(HOME)/.config/systemd/user"; done
	systemctl --user daemon-reload
	systemctl --user enable --now pod-nlpub
