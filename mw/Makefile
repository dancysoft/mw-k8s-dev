include ../Makefile.defs

IMAGE:=$(IMAGE_PREFIX)/mw:44

image:
	sed -e s\|MMW_IMAGE\|$(MMW_IMAGE)\| Dockerfile.template > Dockerfile.generated
	docker build -f Dockerfile.generated -t $(IMAGE) .

push: image
	docker push $(IMAGE)

run: image
	docker run \
		-d \
		--rm \
		--name mw \
		-p 8081:80 \
		--link etcd:etcd.hq.dancysoft.com \
		--link mwdb:db \
		$(IMAGE)

stop:
	docker rm -f mw

logs:
	docker logs -f mw

helm-install:
	$(MAKE) -C helm/mw install

helm-uninstall:
	$(MAKE) -C helm/mw uninstall

helm-upgrade:
	$(MAKE) -C helm/mw upgrade
