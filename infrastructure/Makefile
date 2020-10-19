include ../common.make

TERRAFORM = terraform
TERRAFORM_INIT = .terraform
TERRAFORM_STATE = $(wildcard *.tfstate*)

SOURCES = $(shell find . -type f -name "*.tf")

KEYGEN = ssh-keygen
BACKUP_KEY = ~/.ssh/osswarm-$(NAME)_rsa
SECRET_KEY ?= $(word 1,$(wildcard ~/.ssh/id_*) $(BACKUP_KEY))
PUBLIC_KEY = $(SECRET_KEY).pub

FLAVOUR ?= m2.medium
WORKERS ?= 1

# FIXME This is for debugging
INFOBLOX_SERVER = x
INFOBLOX_USERNAME = x
INFOBLOX_PASSWORD = x

MANAGEMENT_SUBDOMAIN ?= management
SERVICE_SUBDOMAIN    ?= services

all: $(SOURCES) $(TERRAFORM_INIT) $(PUBLIC_KEY) apply

apply destroy: check-CLOUD check-NAME check-IMAGE_NAME check-DOMAIN check-INFOBLOX_SERVER check-INFOBLOX_USERNAME check-INFOBLOX_PASSWORD
	$(TERRAFORM) $@ -var "cloud=$(CLOUD)" \
	                -var "cluster=$(NAME)" \
	                -var "key=$(PUBLIC_KEY)" \
	                -var "image=$(IMAGE_NAME)" \
	                -var "flavour=$(FLAVOUR)" \
	                -var "workers=$(WORKERS)" \
	                -var "domain=$(DOMAIN)" \
	                -var "management-subdomain=$(MANAGEMENT_SUBDOMAIN)" \
	                -var "service-subdomain=$(SERVICE_SUBDOMAIN)" \
	                -auto-approve

$(TERRAFORM_INIT):
	$(TERRAFORM) init

$(PUBLIC_KEY): $(SECRET_KEY)
	$(KEYGEN) -yf $< > $@

$(SECRET_KEY):
	mkdir -p $$(dirname $@)
	$(KEYGEN) -t rsa -P "" -f $@

clean: check-NAME
	rm -rf $(TERRAFORM_INIT) $(TERRAFORM_STATE) $(BACKUP_KEY)

cloud-clean: $(TERRAFORM_STATE) destroy

.PHONY: all apply destroy clean cloud-clean
