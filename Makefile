up:
	podman-compose up --pull -d

down:
	-systemctl --user stop pod-nlpub
	podman-compose down

systemd:
	mkdir -p "$(HOME)/.config/systemd/user"
	for service in $$(podman generate systemd nlpub -f -n); do mv -fv "$$service" "$(HOME)/.config/systemd/user"; done
	systemctl --user daemon-reload
	systemctl --user enable --now pod-nlpub
