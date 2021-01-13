IMAGE=registry.hq.dancysoft.com/local/mwnginx:latest

image:
	docker build -t $(IMAGE) .

run: image
	docker run -d --init --rm --name nginx --link mw:mw -p 443:443 $(IMAGE)

stop:
	docker rm -f nginx

logs:
	docker logs -f nginx

# Using organization name that begins with 'AAA' so that it will show
# up at the top of the list of CAs in Chrome and Firefox for easy
# location and removal.
cert:
	openssl req -new -nodes -keyout key.pem -out csr.pem -subj "/O=AAA wikipedia testing/CN=en.wikipedia.org"
	openssl x509 -signkey key.pem -days 365 -req -in csr.pem  -out crt.pem
