ENV ?= dev
TF ?= terraform
TFVARS_FILE := environments/$(ENV).tfvars
PLAN_DIR := .terraform/plans
PLAN_FILE := $(PLAN_DIR)/$(ENV).tfplan
AUTO_APPROVE ?= false

ifeq ($(AUTO_APPROVE),true)
AUTO_APPROVE_FLAG := -auto-approve
else
AUTO_APPROVE_FLAG :=
endif

.PHONY: help check-env init workspace fmt validate plan apply apply-plan destroy output

help:
	@echo "Terraform multi-environment commands"
	@echo "Usage: make <target> ENV=dev|stage|prod [AUTO_APPROVE=true]"
	@echo ""
	@echo "Targets:"
	@echo "  init       - terraform init"
	@echo "  workspace  - select/create workspace matching ENV"
	@echo "  fmt        - terraform fmt -recursive"
	@echo "  validate   - terraform validate"
	@echo "  plan       - plan with environments/<ENV>.tfvars and save a plan file"
	@echo "  apply      - apply with environments/<ENV>.tfvars"
	@echo "  apply-plan - run plan then apply saved plan file"
	@echo "  destroy    - destroy with environments/<ENV>.tfvars"
	@echo "  output     - show terraform outputs for selected workspace"

check-env:
	@test -f "$(TFVARS_FILE)" || (echo "Missing file: $(TFVARS_FILE)" && exit 1)

init:
	$(TF) init

workspace: init
	@$(TF) workspace select "$(ENV)" > /dev/null 2>&1 || $(TF) workspace new "$(ENV)"

fmt:
	$(TF) fmt -recursive

validate: init
	$(TF) validate

plan: check-env workspace
	@mkdir -p "$(PLAN_DIR)"
	$(TF) plan -var-file="$(TFVARS_FILE)" -out="$(PLAN_FILE)"

apply: check-env workspace
	$(TF) apply $(AUTO_APPROVE_FLAG) -var-file="$(TFVARS_FILE)"

apply-plan: plan
	$(TF) apply $(AUTO_APPROVE_FLAG) "$(PLAN_FILE)"

destroy: check-env workspace
	$(TF) destroy $(AUTO_APPROVE_FLAG) -var-file="$(TFVARS_FILE)"

output: workspace
	$(TF) output
