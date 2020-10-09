include ../Makefile.inc

ARCH ?= x86_64

# Strip the patch version (e.g., 1.2.3 -> 1.2)
release = $(shell echo "$1" | cut -d. -f-2)

ALPINE_VERSION ?= 3.12.0
ALPINE_FLAVOUR ?= virt
ALPINE_ISO      = http://dl-cdn.alpinelinux.org/alpine/v$(call release,$(ALPINE_VERSION))/releases/$(ARCH)/alpine-$(ALPINE_FLAVOUR)-$(ALPINE_VERSION)-$(ARCH).iso

VENDOR_IMAGE = vendor.iso
BASE_IMAGE   = image.iso

# Download vendor image
$(VENDOR_IMAGE):
	wget -O "$@" "$(ALPINE_ISO)"

clean:
	rm -rf "$(VENDOR_IMAGE)" "$(BASE_IMAGE)"

.PHONY: clean
