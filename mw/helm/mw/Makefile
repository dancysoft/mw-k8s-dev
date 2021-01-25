default:
	@echo No default target
	@false

push:
	helm push . wmf-local

install:
	helm dep update
	helm install -n mw .

uninstall:
	helm delete --purge mw

upgrade:
	helm upgrade mw .
