include ../Makefile.inc

TERRAFORM = terraform
TERRAFORM_INIT = .terraform

SOURCES = $(shell find . -type f -name "*.tf")

all: check-CLOUD check-NAME $(SOURCES) $(TERRAFORM_INIT)
	$(TERRAFORM) apply -var "cloud=$(CLOUD)" \
	                   -var "cluster=$(NAME)" \
	                   -auto-approve

$(TERRAFORM_INIT):
	$(TERRAFORM) init

clean:
	# TODO Is it wise to delete the Terraform state?

cloud-clean: check-CLOUD check-NAME
	$(TERRAFORM) destroy -var "cloud=$(CLOUD)" \
	                     -var "cluster=$(NAME)" \
	                     -auto-approve

.PHONY: all clean cloud-clean
