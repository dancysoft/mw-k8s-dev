# FIXME: use a name different than train-dev
IMAGE=registry.hq.dancysoft.com/local/train-dev:latest

image:
	docker build -t $(IMAGE) .

run: image
	docker run \
		-d \
		--init \
		--rm \
		--name mw \
		-v ~/src/wmf/hacking/staging:/srv/mediawiki \
		-p 8081:80 \
		--link etcd:etcd.hq.dancysoft.com \
		--link mwdb:db \
		$(IMAGE)

stop:
	docker rm -f mw

logs:
	docker logs -f mw
