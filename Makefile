include Makefile.defs

SUBDIRS=etcd db nginx mw multiversion-image

images:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir push; done

run:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir run; done

stop:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir stop; done

# Could include 'images' target but not doing that for now
install: helm
	$(MAKE) -C etcd cert
	$(MAKE) -C mw/helm/mw install

uninstall: helm
	$(MAKE) -C mw/helm/mw uninstall

# Acquire the helm binary
helm:
	curl -LO https://get.helm.sh/helm-v2.16.12-linux-amd64.tar.gz
	tar xf helm-v2.16.12-linux-amd64.tar.gz
	mv linux-amd64/helm .
	rm -r linux-amd64 helm-v2.16.12-linux-amd64.tar.gz
