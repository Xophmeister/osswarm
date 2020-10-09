CLOUD ?= hgi
NAME  ?= swarm

ARCH  ?= x86_64
IMAGE  = $(NAME)-$(ARCH)

image:
	echo $(ARCH)
	$(MAKE) ARCH=$(ARCH) \
	        CLOUD=$(CLOUD) \
	        IMAGE=$(IMAGE) \
	        -C $@

clean:
	$(MAKE) clean -C image

.PHONY: image clean
