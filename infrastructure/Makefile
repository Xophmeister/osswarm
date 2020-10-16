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

all: check-CLOUD check-NAME check-IMAGE_NAME $(SOURCES) $(TERRAFORM_INIT) $(PUBLIC_KEY)
	$(TERRAFORM) apply -var "cloud=$(CLOUD)" \
	                   -var "cluster=$(NAME)" \
	                   -var "key=$(PUBLIC_KEY)" \
	                   -var "image=$(IMAGE_NAME)" \
	                   -var "flavour=$(FLAVOUR)" \
	                   -var "workers=$(WORKERS)" \
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

cloud-clean: check-CLOUD check-NAME check-IMAGE_NAME $(TERRAFORM_STATE)
	$(TERRAFORM) destroy -var "cloud=$(CLOUD)" \
	                     -var "cluster=$(NAME)" \
	                     -var "key=$(PUBLIC_KEY)" \
	                     -var "image=$(IMAGE_NAME)" \
	                     -var "flavour=$(FLAVOUR)" \
	                     -var "workers=$(WORKERS)" \
	                     -auto-approve

.PHONY: all clean cloud-clean
