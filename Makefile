CLOUD ?= hgi
NAME  ?= swarm
ARCH  ?= x86_64

IMAGE_NAME = $(NAME)-$(ARCH)

image:
	$(MAKE) ARCH=$(ARCH) \
	        CLOUD=$(CLOUD) \
	        IMAGE_NAME=$(IMAGE_NAME) \
	        -C $@

clean:
	$(MAKE) -C image $@

cloud-clean:
	$(MAKE) CLOUD=$(CLOUD) \
	        IMAGE_NAME=$(IMAGE_NAME) \
	        -C image $@

.PHONY: image clean cloud-clean
