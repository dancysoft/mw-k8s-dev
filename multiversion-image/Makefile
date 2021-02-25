include ../Makefile.defs
-include ../Makefile.defs.local

image:
ifeq (, $(shell which time))
$(error "time(1) not found. Please install it on your system.")
endif
	time docker build --build-arg GERRITMIRROR=$(GERRITMIRROR) -t $(MMW_IMAGE) .

push: image
ifeq (, $(shell which time))
$(error "time(1) not found. Please install it on your system.")
endif
	time docker push $(MMW_IMAGE)
