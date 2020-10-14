include ../common.make

TERRAFORM = terraform
TERRAFORM_INIT = .terraform
TERRAFORM_STATE = $(wildcard *.tfstate*)

SOURCES = $(shell find . -type f -name "*.tf")

all: check-CLOUD check-NAME $(SOURCES) $(TERRAFORM_INIT)
	$(TERRAFORM) apply -var "cloud=$(CLOUD)" \
	                   -var "cluster=$(NAME)" \
	                   -auto-approve

$(TERRAFORM_INIT):
	$(TERRAFORM) init

clean:
	rm -rf $(TERRAFORM_INIT) $(TERRAFORM_STATE)

cloud-clean: check-CLOUD check-NAME $(TERRAFORM_STATE)
	$(TERRAFORM) destroy -var "cloud=$(CLOUD)" \
	                     -var "cluster=$(NAME)" \
	                     -auto-approve

.PHONY: all clean cloud-clean
