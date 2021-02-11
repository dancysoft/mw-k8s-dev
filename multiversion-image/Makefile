include ../Makefile.defs

image:
	time docker build -t $(MMW_IMAGE) .

push: image
	time docker push $(MMW_IMAGE)
