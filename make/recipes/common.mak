.DEFAULT_GOAL := help
.PHONY: help
help: ## Run to show available make targets and descriptions
	@echo -e "\033[1;37mAvailable targets\033[0m"
	@grep -E '^[-a-zA-Z_: ]+:.*?## .*' $(MAKEFILE_LIST)             \
	| sed -e "s/^\([^:]\+\):\([^:]\+\):\([^#]*\)##\(.*\)/\1 \2 \4/" \
	| awk '{                                                        \
	    printf "\033[36m%-45s:\033[0m \033[1;36m%-15s\033[0m ",     \
	        $$1, $$2; $$1=$$2="";                                   \
	    print $$0;                                                  \
	}';

.PHONY: show_env
show_env: ## show me my environment
	@echo -e "\033[1;37mEXPORTED ENVIRONMENT - AVAILABLE TO ALL TARGETS\033[0m"
	@env | sort | uniq

.PHONY: mandatory_vars
mandatory_vars: ## list all vars considered necessary to run build.
	@echo -e "\033[1;37mMANDATORY ENV VARS\033[0m"
	@echo -e "$(MANDATORY_VARS)" \
	| sed -e "s/ /\n/"g          \
	| sort                       \
	| awk '{ printf "\033[36m%s\033[0m\n", $$1 }'

.PHONY: print_vars
print_vars: ## show assigned values and src of all env_vars e.g. file or env
	@$(foreach V,                                           \
	    $(sort $(.VARIABLES)),                              \
	    $(if                                                \
	        $(filter-out default automatic, $(origin $V)),  \
	        $(info $V=$($V) ($(value $V)): $(origin $V))    \
	    )                                                   \
	)
	@echo -e "\033[1;37mOUTPUT: VAR=VALUE (value or code-snippet): source\033[0m"
	@echo -e "\033[1;37mRun 'make -r --print-data-base' for more debug.\033[0m"

# ... PREREQS TARGETS

.PHONY: sshkeyfile
sshkeyfile: ## Symlink local sshkey to directory to use in Packer
	@if [ -f ./$(SSH_PRIVATE_KEY_FILE) ];                                     \
	    then echo "Found sshkey: ./$(SSH_PRIVATE_KEY_FILE)";                  \
	elif [ -f ~/.ssh/$(SSH_PRIVATE_KEY_FILE) ];                               \
	then                                                                      \
	    echo "Found sshkey creating symlink: ~/.ssh/$(SSH_PRIVATE_KEY_FILE)"; \
	    ln -sf ~/.ssh/$(SSH_PRIVATE_KEY_FILE) ./$(SSH_PRIVATE_KEY_FILE);      \
	else                                                                      \
	    echo -e "\033[0;31m[ERROR] Create a copy of sshkey in $(CURDIR)"      \
	    echo -e "(or symlink): e.g ./$(SSH_PRIVATE_KEY_FILE)\e[0m\n";         \
	    exit 1;                                                               \
	fi;

# ... VALIDATION TARGETS

.PHONY: check_vars
check_vars: ## checks mandatory vars are in make's env or fails
	@echo -e "\033[1;37mChecking all vars for build are sane\033[0m";
	$(foreach A, $(MANDATORY_VARS),                                   \
	    $(if $(value $A),, $(error You must pass env var $A to make)) \
	)
	@echo "... build vars are sane. Use 'make show_env' to check for yourself."

.PHONY: valid_packer
valid_packer: ## run packer validate on packer json
	@echo -e "\033[1;37mValidating Packer json: $(PACKER_JSON)\033[0m"
	@PACKER_LOG=$(PACKER_LOG) packer validate "$(PACKER_JSON)"

PIGT=$(PACKER_INCLUDES_GIT_TAG)
.PHONY: check_includes
check_includes: ## check we use the desired packer_includes version
	@[[ -z "$(PIGT)" ]]                                                     \
	|| echo -e "\033[1;37mChecking packer_includes version: $(PIGT)\033[0m" \
	&& [[ -d packer_includes ]]                                             \
	&& cd packer_includes                                                   \
	&& [[ $$(git describe --tags) == "$(PIGT)" ]]                           \
	&& echo "... using version: $(PIGT)"
