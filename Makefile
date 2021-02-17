include Makefile.defs

SUBDIRS=etcd db multiversion-image mw 

images: check-minikube-running
	bash -c 'set -e && eval $$(minikube docker-env) && echo DOCKER_HOST is $$DOCKER_HOST && for dir in $(SUBDIRS); do $(MAKE) -C $$dir push; done'

check-minikube-running:
	@if ! minikube status >/dev/null; then echo Please start minikube first; false; fi

# Could include 'images' target but not doing that for now
install: helm
	./helm init
	$(MAKE) -C etcd cert
	$(MAKE) -C mw/helm/mw install

uninstall: helm
	$(MAKE) -C mw/helm/mw uninstall

upgrade: helm
	$(MAKE) -C mw/helm/mw upgrade

# This is the version of the helm tiller that minikube installs.
helm-version=v2.16.12
helm:
	curl -LO https://get.helm.sh/helm-$(helm-version)-linux-amd64.tar.gz
	tar xf helm-$(helm-version)-linux-amd64.tar.gz
	mv linux-amd64/helm .
	rm -r linux-amd64 helm-$(helm-version)-linux-amd64.tar.gz

install-minikube:
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
	sudo dpkg -i minikube_latest_amd64.deb
	rm minikube_latest_amd64.deb

start-minikube:
	minikube start --kubernetes-version=v1.20.2 --cpus $$(getconf _NPROCESSORS_ONLN) && for addon in helm-tiller metallb metrics-server registry; do minikube addons enable $$addon; done

install-kubectl:
	curl -LO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin

install-k9s:
	curl -LO https://github.com/derailed/k9s/releases/download/v0.24.2/k9s_Linux_x86_64.tar.gz
	tar xf k9s_Linux_x86_64.tar.gz k9s
	sudo mv k9s /usr/bin/
	rm k9s_Linux_x86_64.tar.gz
