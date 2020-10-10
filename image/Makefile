include ../Makefile.inc

ARCH ?= x86_64
ALPINE_VERSION ?= 3.12.0
ALPINE_FLAVOUR ?= virt

PACKER = packer
PACKER_CACHE = packer_cache

BUILD_DIR = build
IMAGE = $(BUILD_DIR)/image.qcow2

TEMPLATE = image.pkr.hcl
SOURCES = $(wildcard src/*)

$(IMAGE): $(TEMPLATE) $(SOURCES)
	rm -rf $(BUILD_DIR)
	$(PACKER) build -var "alpine_version=$(ALPINE_VERSION)" \
	                -var "alpine_flavour=$(ALPINE_FLAVOUR)" \
	                -var "architecture=$(ARCH)" \
	                "$<"

clean:
	rm -rf $(BUILD_DIR) $(PACKER_CACHE)

.PHONY: clean
