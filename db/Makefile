IMAGE=registry.hq.dancysoft.com/local/mwdb

image:
	docker build -t $(IMAGE) .

run: image
	docker run -d --name mwdb --rm --init --privileged -p 3306:3306 $(IMAGE)

stop:
	docker rm -f mwdb

logs:
	docker logs -f mwdb
