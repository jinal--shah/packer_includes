# vim: ts=4 st=4 sr noet smartindent syntax=make ft=make:

.PHONY: help
help: ## Run to show available make targets and descriptions
	@echo -e "\033[1;37m[INFO] Packer - Available targets\033[0m"
	@grep -E '^[-a-zA-Z_: ]+:.*?## .*' $(MAKEFILE_LIST)             \
	| sed -e "s/^\([^:]\+\):\([^:]\+\):\([^#]*\)##\(.*\)/\1 \2 \4/" \
	| awk '{ \
		printf "\033[36m[%-30s]\033[0m \033[1;36m%-15s\033[0m ", \
			$$1, $$2; $$1=$$2=""; \
		print $$0; \
	}';

.PHONY: show_env
show_env: ## show me my environment
	@echo -e "\033[1;37m[INFO] EXPORTED ENVIRONMENT - AVAILABLE TO ALL TARGETS\033[0m"
	@env | sort | uniq

.PHONY: mandatory_vars
mandatory_vars: ## list all vars considered necessary to run build.
	@echo -e "\033[1;37m[INFO] MANDATORY ENV VARS\033[0m"
	@echo -e "\033[36m$(MANDATORY_VARS)\033[0m" | sed -e "s/ /\n/"g

.PHONY: check_vars
check_vars: ## checks mandatory vars are in make's env or fails
	$(foreach A, $(MANDATORY_VARS), \
		$(if $(value $A),, $(error You must pass env var $A to make)) \
	)

.PHONY: print_vars
print_vars: ## show assigned values and src of all env_vars e.g. file or environment
	@$(foreach V,                                           \
		$(sort $(.VARIABLES)),                              \
		$(if                                                \
			$(filter-out default automatic, $(origin $V)),  \
			$(info $V=$($V) ($(value $V)): $(origin $V)) \
		)                                                   \
	)
	@echo -e "\033[1;37mOUTPUT: VAR=VALUE (value's str or code-snippet): source\033]0m"

.PHONY: sshkeyfile
sshkeyfile: ## Symlink local sshkey to directory to use in Packer
	@if [ -f ./$(SSH_PRIVATE_KEY_FILE) ];                                            \
		then echo "[INFO] Found sshkey: ./$(SSH_PRIVATE_KEY_FILE)";                  \
	elif [ -f ~/.ssh/$(SSH_PRIVATE_KEY_FILE) ];                                      \
	then                                                                             \
		echo "[INFO] Found sshkey creating symlink: ~/.ssh/$(SSH_PRIVATE_KEY_FILE)"; \
		ln -sf ~/.ssh/$(SSH_PRIVATE_KEY_FILE) ./$(SSH_PRIVATE_KEY_FILE);             \
	else                                                                             \
		echo -e "\033[0;31m[ERROR] Create a copy of sshkey in current directory"     \
		echo -e "(or symlink): e.g ./$(SSH_PRIVATE_KEY_FILE)\e[0m\n";                \
		exit 1;                                                                      \
	fi;

.PHONY: validate
validate: check_vars sshkeyfile ## Run packer validate using defined variables
	@echo -e "\033[1;37mValidating Packer json: $(PACKER_JSON) \033]0m"
	@PACKER_LOG=$(PACKER_LOG) packer validate "$(PACKER_JSON)"

# TODO: on successful build, share the AMI with the AWS Prod account?
.PHONY: build
build: validate ## run packer validate then build
	@PACKER_LOG=$(PACKER_LOG) packer build $(PACKER_DEBUG) "$(PACKER_JSON)"

