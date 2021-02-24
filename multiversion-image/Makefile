include ../Makefile.defs
-include ../Makefile.defs.local

image:
	docker build --build-arg GERRITMIRROR=$(GERRITMIRROR) -t $(MMW_IMAGE) .

push: image
	docker push $(MMW_IMAGE)
