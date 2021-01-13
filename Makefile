SUBDIRS=etcd db mw nginx

run:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir run; done

stop:
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir stop; done
