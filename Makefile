include Makefile.inc

NAME ?= osswarm
ARCH ?= x86_64

IMAGE_NAME = osswarm-$(ARCH)

image: check-ARCH check-CLOUD check-IMAGE_NAME
	$(MAKE) ARCH=$(ARCH) \
	        CLOUD=$(CLOUD) \
	        IMAGE_NAME=$(IMAGE_NAME) \
	        -C $@

clean:
	$(MAKE) -C image $@

cloud-clean: check-CLOUD check-IMAGE_NAME
	$(MAKE) CLOUD=$(CLOUD) \
	        IMAGE_NAME=$(IMAGE_NAME) \
	        -C image $@

.PHONY: image clean cloud-clean
