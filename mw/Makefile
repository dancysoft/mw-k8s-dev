IMAGE=registry.hq.dancysoft.com/local/mw:39

image:
	docker build -t $(IMAGE) .

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
