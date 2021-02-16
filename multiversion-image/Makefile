include ../Makefile.defs
-include ../Makefile.defs.local

image:
	time docker build --build-arg GERRITMIRROR=$(GERRITMIRROR) -t $(MMW_IMAGE) .

push: image
	time docker push $(MMW_IMAGE)
