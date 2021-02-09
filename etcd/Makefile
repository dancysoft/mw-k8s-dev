IMAGE:=$(IMAGE_PREFIX)/etcd:4

image:
	docker build -t $(IMAGE) .

run: image
	docker run \
		--name etcd \
		--rm \
		--init \
		-d \
		-v /home/dancy/admin/ssl/live/hq.dancysoft.com/fullchain.pem:/tls/tls.crt \
		-v /home/dancy/admin/ssl/live/hq.dancysoft.com/privkey.pem:/tls/tls.key \
		-h etcd.hq.dancysoft.com \
		$(IMAGE)

stop:
	docker rm -f etcd

logs:
	docker logs -f etcd

push: image
	docker push $(IMAGE)

cert: ssl/server.crt

# make-cert requires access to a k8s cluster
ssl/server.crt: make-cert
	./make-cert

clean-cert:
	rm -f ssl/*
