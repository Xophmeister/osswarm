include ../Makefile.inc

ARCH ?= x86_64
ALPINE_VERSION ?= 3.12.0
ALPINE_FLAVOUR ?= virt

OPENSTACK = openstack

PACKER = packer
PACKER_CACHE = packer_cache

BUILD_DIR = build
IMAGE = $(BUILD_DIR)/image.qcow2

TEMPLATE = image.pkr.hcl
SOURCES = $(wildcard src/*)

all: check-CLOUD check-IMAGE_NAME
	@ if ! $(OPENSTACK) --os-cloud=$(CLOUD) image show "$(IMAGE_NAME)" >/dev/null 2>&1; then \
	  $(MAKE) deploy; \
	fi

deploy: $(IMAGE) check-CLOUD check-IMAGE_NAME
	$(OPENSTACK) --os-cloud=$(CLOUD) image create \
	  --file "$(IMAGE)" --disk-format qcow2 --shared \
	  --tag "Alpine $(ALPINE_VERSION)" --tag "Docker" --tag "Swarm" \
	  "$(IMAGE_NAME)"

$(IMAGE): $(TEMPLATE) $(SOURCES)
	rm -rf $(BUILD_DIR)
	$(PACKER) build -var "alpine_version=$(ALPINE_VERSION)" \
	                -var "alpine_flavour=$(ALPINE_FLAVOUR)" \
	                -var "architecture=$(ARCH)" \
	                "$<"

clean:
	rm -rf $(BUILD_DIR) $(PACKER_CACHE)

cloud-clean: check-CLOUD check-IMAGE_NAME
	$(OPENSTACK) --os-cloud=$(CLOUD) image delete "$(IMAGE_NAME)" || true

.PHONY: all deploy clean cloud-clean
