include Makefile.inc

NAME ?= $(shell whoami)
ARCH ?= x86_64

# The image is the same, regardless of the name, so canonicalise it
IMAGE_NAME = osswarm-$(ARCH)

SOURCES = $(wildcard */)

infrastructure: check-CLOUD image
	$(MAKE) -C $@

image: check-CLOUD
	$(MAKE) -C $@

help: README.md
	less $<

clean cloud-clean:
	for target in $(SOURCES); do \
	  $(MAKE) -C $${target} $@; \
	done

.PHONY: infrastructure image help clean cloud-clean
.SILENT: help clean cloud-clean
.EXPORT_ALL_VARIABLES:
